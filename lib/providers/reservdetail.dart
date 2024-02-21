import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class ReservDetailProvider extends ChangeNotifier {
  Map<String, dynamic> _item = {'id': 0};
  bool _load = true, _available = false;
  String _error = "", _loctype = "", _category = "";
  List<String> _persons = [];
  // getters

  String get error => _error;
  String get loctype => _loctype;
  String get category => _category;
  Map<String, dynamic> get item => _item;
  List<String> get persons => _persons;
  bool get available => _available;
  bool get load => _load;

  // setters
  setitemid(int newid) {
    _item['id'] = newid;
    notifyListeners();
  }

  // methods
  Future<void> loadItem({fromInside = false}) async {
    _load = true;
    if (fromInside) {
      notifyListeners();
    }
    try {
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token").toString();
      final response =
          await dio.Dio().get("${Links.getproperty}/${_item['id']}",
              options: dio.Options(headers: {
                "Authorization": "Bearer $token",
              }));
      if (response.data['status']) {
        _item = response.data['data'];
        _error = "";
        // print(_item['photos']);

        List<DateTime> dates = [];
        if (_item['category']['label'] == "Résidence") {
          _category = "res";
          if (_item['person_maxi'] != null) {
            _persons = [];
            for (var i = 1; i <= _item['person_maxi']; i++) {
              _persons.add(i.toString());
            }
          }
          List reservs = _item['reservations'];
          for (var res in reservs) {
            if (res['status'] != 'Annulée') {
              final start =
                  DateTime.parse(res['date_start'].toString().substring(0, 10));
              final end =
                  DateTime.parse(res['date_end'].toString().substring(0, 10));
              final days = end.difference(start).inDays;
              dates.add(start);
              for (var i = 1; i < days; i++) {
                dates.add(start.add(Duration(days: i)));
              }
            }
          }
        } else if (_item['category']['label'] == "Maison") {
          _category = "mai";
        } else {
          _category = "ter";
        }
        _item['busy_dates'] = dates;
        //
        if (_item['types']['label'] == "Vente") {
          _loctype = "ven";
        } else if (_item['types']['label'] == "Location") {
          _loctype = "loc";
        }
        //
        _available = _item['status'] == "Disponible";
      }

      // print(_item['user']);
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }
}
