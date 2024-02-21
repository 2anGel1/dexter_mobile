import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SearchProvider extends ChangeNotifier {
  // properties
  Map<String, dynamic> _filter = {};
  List _categories = [],
      _cities = [],
      _municipalities = [],
      _results = [],
      _types = ['Appartement', 'Villa', 'Maison basse'],
      _loctypes = [];
  String _error = "";
  SfRangeValues _rangeamount = const SfRangeValues(5000.0, 1000000.0);

  bool _load = false;
  // getters

  Map<String, dynamic> get filter => _filter;
  List get results => _results;
  List get categories => _categories;
  List get cities => _cities;
  List get municipalities => _municipalities;
  List get loctypes => _loctypes;
  List get types => _types;
  SfRangeValues get rangeamount => _rangeamount;
  String get error => _error;
  bool get load => _load;

  // setters

  selectcategory(String keyword) {
    _filter['category_id'] = keyword;
    if (keyword == "") {
      _filter.remove('category_id');
    }
    notifyListeners();
  }

  selectcity(String keyword) {
    _filter['city_id'] = keyword;
    if (keyword == "") {
      _filter.remove('city_id');
    }
    notifyListeners();
  }

  selectmunicipality(String keyword) {
    _filter['municipality_id'] = keyword;
    if (keyword == "") {
      _filter.remove('municipality_id');
    }
    notifyListeners();
  }

  selectloctype(String keyword) {
    _filter['type_id'] = keyword;
    if (keyword == "") {
      _filter.remove('type_id');
    }
    notifyListeners();
  }

  selecttype(String keyword) {
    _filter['type'] = keyword;
    if (keyword == "") {
      _filter.remove('type');
    }
    notifyListeners();
  }

  setname(String keyword) {
    _filter['name'] = keyword;
    if (keyword == "") {
      _filter.remove('name');
    }
  }

  updaterangeamount(SfRangeValues range) {
    _rangeamount = range;
    _filter['minPrix'] = range.start;
    _filter['maxPrix'] = range.end;
    notifyListeners();
  }

  // methods

  Future<void> loaddata() async {
    _load = true;
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");

    await Future.wait([
      dio.Dio().get(Links.getcategories,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
      dio.Dio().get(Links.getcities,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
      dio.Dio().get(Links.getmunicipalities,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
      dio.Dio().get(Links.gettypes,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }))
    ]).then((responses) {
      if (responses[0].data['status']) {
        _categories = responses[0].data['data'];
      }
      if (responses[1].data['status']) {
        _cities = responses[1].data['data'];
      }
      if (responses[2].data['status']) {
        _municipalities = responses[2].data['data'];
      }
      if (responses[3].data['status']) {
        _loctypes = responses[3].data['data'];
      }
      _filter = {};
      _error = "";
      _load = false;
      notifyListeners();
      // print(_municipalities);
    }).catchError((e) {
      print(e);
      _load = false;
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> search({fromfilter = false, firsttime = false}) async {
    if (firsttime) {
      await loaddata();
    }
    _load = true;
    if (fromfilter) {
      notifyListeners();
    }
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token").toString();
    _results = [];
    try {
      final response = await dio.Dio().post(Links.search,
          data: filter,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));
      // print(response);
      if (response.data['status']) {
        _results = List.from(response.data['data']).reversed.toList();
      }
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  resetfilter() {
    _filter = {};
    _rangeamount = const SfRangeValues(5000.0, 1000000.0);
    notifyListeners();
  }
}
