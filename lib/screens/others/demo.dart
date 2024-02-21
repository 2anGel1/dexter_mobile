import 'dart:convert';

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/screens/pages/visitesteps/paiementvisite.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  //
  final XFile _file = XFile("no path");
  //
  @override
  //
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    //
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customButton(
                context: context,
                width: size.width * 0.7,
                ontap: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: false,
                      barrierColor: Colors.black.withOpacity(0),
                      builder: (context) {
                        return const PaiementVisiteStepScreen();
                      });
                },
                color: Colors.blue[700],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(text: "Boutton", color: Colors.white),
                    const SizedBox(width: 15.0),
                    const Icon(
                      Icons.send_and_archive,
                      size: 20,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void sendFilesToAPI1() async {
    List<MultipartFile> files = [
      MultipartFile.fromFileSync(_file.path, filename: _file.name),
    ];
    final dio = Dio();
    const url =
        'http://192.168.1.9:8000/api/testingphoto'; // Replace with your actual API endpoint URL

    FormData formData = FormData.fromMap({
      'name': 'Assamoi',
      'files': [
        for (var file in files) MapEntry('files[]', file),
      ],
    });

    try {
      Response response = await dio.post(url, data: formData);
      // print(response.data); 
    } on DioException catch (e) {
      debugPrint('Error: ${e.response!.data}');
    }
  }

  void sendFilesToAPI2() async {
    final localstorage = await SharedPreferences.getInstance();
    final token = localstorage.getString("token");
    List<int> fileBytes = await _file.readAsBytes();
    String base64File = base64Encode(fileBytes);
    List<Map<String, dynamic>> files = [
      {
        'filename': _file.name.substring(13, _file.name.length),
        'data': base64File
      }
    ];
    final dio = Dio();
    const url =
        'http://192.168.1.8:8000/api/photos'; // Replace with your actual API endpoint URL

    try {
      Response response = await dio.post(url,
          data: FormData.fromMap(
              {'propriety_id': 3, 'image': files, 'meilleur': true}),
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }));
      // print(response.data);
    } on DioException catch (e) {
      debugPrint('Error: ${e.response!.data}');
    }
  }
}
