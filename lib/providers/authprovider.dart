import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  //properties

  String _firstName = "",
      _lastName = "",
      _email = "",
      _phone = "",
      _cni = "",
      _token = "",
      _error = "";
  bool _connected = false,
      _active = false,
      _load = false,
      _loadpass = false,
      _loadpassreset = false,
      _isowner = false,
      _isprop = false,
      _policy = false;

  int _id = 0;
  List _roles = [], _myroles = [2];

  //getters

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get phone => _phone;
  String get token => _token;
  String get error => _error;
  String get cni => _cni;
  List get roles => _roles;
  List get myroles => _myroles;
  bool get connected => _connected;
  bool get active => _active;
  bool get load => _load;
  bool get loadpass => _loadpass;
  bool get loadpassreset => _loadpassreset;
  bool get isowner => _isowner;
  bool get isprop => _isprop;
  bool get policy => _policy;
  int get id => _id;

  //setters

  setOwnership() {
    for (var role in _roles) {
      if (role['label'] == "Propriétaire") {
        _isowner = true;
        _isprop = false;
        break;
      }
    }
    notifyListeners();
  }

  setisprop() {
    _isprop = !_isprop;
    updatemyroles();
    notifyListeners();
  }

  updatepolicy() {
    _policy = !_policy;
    notifyListeners();
  }

  updatemyroles() {
    if (_isprop) {
      _myroles.add(3);
    } else {
      _myroles.remove(3);
    }
  }

  //methods

  setstate() async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setString("token", _token);
    localStorage.setInt("id", _id);
    localStorage.setBool("connected", _connected);
    localStorage.setBool("active", _active);
  }

  loadstate() async {
    final localStorage = await SharedPreferences.getInstance();
    // localStorage.clear();
    _token = localStorage.getString("token") ?? "";
    _id = localStorage.getInt("id") ?? 0;
    _connected = localStorage.getBool("connected") ?? false;
  }

  Future<void> login(data) async {
    _load = true;
    notifyListeners();
    try {
      _email = data['email'];
      bool isadmin = false;
      final response = await dio.Dio().post(Links.login, data: data);
      // print(response);
      if (response.data['status']) {
        _token = response.data['access_token'];
        _id = response.data['data']['id'];
        _firstName = response.data['data']['firstname'];
        _lastName = response.data['data']['lastname'];
        _phone = response.data['data']['phone'];
        _cni = response.data['data']['cni_doc'] ?? "";
        _active = response.data['data']['status'];
        _roles = response.data['data']['roles'];
        _connected = true;
        if (_roles.contains("Manager") ||
            _roles.contains("Superviseur") ||
            _roles.contains("Comptable") ||
            _roles.contains("Commercial")) {
          isadmin = true;
        }

        if (isadmin) {
          _error = "Vous n'êtes pas un utilisateur";
          resetauth();
        } else {
          _error = "";
          setOwnership();
          await setstate();
        }
      } else {
        _error = response.data.message;
      }
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final response = await dio.Dio().post(Links.logout,
          options: dio.Options(headers: {
            "Authorization": "Bearer $_token",
          }));
      if (response.data['status']) {
        _error = "";
        await resetauth();
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
    }
  }

  Future<void> signup(Map<String, dynamic> data) async {
    _load = true;
    notifyListeners();
    try {
      _firstName = data['firstname'];
      _lastName = data['lastname'];
      _phone = data['phone'];
      _email = data['email'];
      _roles = data['roles'];
      final FilePickerResult? file = data['cni'];
      if (file != null) {
        final File filetosend = File(file.files.single.path!);
        List<int> fileBytes = await filetosend.readAsBytes();
        String base64File = base64Encode(fileBytes);
        List<Map<String, dynamic>> files = [
          {
            'filename':
                'useridentitydoc_0-${Random().nextInt(100)}${Random().nextInt(100)}.${file.files.single.extension}',
            'data': base64File
          }
        ];
        data['cni_doc'] = files;
        data.remove('cni');
        data['meilleur'] = true;
      }
      final response = await dio.Dio().post(Links.signup, data: data);
      if (response.data['status']) {
        _error = "";
      } else {
        _error = response.data.message;
      }
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  Future<void> loaduser() async {
    try {
      final response = await dio.Dio().get("${Links.getuserbyid}/$_id",
          options: dio.Options(headers: {
            "Authorization": "Bearer $_token",
          }));
      if (response.data['status']) {
        _error = "";
        _id = response.data['data']['id'];
        _firstName = response.data['data']['firstname'];
        _lastName = response.data['data']['lastname'];
        _email = response.data['data']['email'];
        _phone = response.data['data']['phone'];
        _cni = response.data['data']['cni_doc'] ?? "";
        _active = response.data['data']['status'];
        _roles = response.data['data']['roles'];
        _connected = true;
        setOwnership();
        await setstate();
      } else {
        _error = response.data.message;
      }
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
    }
  }

  Future<void> updateuser(Map<String, dynamic> data) async {
    _load = true;
    notifyListeners();
    final localstorage = await SharedPreferences.getInstance();
    final userid = localstorage.getInt('id')!;
    final FilePickerResult? file = data['cni'];
    if (file != null) {
      final File filetosend = File(file.files.single.path!);
      List<int> fileBytes = await filetosend.readAsBytes();
      String base64File = base64Encode(fileBytes);
      List<Map<String, dynamic>> files = [
        {
          'filename':
              'useridentitydoc_0$userid-${Random().nextInt(100)}${Random().nextInt(100)}.${file.files.single.extension}',
          'data': base64File
        }
      ];
      data['cni_doc'] = files;
      data.remove('cni');
      data['meilleur'] = true;
      data['roles'] = [2, 3];
    }

    try {
      final response = await dio.Dio().post("${Links.updateuser}/$userid",
          data: data,
          options: dio.Options(headers: {
            "Authorization": "Bearer $_token",
          }));

      if (response.data['status']) {
        loaduser();
        _load = false;
        _error = "";
        notifyListeners();
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  Future<void> updateuserpassword(Map<String, dynamic> data) async {
    _loadpass = true;
    notifyListeners();

    try {
      final response = await dio.Dio().post(Links.updateuserpassword,
          data: data,
          options: dio.Options(headers: {
            "Authorization": "Bearer $_token",
          }));

      if (response.data['status']) {
        loaduser();
        _loadpass = false;
        _error = "";
        notifyListeners();
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loadpass = false;
      notifyListeners();
    }
  }

  Future<void> resertpassword(umail) async {
    _loadpassreset = true;
    notifyListeners();
    // print(umail);
    try {
      final response =
          await dio.Dio().post(Links.resetpassword, data: {'email': umail});
      if (response.data['status']) {
        // print(response);
        _error = "";
      } else {
        _error = response.data.message;
      }
      _loadpassreset = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loadpassreset = false;
      notifyListeners();
    }
  }

  resetauth() async {
    _firstName = "";
    _lastName = "";
    _email = "";
    _phone = "";
    _token = "";
    _active = false;
    _connected = false;
    _isowner = false;
    _isprop = false;
    _policy = false;
    _roles = [];
    _myroles = [2];
    _cni = "";
    _id = 0;

    final localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
    notifyListeners();
  }
}
