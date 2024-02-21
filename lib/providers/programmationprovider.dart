import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProgrammationProvider extends ChangeNotifier {
  // properties

  List _reservations = [];
  List _visites = [];
  List<DateTime> _busydates = [];
  bool _load = false, _cancel = false, _startcancel = false;
  String _error = "", _status = "";
  int _nbDays = 0, _currentDays = 0, _id = 0;
  final Map<String, dynamic> _period = {
    'date_start': DateTime.now().toString(),
    'date_end': DateTime.now().add(const Duration(days: 1)).toString()
  };

  // setter

  set startcancel(b) {
    _startcancel = b;
  }

  // getter

  List get reservations => _reservations;
  List get visites => _visites;
  List<DateTime> get busydates => _busydates;
  bool get load => _load;
  bool get cancel => _cancel;
  bool get startcancel => _startcancel;
  String get error => _error;
  String get status => _status;
  Map<String, dynamic> get period => _period;
  int get nbDays => _nbDays;
  int get currentDays => _currentDays;

  // methods

  setreservationdetails(item) {
    _period['date_start'] = item['date_start'];
    _period['date_end'] = item['date_end'];
    _currentDays = DateTime.parse(_period['date_end'])
        .difference(DateTime.parse(_period['date_start']))
        .inDays;
    _nbDays = _currentDays;
    _status = item['status'] == "Annulée" ? "cancelled" : "other";
    _id = item['id'];

    _startcancel = false;
    _cancel = false;
  }

  setvisitdetails(item) {
    _id = item['id'];
    _status = item['status'] == "Annulé" ? "cancelled" : "other";

    _startcancel = false;
    _cancel = false;
  }

  updatePeriod(DateRangePickerSelectionChangedArgs args) {
    _period['date_start'] = args.value.startDate.toString().substring(0, 10);
    if (args.value.endDate == null) {
      _period['date_end'] = _period['date_start']!;
    } else {
      _period['date_end'] = args.value.endDate.toString().substring(0, 10);
    }
    _nbDays = DateTime.parse(_period['date_end'])
        .difference(DateTime.parse(_period['date_start']))
        .inDays;
    notifyListeners();
  }

  Future<void> loaddata() async {
    _load = true;
    final localstorage = await SharedPreferences.getInstance();
    final id = localstorage.getInt("id");
    final token = localstorage.getString("token");

    try {
      //
      final response = await dio.Dio().get('${Links.getuserprograms}/$id',
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        _reservations =
            List.from(response.data['data']['reservations']).reversed.toList();
        _visites = List.from(response.data['data']['visits']).reversed.toList();
      }

      _load = false;
      notifyListeners();

      //
    } on dio.DioException catch (e) {
      print(e.response);
      _error = e.response.toString();
      _load = false;
      notifyListeners();
    }
  }

  Future<void> getbusydates(id) async {
    try {
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token").toString();
      final response = await dio.Dio().get("${Links.getproperty}/$id}",
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        List<DateTime> dates = [];
        final List reservs = response.data['data']['reservations'];
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
        _busydates = dates;
      }

      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  Future<void> cancelreservation({bool pp = true}) async {
    try {
      _cancel = true;
      notifyListeners();
      final localStorage = await SharedPreferences.getInstance();
      final data = pp
          ? {
              'date_start': _period['date_start'],
              'date_end': _period['date_end'],
            }
          : {
              'status': 'Annulée',
            };
      final response = await dio.Dio().put("${Links.cancelreservation}/$_id",
          data: data,
          options: dio.Options(headers: {
            "Authorization":
                "Bearer ${localStorage.getString("token").toString()}",
          }));

      if (response.data['status']) {
        print(response.data);
        _error = "";
      }
      _cancel = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _cancel = false;
      notifyListeners();
    }
  }

  Future<void> cancelvisite() async {
    try {
      _cancel = true;
      notifyListeners();
      final localStorage = await SharedPreferences.getInstance();
      final data = {'status': 'Annulé', 'commentaire': "Annulation"};
      final response = await dio.Dio().post("${Links.cancelvisit}/$_id",
          data: data,
          options: dio.Options(headers: {
            "Authorization":
                "Bearer ${localStorage.getString("token").toString()}",
          }));

      if (response.data['status']) {
        _error = "";
      }
      _cancel = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _cancel = false;
      notifyListeners();
    }
  }
}
