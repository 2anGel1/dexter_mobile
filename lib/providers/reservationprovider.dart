import 'dart:async';
import 'dart:convert';

import 'package:dexter_mobile/models/moyen.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends ChangeNotifier {
  //properties
  int _cost = 0,
      _nbPerson = 0,
      _id = 0,
      _nbDays = 1,
      _payment = 0,
      _selectedDay = 0;
  Map<String, dynamic> _item = {'cost': 0},
      _period = {
        'date_start': DateTime.now().toString(),
        'date_end': DateTime.now().add(const Duration(days: 1)).toString()
      };
  String _date = DateTime.now().toString(),
      _motif = "Je ne peux plus",
      _error = "",
      _trans = "";
  bool _loading = false,
      _paynow = true,
      _paymentstart = false,
      _paymentcomplete = false;
  Map<String, dynamic> _cardinformation = {};

  final List<MoyenDePaiement> _moyensdepaiement = [
    MoyenDePaiement(
        id: 1,
        name: "wave",
        image: "assets/images/moyensdepaiements/wave.png",
        channel: "Wallet",
        channelcinet: "WALLET"),
    MoyenDePaiement(
        id: 2,
        name: "orange",
        image: "assets/images/moyensdepaiements/orange.png",
        channel: "Mobile Money",
        channelcinet: "MOBILE_MONEY"),
    MoyenDePaiement(
        id: 3,
        name: "moov",
        image: "assets/images/moyensdepaiements/moov.png",
        channel: "Mobile Money",
        channelcinet: "MOBILE_MONEY"),
    MoyenDePaiement(
        id: 4,
        name: "mtn",
        image: "assets/images/moyensdepaiements/mtn.png",
        channel: "Mobile Money",
        channelcinet: "MOBILE_MONEY"),
    // MoyenDePaiement(
    //     id: 5,
    //     name: "carte",
    //     image: "assets/images/moyensdepaiements/carte.jpeg",
    //     channel: "Carte Bancaire",
    //     channelcinet: "CREDIT_CARD"),
  ];

  //getters
  Map get period => _period;
  Map<String, dynamic> get item => _item;
  String get date => _date;
  String get error => _error;
  String get motif => _motif;
  String get trans => _trans;
  int get nbDays => _nbDays;
  int get nbPerson => _nbPerson;
  int get payment => _payment;
  int get cost => _cost;
  int get selectedDay => _selectedDay;
  bool get loading => _loading;
  bool get paymentstart => _paymentstart;
  bool get paymentcomplete => _paymentcomplete;
  bool get paynow => _paynow;
  List<MoyenDePaiement> get moyensdepaiement => _moyensdepaiement;

  //setters
  setitem(Map<String, dynamic> newItem) {
    _item = newItem;
  }

  set paymentstart(p) {
    _paymentstart = p;
  }

  set paymentcomplete(p) {
    _paymentcomplete = p;
  }

  set cost(c) {
    _cost = c;
  }

  setreserv(Map<String, dynamic> element, {other}) {
    _period = {
      'date_start': element['date_start'].toString().substring(0, 10),
      'date_end': element['date_end'].toString().substring(0, 10)
    };
    _nbDays = DateTime.parse(_period['date_end'])
        .difference(DateTime.parse(_period['date_start']))
        .inDays;
    _cost =
        element['cost'] is double ? element['cost'].toInt() : element['cost'];
    _paynow = element['status'] == "Confirmée";
    _nbPerson = element['number_people'];
    if (other == null) {
      _item = element['propriety'];
    } else {
      _item = other;
    }
    _id = element['id'];
  }

  setvisit(Map<String, dynamic> element, {other}) {
    _date = element['date'];
    _cost = element['cost'];
    if (other == null) {
      _item = element['propriety'];
    } else {
      _item = other;
    }
    _id = element['id'];
  }

  setmotif(value) {
    _motif = value;
    notifyListeners();
  }

  setcardinfo(Map<String, dynamic> info) {
    _cardinformation = info;
    // print(_cardinformation);
  }

  selectday(int day) {
    _selectedDay = day;
    _date = DateTime.now().add(Duration(days: day)).toString().substring(0, 10);
    notifyListeners();
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

  updateDate(args) {
    _date = args.value.toString().substring(0, 10);
    notifyListeners();
  }

  updateNbPerson(int value) {
    _nbPerson = value;
    notifyListeners();
  }

  updatePaymment(int value) {
    _payment = value;
    notifyListeners();
  }

  updatePayNow(bool value) {
    _paynow = value;
    notifyListeners();
  }

  updateReservationCost() {
    _cost = _nbDays * int.parse(_item['cost'].toString());
  }

  updateVisiteCost(price) {
    _cost = price;
  }

  loadOn() {
    _loading = true;
    notifyListeners();
  }

  loadOff() {
    _loading = false;
    notifyListeners();
  }

  MoyenDePaiement getmodpay() {
    final pay = _moyensdepaiement
        .where((element) => element.modelid == _payment)
        .firstOrNull;
    return pay!;
  }

  //methods
  Future<void> makereservation() async {
    try {
      _loading = true;
      notifyListeners();
      final localStorage = await SharedPreferences.getInstance();
      final data = {
        'number_people': _nbPerson,
        'nbre_personne': _nbDays,
        'date_start': _period['date_start'],
        'date_end': _period['date_end'],
        'propriety_id': _item['id'],
        'user_id': localStorage.getInt("id")
      };
      // print(data);
      final response = await dio.Dio().post(Links.makereservation,
          data: data,
          options: dio.Options(headers: {
            "Authorization":
                "Bearer ${localStorage.getString("token").toString()}",
          }));

      debugPrint("CREATION DE LA RESERVATION");
      if (response.data['status']) {
        await initiatePayment(
            id: response.data['data']['id'],
            description: "Paiement pour réservation",
            source: "reservations");
        _error = "";
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> makevisite() async {
    try {
      _loading = true;
      notifyListeners();
      final localStorage = await SharedPreferences.getInstance();
      final data = {
        'cost': _payment == 0 ? 0 : 5000,
        'date': _date,
        'type': 'Simple',
        'status': "Attente",
        'propriety_id': _item['id'],
        'user_id': localStorage.getInt("id")
      };

      final response = await dio.Dio().post(Links.makevisite,
          data: data,
          options: dio.Options(headers: {
            "Authorization":
                "Bearer ${localStorage.getString("token").toString()}",
          }));
      if (response.data['status']) {
        if (_payment != 0) {
          await initiatePayment(
              id: response.data['data']['id'],
              description: "Paiement pour visite",
              source: "visites");
        }
        _error = "";
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> cancelprogramm({bool reservation = true}) async {
    try {
      _loading = true;
      notifyListeners();
      final localStorage = await SharedPreferences.getInstance();
      final data = reservation
          ? {'status': 'Annulée', 'cancellation_reason': _motif}
          : {'status': 'Annulé', 'commentaire': _motif};
      final response = reservation
          ? await dio.Dio().put("${Links.cancelreservation}/$_id",
              data: data,
              options: dio.Options(headers: {
                "Authorization":
                    "Bearer ${localStorage.getString("token").toString()}",
              }))
          : await dio.Dio().post("${Links.cancelvisit}/$_id",
              data: data,
              options: dio.Options(headers: {
                "Authorization":
                    "Bearer ${localStorage.getString("token").toString()}",
              }));

      if (response.data['status']) {
        _error = "";
      }
      _loading = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> initiatePayment(
      {required id, description = "Paiement", source = "reservations"}) async {
    try {
      final localStorage = await SharedPreferences.getInstance();
      final pay = _moyensdepaiement
          .where((element) => element.modelid == _payment)
          .firstOrNull;

      final data = {
        "description":
            "Paiement pour ${source == "reservations" ? "reservation" : "visite"} Dexter Immo",
        "source": source,
        "reservation_id": source == "reservations" ? id : null,
        "visit_id": source == "reservations" ? null : id,
        "channels": pay!.modelchannel
      };
      print(data);
      final response = await dio.Dio().post(Links.initpayment,
          data: data,
          options: dio.Options(headers: {
            "Authorization":
                "Bearer ${localStorage.getString("token").toString()}",
          }));

      debugPrint("INITILISATION DU PAIEMENT");
      if (response.data['status']) {
        print(response.data['data']['trans_id']);
        _trans = response.data['data']['trans_id'];
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      notifyListeners();
    }
  }

  Future<void> checkPayment() async {
    try {
      final data = {
        'cpm_trans_id': _trans,
        'cpm_site_id': Links.cinetpaysiteid
      };
      var response = await http.post(Uri.parse(Links.checkpayment), body: data);
      final res = jsonDecode(response.body.toString().split("</style>")[1]);

      if (res['transaction'] != null) {
        print(res['transaction']);
        if (res['transaction']['status'] != "SUCCESS") {
          _paymentcomplete = false;
        } else {
          _paymentcomplete = true;
        }
      } else {
        _paymentcomplete = false;
        print(res['error']);
      }
    } catch (e) {
      debugPrint("SOMTHING WENT WRONG");
      print(e);
    }
  }

  reset() {
    _cost = 0;
    _nbPerson = 0;
    _id = 0;
    _nbDays = 1;
    _selectedDay = 0;
    _payment = 0;
    _paymentcomplete = false;
    _paymentstart = false;
    _item = {'cost': 0};
    _period = {
      'date_start': DateTime.now().toString(),
      'date_end': DateTime.now().add(const Duration(days: 1)).toString()
    };
    _loading = false;
    _paynow = true;
    _date = _date = DateTime.now().toString();
    notifyListeners();
  }
}
