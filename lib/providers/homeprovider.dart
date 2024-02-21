import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;

class HomeProvider extends ChangeNotifier {
  // properties
  bool _load = false;
  List _residences1 = [], _residences2 = [];

  // getters

  List get residences1 => _residences1;
  List get residences2 => _residences2;
  bool get load => _load;

  // setters

  // methods

  Future<void> fetchResidences() async {
    _load = true;
    _residences1 = [];
    _residences2 = [];
    try {
      final responses = await dio.Dio().get(Links.someresidences);
      // print(responses);
      if (responses.data['status']) {
        if (responses.data['data'].length <= 3) {
          _residences1 = responses.data['data'];
        } else {
          for (var i = 0; i < 3; i++) {
            _residences1.add(responses.data['data'][i]);
          }
          for (var i = 3; i < responses.data['data'].length; i++) {
            _residences2.add(responses.data['data'][i]);
          }
        }
      }
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      checkiferror(e);
    }
  }
}
