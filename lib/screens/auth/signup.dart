// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/routes/routemanager.dart';
import 'package:dexter_mobile/screens/pages/policy.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _identity = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfim = TextEditingController();
  FilePickerResult? _pickedfile;
  bool _hide1 = true;
  bool _hide2 = true;

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
            hintText: "Nom",
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
          textInputAction: TextInputAction.next,
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
            } else if (value.length < 5) {
              return "Le mot de passe doit contenir au moins 5 caractères";
            }
            return null;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
                borderRadius: BorderRadius.zero),
            hintText: "Mot de passe",
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
            } else if (value != _password.text) {
              return "Ne correspond pas !";
            }
            return null;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
                borderRadius: BorderRadius.zero),
            hintText: "Confirmation du mot de passe",
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
          controller: _identity,
          // enabled: false,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          enabled: false,
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
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // TOP IMAGE
              Card(
                margin: const EdgeInsets.all(0),
                elevation: 5,
                child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width,
                    child: Image.asset(
                      'assets/images/signuptop.jpeg',
                      fit: BoxFit.cover,
                    )),
              ),
              // SOME SPACE
              const SizedBox(
                height: 10,
              ),
              // REST OF SCREEN
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // INSCRIVEZ VOUS..
                    RichText(
                        text: TextSpan(
                            style: textFont(size: 13.5),
                            children: const [
                          TextSpan(
                              text: "Rejoingnez ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text: "Nous\n",
                              style: TextStyle(
                                color: gold,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text:
                                  "Pour vous donner une experience unique et vous faire decouvrir du contenu à votre goût, faites vous connaître en vous inscrivant !"),
                        ])),
                    // SOME SPACE
                    const SizedBox(height: 20),
                    // SIGNUP FORM
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                                text: "Mes informations",
                                color: Colors.grey[800],
                                weight: FontWeight.w500),
                            const SizedBox(height: 10),
                            nameField,
                            const SizedBox(height: 10),
                            surnameField,
                            const SizedBox(height: 10),
                            phoneField,
                            const SizedBox(height: 10),
                            const SizedBox(height: 30),
                            Text(
                              "Mes accès",
                              style: textFont(
                                  color: Colors.grey[800],
                                  weight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            emailField,
                            const SizedBox(height: 10),
                            passwordField,
                            const SizedBox(height: 10),
                            passwordconfirmField,
                            auth.isprop
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30),
                                      Text(
                                        "Mon identité",
                                        style: textFont(
                                            color: Colors.grey[800],
                                            weight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 10),
                                      //  FILE PICKING
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
                                                  pickImage();
                                                }
                                              },
                                              color: Colors.blue[700],
                                              child: const Icon(
                                                CupertinoIcons.download_circle,
                                                size: 30,
                                              )),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(height: 20),
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
                                    color:
                                        auth.isprop ? mainBlue : Colors.black,
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
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                auth.updatepolicy();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    auth.policy
                                        ? Icons.check_box_outlined
                                        : Icons.check_box_outline_blank,
                                    color:
                                        auth.policy ? mainBlue : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: customText(
                                        text:
                                            "J'ai lu et j'accepte les conditions et politiques de Dexter",
                                        size: 12.0),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      // <-- SEE HERE
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0),
                                      ),
                                    ),
                                    builder: (context) {
                                      return const PolicyWidget();
                                    });
                              },
                              child: customText(
                                  text: "Conditions et politiques de Dexter",
                                  size: 11.0,
                                  color: mainBlue),
                            ),
                          ],
                        )),
                    // SOME SPACE
                    const SizedBox(height: 20),
                    // SIGN UP BUTTON
                    customButton(
                        context: context,
                        ontap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (auth.policy) {
                              await auth.signup({
                                "lastname": _surname.text,
                                "firstname": _name.text,
                                "email": _email.text,
                                "password": _password.text,
                                "phone": _phone.text,
                                "roles": auth.myroles,
                                "cni": _pickedfile
                              });
                              if (auth.error.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: customText(
                                      text: auth.error,
                                      size: 13.0,
                                      color: Colors.white),
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            "Votre compte a été créé avec succès !"),
                                        content: customText(
                                            text:
                                                "Vous pouvez maintenant accéder à votre espace. Bienvenue sur Dexter !"),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text("Ok"),
                                            onPressed: () async {
                                              Navigator.pushReplacementNamed(
                                                  context, RouteManager.login);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: customText(
                                    text:
                                        "Vous n'avez pas accepté les conditions et politiques de Dexter !",
                                    size: 13.0,
                                    color: Colors.white),
                                duration: const Duration(milliseconds: 2000),
                                backgroundColor: Colors.black,
                              ));
                            }
                          }
                        },
                        color: gold,
                        child: auth.load == true
                            ? const SpinKitCircle(size: 20, color: Colors.white)
                            : Text(
                                "Continuer",
                                style: textFont(
                                    size: 18.0,
                                    color: Colors.white,
                                    weight: FontWeight.normal),
                              )),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedfile = result;
        _identity.text = result.files.single.name;
      });
    }
  }
}
