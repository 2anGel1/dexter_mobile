import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final cfaformat = NumberFormat.currency(
    locale: 'eu',
    customPattern: '#,### \u00a4',
    symbol: 'XOF',
    decimalDigits: 2);

String checkiferror(DioException e) {
  debugPrint(" ERROR MESSAGE: ${e.response}");
  debugPrint(" ERROR CODE: ${e.response!.statusCode}");
  String error = "";
  switch (e.response!.statusCode) {
    case 500:
      error = "Erreur 500: Contact your customer for more information";
      break;
    case 404:
      error = "Erreur 404: Contact your customer for more information";
      break;
    case 403:
      if (e.response != null) {
        if (e.response!.data != null) {
          error = e.response!.data['message'];
        } else {
          error = jsonDecode(e.response!.toString())['message'];
        }
      }
      break;
    case 409:
      if (e.response != null) {
        if (e.response!.data != null) {
          error = e.response!.data['message'];
        } else {
          error = jsonDecode(e.response!.toString())['message'];
        }
      }
      break;
    case 422:
      if (e.response != null) {
        if (e.response!.data != null) {
          error = e.response!.data['message'];
        } else {
          error = jsonDecode(e.response!.toString())['message'];
        }
      }
      break;
    case 401:
      error = jsonDecode(e.response!.toString())['message'];
      break;
    default:
      error = "Unkwon error: Contact your customer for more information";
      break;
  }

  return error;
}

const Color gold = Color.fromRGBO(200, 168, 65, 1);
const Color goldLight = Color.fromRGBO(236, 217, 156, 1);
final Color mainBlue = Colors.blue[800]!;

getTotal(List liste) {
  num total = 0;
  for (var element in liste) {
    total += element['cost'];
  }
  return total;
}
