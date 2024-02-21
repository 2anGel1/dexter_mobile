// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //
  final _email = TextEditingController();
  //

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthProvider>(context);
    final reservation = Provider.of<ReservationProvider>(context);
    //
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Scaffold(
        body: Container(
            height: size.height,
            width: size.width,
            // color: Colors.white,
            padding: const EdgeInsets.only(top: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  verticalspace(size.height * 0.05),
                  SizedBox(
                    width: size.width,
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(FontAwesomeIcons.xmark),
                        ),
                      )
                    ]),
                  ),
                  //
                  verticalspace(size.height * 0.05),
                  customText(
                      text: "Vous avez oublié votre mot de passe ?",
                      size: 18.0,
                      weight: FontWeight.bold,
                      center: true),
                  //
                  verticalspace(size.height * 0.01),
                  customText(
                      text:
                          "Pas de panique ! Entrez votre addresse email pour le réinitialiser.",
                      center: true,
                      size: 13.0),
                  //
                  verticalspace(size.height * 0.05),
                  Container(
                      height: 60,
                      width: size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: _email,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Entrez une adresse email";
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
                              borderSide:
                                  BorderSide(width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.zero),
                        ),
                      )),
                  //
                  verticalspace(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: customButton(
                        context: context,
                        ontap: () async {
                          await auth.resertpassword(_email.text);
                          if (auth.error == "") {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: customText(
                                  text:
                                      "Email de réinitialisation envoyé avec succès.",
                                  size: 13.0,
                                  color: Colors.white),
                              duration: const Duration(milliseconds: 2500),
                              backgroundColor: Colors.black,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: customText(
                                  text: auth.error,
                                  size: 13.0,
                                  color: Colors.white),
                              duration: const Duration(milliseconds: 1500),
                              backgroundColor: Colors.black,
                            ));
                          }
                        },
                        color: mainBlue,
                        child: auth.loadpassreset
                            ? const SpinKitCircle(
                                size: 20,
                                color: Colors.white,
                              )
                            : Text(
                                "Valider",
                                style: textFont(
                                    size: 18.0,
                                    color: Colors.white,
                                    weight: FontWeight.normal),
                              )),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
