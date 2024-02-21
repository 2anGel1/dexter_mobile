import 'dart:convert';
import 'package:dexter_mobile/models/property.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyProvider extends ChangeNotifier {
  // properties

  Property _property = Property(
      name: "",
      type: "",
      address: "",
      description: "",
      registeredBy: "fournisseur",
      cost: "",
      room: "",
      lot: "",
      ilot: "",
      area: "",
      personMaxi: "",
      limitpersoday: "",
      municipalityId: 0,
      categoryId: 0,
      id: 0,
      userId: 0,
      available: false);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gpsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _ilotController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _personmaxiController = TextEditingController();
  final TextEditingController _cautionController = TextEditingController();
  final TextEditingController _limitpersodayController =
      TextEditingController();

  String _selectedtype = "Appartement", _documents = "", _error = "";
  int _id = 0, _userId = 0, _selectedmunicipality = 0, _selectedloctype = 0;
  Map _selectedcity = {}, _selectedcategory = {}, _selectedcomodity = {};
  List _images = [],
      _comodites = [],
      _categories = [],
      _municipalities = [],
      _cities = [],
      _types = const ['Appartement', 'Maison basse', 'Villa'],
      _comvalues = [1, 2, 3, 4, 5],
      _allComodities = [],
      _properties = [],
      _loctypes = [];

  bool _load = false, _loadsend = false;
  bool _available = false, _published = false;

  // getters

  List get categories => _categories;
  List get cities => _cities;
  List get municipalities => _municipalities;
  List get types => _types;
  List get loctypes => _loctypes;
  List get comodites => _comodites;
  List get allcomodities => _allComodities;
  List get comvalues => _comvalues;
  List get images => _images;
  List get properties => _properties;
  int get selectedmunicipality => _selectedmunicipality;
  int get selectedloctype => _selectedloctype;
  int get id => _id;
  Map get selectedcategory => _selectedcategory;
  Map get selectedcity => _selectedcity;
  Map get selecetedcomodity => _selectedcomodity;
  String get selectedtype => _selectedtype;
  String get documents => _documents;
  String get error => _error;
  bool get load => _load;
  bool get available => _available;
  bool get loadsend => _loadsend;
  bool get published => _published;

  Property get item => _property;
  TextEditingController get nameController => _nameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get gpsController => _gpsController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get costController => _costController;
  TextEditingController get roomController => _roomController;
  TextEditingController get lotController => _lotController;
  TextEditingController get ilotController => _ilotController;
  TextEditingController get areaController => _areaController;
  TextEditingController get personMaxiController => _personmaxiController;
  TextEditingController get cautionController => _cautionController;
  TextEditingController get limitpersodayController => _limitpersodayController;

  // setters

  setid(id) {
    _id = id;
  }

  selectecategory(value) {
    _selectedcategory = value;
    notifyListeners();
  }

  selectecity(value) {
    _selectedcity = value;
    _municipalities = _selectedcity['municipalities'];
    if (_municipalities.isNotEmpty) {
      _selectedmunicipality = _municipalities[0]['id'];
    }
    notifyListeners();
  }

  selectemunicipality(value) {
    _selectedmunicipality = value;
    notifyListeners();
  }

  selectetype(value) {
    _selectedtype = value;
    notifyListeners();
  }

  selecteloctype(value) {
    _selectedloctype = value;
    notifyListeners();
  }

  selectcomodity(value) {
    _selectedcomodity = value;
    notifyListeners();
  }

  updatedocuments(value) {
    _documents = value;
    notifyListeners();
  }

  updateimages(value, bool delete) {
    if (delete) {
      _images.remove(value);
    } else {
      _images.add(value);
    }
    notifyListeners();
  }

  updatecomodity(value, numb, bool delete) {
    if (delete) {
      var el;
      for (var element in _comodites) {
        if (element['comodity_id'] == value) {
          el = element;
        }
      }
      _comodites.remove(el);
    } else {
      for (var element in _comodites) {
        if (element['comodity_id'] == value) {
          element['number'] = numb;
        }
      }
    }
    notifyListeners();
  }

  addcomodity(Map value) {
    _comodites.add(
        {'comodity_id': value['id'], 'number': 1, 'label': value['label']});
    notifyListeners();
  }

  // methods
  resetProperty() {
    _images = [];
    _comodites = [];
    _categories = [];
    _municipalities = [];
    _loctypes = [];
    _cities = [];
    _allComodities = [];
    _properties = [];
    _selectedtype = "Appartement";
    _error = "";
    _id = 0;
    _userId = 0;
    _selectedmunicipality = 0;
    _selectedloctype = 0;
    _selectedcity = {};
    _selectedcategory = {};
    _selectedcomodity = {};
    _documents = "";
    _nameController.clear();
    _addressController.clear();
    _gpsController.clear();
    _descriptionController.clear();
    _costController.clear();
    _roomController.clear();
    _lotController.clear();
    _ilotController.clear();
    _areaController.clear();
    _cautionController.clear();
    _personmaxiController.clear();
    _limitpersodayController.clear();
    _property = Property(
        name: "",
        type: "",
        address: "",
        description: "",
        registeredBy: "fournisseur",
        cost: "",
        room: "",
        lot: "",
        ilot: "",
        area: "",
        personMaxi: "",
        limitpersoday: "",
        municipalityId: 0,
        categoryId: 0,
        id: 0,
        userId: 0,
        available: false);
  }

  Future<void> init({update = false}) async {
    _load = true;
    // notifyListeners();
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");
    _userId = localstorage.getInt('id')!;

    await Future.wait([
      dio.Dio().get(Links.getcategories,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
      dio.Dio().get(Links.getcities,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
      dio.Dio().get(Links.getcomodities,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
      dio.Dio().get(Links.gettypes,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          })),
    ]).then((responses) {
      if (responses[0].data['status']) {
        _categories = responses[0].data['data'];
        _selectedcategory = _categories[0] ?? {};
      }
      if (responses[1].data['status']) {
        _cities = responses[1].data['data'];
        _selectedcity = _cities[0] ?? {};
        _municipalities = _selectedcity['municipalities'];
        if (_municipalities.isNotEmpty) {
          _selectedmunicipality = _municipalities[0]['id'];
        }
      }
      if (responses[2].data['status']) {
        if (responses[2].data['status']) {
          _allComodities = responses[2].data['data'];
          _selectedcomodity = _allComodities[0];
          _comodites = [];
        }
        _loctypes = responses[3].data['data'];
        _selectedloctype = _loctypes[0]['id'];
      }
      _load = false;
      _error = "";
      if (!update) {
        notifyListeners();
      }
    }).catchError((e) {
      // print(e.toString());
      _error = e.toString();
      _load = false;
      notifyListeners();
    });
  }

  switchavailable() async {
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");
    _userId = localstorage.getInt('id')!;

    _available = !_available;
    final newSatus = _available
        ? "Disponible"
        : _selectedloctype == 1
            ? "Vendu"
            : "Louer";

    final data = {'status': newSatus};
    final url = "${Links.updatepropertystatus}/$_id";
    try {
      final response = await dio.Dio().post(url,
          data: data,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        loaditem();
        getdata();
      } else {
        // print(response.data);
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _available = !_available;
      notifyListeners();
    }
  }

  Future<void> addproperty(bool update) async {
    try {
      _loadsend = true;
      notifyListeners();
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token");
      final uid = localstorage.getInt("id");

      final url =
          update ? "${Links.updateproperty}/$_id" : Links.createproperty;

      Map<String, dynamic> data = {
        "name": _nameController.text,
        "cost": _costController.text,
        "area": _areaController.text.isEmpty ? null : _areaController.text,
        // "limit_perso_day": _limitpersodayController.text,
        "adress":
            _addressController.text.isEmpty ? null : _addressController.text,
            "localisation_gps":
            _gpsController.text.isEmpty ? null : _gpsController.text,
        "type": _selectedtype,
        "ilot": _ilotController.text.isEmpty ? null : _ilotController.text,
        "lot": _lotController.text.isEmpty ? null : _lotController.text,
        "room": _roomController.text.isEmpty ? null : _roomController.text,
        "municipality_id": _selectedmunicipality,
        "category_id": _selectedcategory['id'],
        "type_id": _selectedloctype,
        "caution":
            _cautionController.text.isEmpty ? null : _cautionController.text,
        "description": _descriptionController.text,
        "person_maxi": _personmaxiController.text.isEmpty
            ? null
            : _personmaxiController.text,
        "registered_by": "fournisseur",
        "document": _documents.isEmpty ? null : _documents,
        "meilleur": true,
        "user_id": uid
      };

      // ADDING COMMODITIES
      List dCom = [];
      for (var element in _comodites) {
        dCom.add(jsonEncode(element));
      }
      data['comodites'] = jsonEncode(dCom);

      print("DONNEE A ENVOYER:\n");
      print(data);

      final dataToSend = dio.FormData.fromMap(data);
      final response = await dio.Dio().post(url,
          data: dataToSend,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        _id = response.data['data']['id'];
        if (_images.isNotEmpty) {
          await addimages(_id);
        }
        _error = "";
        if (update) {
          loaditem();
        } else {
          resetProperty();
        }
        getdata();
      } else {
        // print(response.data);
        _error = response.data['message'];
      }
      _loadsend = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loadsend = false;
      notifyListeners();
    }
  }

  Future<void> makerequest() async {
    try {
      _loadsend = true;
      notifyListeners();
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token");

      Map<String, dynamic> data = {
        "cost": _costController.text,
        "person_maxi": _personmaxiController.text,
        "description": _descriptionController.text,
        "propriety_id": _id,
        "meilleur": true,
      };

      // print(_id);

      final dataToSend = dio.FormData.fromMap(data);
      final response = await dio.Dio().post(Links.requestupdateproperty,
          data: dataToSend,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        _error = "";
        loaditem();
        getdata();
      } else {
        _error = response.data['message'];
      }
      _loadsend = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loadsend = false;
      notifyListeners();
    }
  }

  Future<void> addimages(pid) async {
    try {
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token");

      List<Map<String, dynamic>> images = [];
      for (var file in _images) {
        if (file is XFile) {
          List<int> fileBytes = await file.readAsBytes();
          String base64File = base64Encode(fileBytes);
          images.add({
            'filename':
                file.name.toString().substring(13, file.name.toString().length),
            'data': base64File
          });
        }
      }

      if (images.isNotEmpty) {
        final Map<String, dynamic> data = {
          'propriety_id': pid,
          'image': images,
          'meilleur': true
        };

        final dataToSend = dio.FormData.fromMap(data);
        final response = await dio.Dio().post(Links.addimages,
            data: dataToSend,
            options: dio.Options(headers: {
              "Authorization": "Bearer $token",
            }));

        if (response.data['status']) {
          debugPrint("images added");
          _error = "";
        } else {
          // print(response.data);
          _error = response.data['message'];
        }
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loadsend = false;
      notifyListeners();
    }
  }

  Future<void> removeimage(iid) async {
    try {
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token");

      final response = await dio.Dio().delete("${Links.removeimage}/$iid",
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));

      if (response.data['status']) {
        debugPrint("image removed");
        // resetProperty();
        _error = "";
        loaditem();
        getdata();
      } else {
        // print(response.data);
        _error = response.data['message'];
      }
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _loadsend = false;
      notifyListeners();
    }
  }

  Future<void> getdata({bool fromprofile = false}) async {
    _load = true;
    if (!fromprofile) {
      notifyListeners();
    }
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");
    _userId = localstorage.getInt('id')!;

    try {
      final response =
          await dio.Dio().get("${Links.getuserproperties}/$_userId",
              options: dio.Options(headers: {
                "Authorization": "Bearer $token",
              }));
      if (response.data['status']) {
        _properties =
            List.from(response.data['data'][0]['biens']).reversed.toList();
        _error = "";
      } else {
        _error = response.data['mge'];
      }
      _load = false;
      notifyListeners();
    } on dio.DioException catch (e) {
      _error = checkiferror(e);
      _load = false;
      notifyListeners();
    }
  }

  Future<void> loaditem() async {
    await init(update: true);
    _load = true;
    notifyListeners();

    try {
      final localstorage = await SharedPreferences.getInstance();
      final token = localstorage.getString("token").toString();
      final response = await dio.Dio().get("${Links.getproperty}/$_id}",
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));
      // print(response.data);
      if (response.data['status']) {
        _error = "";
        final item = response.data['data'];

        // print(item);

        _id = item['id'];

        _nameController.text = item['name'].toString();
        _addressController.text = item['adress'].toString();
        _gpsController.text = item['localisation_gps'].toString();
        _descriptionController.text = item['description'].toString();
        _costController.text = item['cost'].toString();
        _lotController.text =
            item['lot'] != 'null' ? item['lot'].toString() : "";
        _ilotController.text =
            item['ilot'] != 'null' ? item['ilot'].toString() : "";
        _areaController.text =
            item['area'] != 'null' ? item['area'].toString() : "";
        _cautionController.text =
            item['caution'] != null ? item['caution'].toString() : "";
        _limitpersodayController.text = item['limit_perso_day'] != null
            ? item['limit_perso_day'].toString()
            : "";
        _roomController.text =
            item['room'] != 'null' ? item['room'].toString() : "";
        _personmaxiController.text =
            item['person_maxi'] != null ? item['person_maxi'].toString() : "";

        _id = item['id'];
        _userId = item['user_id'];
        _images = [];
        _available = item['status'] == "Disponible";
        _published = item['status'] != "Indisponible";
        _documents = item['document'] ?? "";

        for (var i = 0; i < _categories.length; i++) {
          if (_categories[i]['id'] == item['category']['id']) {
            _categories[i] = item['category'];
            _selectedcategory = _categories[i];
          }
        }
        for (var i = 0; i < _cities.length; i++) {
          if (_cities[i]['id'] == item['municipality']['city']['id']) {
            _cities[i] = item['municipality']['city'];
            _selectedcity = _cities[i];
            _municipalities = _selectedcity['municipalities'];
            _selectedmunicipality = item['municipality_id'];
          }
        }
        _selectedtype = item['type'];
        _comodites = [];
        for (var element in item['comodites'] ?? []) {
          _comodites.add({
            'comodity_id': element['id'],
            'label': element['label'],
            'number': element['pivot']['number']
          });
        }
        _selectedloctype = item['type_id'];

        for (var image in item['photos']) {
          _images.add(image);
        }
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

  Future<void> search({bool fromprofile = false}) async {
    _load = true;
    if (!fromprofile) {
      notifyListeners();
    }
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");
    _userId = localstorage.getInt('id')!;
    _properties = [];
    try {
      final response = await dio.Dio().post(Links.search,
          data: {'user_id': _userId},
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));
      if (response.data['status']) {
        _properties = List.from(response.data['data']).reversed.toList();
        // print(_properties[0]);
      } else {
        _error = response.data['mge'];
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
