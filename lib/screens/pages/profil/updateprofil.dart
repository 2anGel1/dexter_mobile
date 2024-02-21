// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UpdateProfilScreen extends StatefulWidget {
  const UpdateProfilScreen({super.key});

  @override
  State<UpdateProfilScreen> createState() => _UpdateProfilScreenState();
}

class _UpdateProfilScreenState extends State<UpdateProfilScreen> {
  //
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _identity = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfim = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FilePickerResult? _pickedfile;
  final String _filePath = "";
  bool _hide1 = true;
  bool _hide2 = true;
  //
  init() async {
    _surname.text = context.read<AuthProvider>().lastName;
    _name.text = context.read<AuthProvider>().firstName;
    _phone.text = context.read<AuthProvider>().phone;
    _email.text = context.read<AuthProvider>().email;
  }

  //
  @override
  void initState() {
    super.initState();
    init();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthProvider>(context);

    //
    // NAME FIELD
    final nameField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          controller: _name,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            prefixIcon: Icon(
              Icons.abc_sharp,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // SURNAME FIELD
    final surnameField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          controller: _surname,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Prénoms",
            prefixIcon: Icon(
              Icons.abc_sharp,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // PHONE FIELD
    final phoneField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          controller: _phone,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            } else if (value.length < 10) {
              return "Le numéro doit contenir au moins 10 chiffres";
            }
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Numéro de téléphone",
            prefixIcon: Icon(
              CupertinoIcons.phone,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // EMAIL FIELD
    final emailField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          controller: _email,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          enabled: false,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Email",
            prefixIcon: Icon(
              CupertinoIcons.mail,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // PASSWORD FIELD
    final passwordField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          controller: _password,
          obscureText: _hide1,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
                borderRadius: BorderRadius.zero),
            hintText: "Ancien mot de passe",
            prefixIcon: const Icon(
              Icons.password,
              size: 20,
              color: Colors.grey,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _hide1 = !_hide1;
                });
              },
              child: Icon(
                _hide1 ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                size: 20,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // PASSWORD CONFIRM FIELD
    final passwordconfirmField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          controller: _passwordConfim,
          obscureText: _hide2,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            } else if (value.length < 5) {
              return "Le mot de passe doit contenir au moins 5 caractères";
            }
            return null;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
                borderRadius: BorderRadius.zero),
            hintText: "Nouveau mot de passe",
            prefixIcon: const Icon(
              Icons.password,
              size: 20,
              color: Colors.grey,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _hide2 = !_hide2;
                });
              },
              child: Icon(
                _hide2 ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                size: 20,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
// FILE FIELD
    final filepickField = SizedBox(
        height: 50,
        width: size.width * 0.6,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          enabled: false,
          controller: _identity,
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Pièce d'iendentité",
            prefixIcon: _identity.text == ''
                ? const Icon(
                    Icons.file_open_outlined,
                    size: 22,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.check_circle_outline,
                    size: 25,
                    color: Colors.green[700],
                  ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    //
    return SizedBox(
      height: size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              FontAwesomeIcons.xmark,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Container(
              margin: const EdgeInsets.only(bottom: 0),
              height: 35,
              width: 35,
              child: Image.asset('assets/images/dexter_logo.png',
                  fit: BoxFit.cover)),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Container(
            width: size.width,
            height: size.height,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                              text: "Modifier vos informations",
                              size: 20.0,
                              weight: FontWeight.w600),
                          const SizedBox(
                            height: 15,
                          ),
                          nameField,
                          const SizedBox(
                            height: 15,
                          ),
                          surnameField,
                          const SizedBox(
                            height: 15,
                          ),
                          emailField,
                          const SizedBox(
                            height: 15,
                          ),
                          phoneField,
                          const SizedBox(
                            height: 15,
                          ),
                          auth.isprop
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // FIELD
                                        filepickField,
                                        // BUTTON
                                        customButton(
                                            context: context,
                                            width: size.width * 0.3,
                                            ontap: () {
                                              if (_identity.text != '') {
                                                setState(() {
                                                  _identity.clear();
                                                  _pickedfile = null;
                                                });
                                              } else {
                                                pickFile();
                                              }
                                            },
                                            color: Colors.blue[700],
                                            child: const Icon(
                                              CupertinoIcons.download_circle,
                                              size: 30,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : Container(),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          !auth.isowner
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        auth.setisprop();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            auth.isprop
                                                ? Icons.check_box_outlined
                                                : Icons.check_box_outline_blank,
                                            color: auth.isprop
                                                ? mainBlue
                                                : Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          customText(
                                              text:
                                                  "Je veux mettre mes biens sur Dexter",
                                              size: 12.0)
                                        ],
                                      ),
                                    ),
                                    customText(
                                        text:
                                            "Cocher si vous voulez avoir le statut de Propriétaire. Ce statut vous donne la possiblité de mettre en ligne vos biens",
                                        size: 11.0,
                                        color: Colors.black54),
                                    const SizedBox(height: 15),
                                  ],
                                )
                              : Container(),
                          customButton(
                              context: context,
                              width: size.width,
                              height: 60.0,
                              color: mainBlue,
                              ontap: () async {
                                if (!auth.isprop) {
                                  await auth.updateuser({
                                    'firstname': _name.text,
                                    'lastname': _surname.text,
                                    'phone': _phone.text,
                                    'cni': _pickedfile
                                  });
                                  if (auth.error.isEmpty) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: customText(
                                          text: "Informations misent à jour",
                                          size: 13.0,
                                          color: Colors.white),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      closeIconColor: Colors.white,
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: customText(
                                          text: auth.error,
                                          size: 13.0,
                                          color: Colors.white),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      showCloseIcon: true,
                                      closeIconColor: Colors.white,
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                } else {
                                  if (_pickedfile == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: customText(
                                          text:
                                              "Veuillez associer votre carte d'identiter pour continuer",
                                          size: 13.0,
                                          color: Colors.white),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      showCloseIcon: true,
                                      closeIconColor: Colors.white,
                                      backgroundColor: Colors.black,
                                    ));
                                  } else {
                                    await auth.updateuser({
                                      'firstname': _name.text,
                                      'lastname': _surname.text,
                                      'email': _email.text,
                                      'phone': _phone.text,
                                      'cni': _pickedfile
                                    });
                                    if (auth.error.isEmpty) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: customText(
                                            text: "Informations mis à jour",
                                            size: 13.0,
                                            color: Colors.white),
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        closeIconColor: Colors.white,
                                        backgroundColor: Colors.green,
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: customText(
                                            text: auth.error,
                                            size: 13.0,
                                            color: Colors.white),
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        showCloseIcon: true,
                                        closeIconColor: Colors.white,
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText(
                                      text: "Appliquer les modifications",
                                      color: Colors.white,
                                      weight: FontWeight.bold,
                                      size: 17.0),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  auth.load
                                      ? const SpinKitChasingDots(
                                          size: 20, color: Colors.white)
                                      : const Icon(
                                          Icons.send_and_archive_rounded,
                                          color: Colors.white,
                                        )
                                ],
                              )),
                          // customText(text: auth.cni)
                          const Divider(),
                          const SizedBox(
                            height: 45,
                          ),
                          customText(
                              text: "Modifier votre mot de passe",
                              size: 20.0,
                              weight: FontWeight.w600),
                          const SizedBox(
                            height: 15,
                          ),
                          passwordField,
                          const SizedBox(
                            height: 15,
                          ),
                          passwordconfirmField,
                          const SizedBox(
                            height: 10,
                          ),
                          customButton(
                              context: context,
                              width: size.width,
                              height: 60.0,
                              color: mainBlue,
                              ontap: () async {
                                await auth.updateuserpassword({
                                  'email': _name.text,
                                  'oldPassword': _password.text,
                                  'password': _passwordConfim.text,
                                });
                                if (auth.error.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: customText(
                                        text: "Mot de passe mis à jour",
                                        size: 13.0,
                                        color: Colors.white),
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    closeIconColor: Colors.white,
                                    backgroundColor: Colors.green,
                                  ));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: customText(
                                        text: auth.error,
                                        size: 13.0,
                                        color: Colors.white),
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    showCloseIcon: true,
                                    closeIconColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText(
                                      text: "Modifier",
                                      color: Colors.white,
                                      weight: FontWeight.bold,
                                      size: 17.0),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  auth.loadpass
                                      ? const SpinKitChasingDots(
                                          size: 20, color: Colors.white)
                                      : const Icon(
                                          Icons.send_and_archive_rounded,
                                          color: Colors.white,
                                        )
                                ],
                              )),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedfile = result;
        _identity.text = result.files.single.name;
      });
    }
  }
}
