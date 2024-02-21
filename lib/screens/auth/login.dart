// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/routes/routemanager.dart';
import 'package:dexter_mobile/screens/auth/forgotpass.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthProvider>(context);

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
          obscureText: _hide,
          textInputAction: TextInputAction.done,
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
            hintText: "Mot de passe",
            prefixIcon: const Icon(
              Icons.password,
              size: 20,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _hide = !_hide;
                });
              },
              child: Icon(
                _hide ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                size: 20,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));

    // RETURN
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP IMAGE
                Card(
                  margin: const EdgeInsets.all(0),
                  elevation: 5,
                  child: SizedBox(
                      height: size.height * 0.3,
                      width: size.width,
                      child: Image.asset(
                        'assets/images/logintop.jpeg',
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
                        // BIENVENUE...
                        RichText(
                            text: TextSpan(
                                style: textFont(size: 13.5),
                                children: const [
                              TextSpan(
                                  text: "Bienvenue sur ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                  text: "DEXTER\n",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: gold)),
                              TextSpan(
                                  text:
                                      "Vous cherchez un appartement, une maison, un terrain ou même une residence à louer, vous êtes au bon endroit. Connectez vous dès maintenant !")
                            ])),
                        // SOME SPACE
                        const SizedBox(height: 20),
                        // LOGIN FORM
                        Form(
                            key: _formKey,
                            child: Column(
                              // FILEDS
                              children: [
                                emailField,
                                const SizedBox(
                                  height: 10,
                                ),
                                passwordField
                              ],
                            )),
                        // SOME SPACE
                        const SizedBox(
                          height: 10,
                        ),
                        // CONNEXION BUTTON
                        customButton(
                            context: context,
                            ontap: () async {
                              if (_formKey.currentState!.validate()) {
                                await auth.login({
                                  'email': _email.text,
                                  'password': _password.text
                                });
                                if (auth.error.isEmpty) {
                                  Navigator.pushReplacementNamed(
                                      context, RouteManager.root);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: customText(
                                        text: auth.error,
                                        size: 13.0,
                                        color: Colors.white),
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    backgroundColor: Colors.black,
                                  ));
                                }
                              } else {
                                //
                              }
                            },
                            color: gold,
                            child: auth.load
                                ? const SpinKitCircle(
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Continuer",
                                    style: textFont(
                                        size: 18.0,
                                        color: Colors.white,
                                        weight: FontWeight.normal),
                                  )),
                        // SOME SPACE
                        const SizedBox(height: 10),
                        // NO ACCOUNT YET
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Vous n'avez pas de compte ? ",
                              style: textFont(size: 13.5),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteManager.signup);
                              },
                              child: Text("Inscrivez vous ici",
                                  style: textFont(
                                      size: 13.5,
                                      color: Colors.blue[700],
                                      weight: FontWeight.bold)),
                            )
                          ],
                        ),
                        // FORGOT PASSWORD
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                barrierColor: Colors.black.withOpacity(0),
                                builder: (context) {
                                  return const ForgotPasswordScreen();
                                });
                          },
                          child: Text("J'ai oublié mon mot de passe",
                              style: textFont(
                                  size: 13.5, color: Colors.blue[700])),
                        ),
                        // SOME SPACE
                        SizedBox(height: size.height * 0.07),
                        // GO TO HOME PAGE
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RouteManager.root);
                            },
                            child: Text("Aller à la page d'accueil >",
                                textAlign: TextAlign.end,
                                style: textFont(
                                    size: 15.0,
                                    color: Colors.grey[800],
                                    weight: FontWeight.w500)),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
