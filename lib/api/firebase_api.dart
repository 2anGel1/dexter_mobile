import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;

Future<void> handleBackgroundMessage() async {}

class FireBaseApi {
  //
  final _firebaseMessaging = FirebaseMessaging.instance;
  late SharedPreferences localStorage;
  //

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    debugPrint("---AUTHORIZATION STATUS---");

    localStorage = await SharedPreferences.getInstance();

    debugPrint("---GENERATED TOKEN---");
    _firebaseMessaging.getToken().then((token) async {
      debugPrint("---DEVICE TOKEN FOR NOTIFICATION---");
      debugPrint(token);
      debugPrint("---DEVICE TOKEN FOR NOTIFICATION---\n");

      localStorage.getString("device") == null
          ? await createDeviceToken(token)
          : await updateDeviceToken(token);
    });
  }

  Future<void> createDeviceToken(token) async {
    debugPrint("---CREATE NEW DEVICE---");
    try {
      final req =
          await dio.Dio().post(Links.notifications, data: {"token": token});
      if (req.data['status']) {
        debugPrint("---WEL DONE---");
        localStorage.setString("device", (jsonEncode(req.data['data'])));
      }
    } catch (e) {
      debugPrint("---REQUEST ERROR---");
      print(e);
    }
  }

  Future<void> updateDeviceToken(token) async {
    debugPrint("---UPDATE DEVICE TOKEN DEVICE---");
    Map<String, dynamic> device =
        jsonDecode(localStorage.getString("device").toString());
    try {
      final req = await dio.Dio()
          .put("${Links.notifications}/${device['id']}", data: {"token": token});
      if (req.data['status']) {
        debugPrint("---WEL DONE---");
        localStorage.setString("device", (jsonEncode(req.data['data'])));
      }
    } catch (e) {
      debugPrint("---REQUEST ERROR---");
      print(e);
    }
  }
}
