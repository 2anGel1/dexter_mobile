import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RapportsProvider extends ChangeNotifier {
  // properties

  List _sollicitations = [];
  List _paiements = [];
  Map _good = {};
  int _goodId = 0;
  bool _load = false;
  String _error = "";

  // setter

  setgoodid(id) {
    _goodId = id;
  }

  // getter

  List get sollicitations => _sollicitations;
  List get paiements => _paiements;
  String get error => _error;
  bool get load => _load;
  Map get good => _good;

  // methods

  Future<void> loaddata() async {
    _load = true;
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");

    try {
      await Future.wait([
        dio.Dio().get("${Links.getproperty}/$_goodId",
            options: dio.Options(headers: {
              "Authorization": "Bearer $token",
            })),
        dio.Dio().get("${Links.getuserpayments}/$_goodId",
            options: dio.Options(headers: {
              "Authorization": "Bearer $token",
            })),
        dio.Dio().get("${Links.getuserpaymentsencours}/$_goodId",
            options: dio.Options(headers: {
              "Authorization": "Bearer $token",
            })),
      ]).then((responses) {
        // print("data 1");
        _good = responses[0].data['data'];
        final vi = responses[0].data['data']['visits'];
        final re = responses[0].data['data']['reservations'];
        _sollicitations = List.from(vi + re).reversed.toList();

        List liste1 = [];
        _paiements = [];

        if (responses[1].data['payments'] is List) {
          // ---
        } else {
          final Map<String, dynamic> liste = responses[1].data['payments'];
          for (var key in liste.keys) {
            liste1.add({key: liste[key]});
          }
          debugPrint("L1");
          debugPrint(liste.length.toString());
        }

        if (responses[2].data['payments'] is List) {
          // ---
        } else {
          final Map<String, dynamic> liste = responses[2].data['payments'];
          for (var key in liste.keys) {
            liste1.add({key: liste[key]});
          }
          debugPrint("L2");
          debugPrint(liste.length.toString());
        }

        _paiements = liste1.reversed.toList();

        _load = false;
        _error = "";
        notifyListeners();
      });
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  //
  Future<void> validatePayment() async {
    try {
      _load = true;
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token");

      final response = await dio.Dio().post(Links.validatepayment,
          // data: {},
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        _error = "";
      } else {
        _error = response.data['message'];
      }
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }
}
