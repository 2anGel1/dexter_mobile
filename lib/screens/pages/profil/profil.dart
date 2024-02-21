// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/constants/data.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/routes/routemanager.dart';
import 'package:dexter_mobile/screens/pages/programations/programmations.dart';
import 'package:dexter_mobile/screens/pages/properties.dart';
import 'package:dexter_mobile/screens/pages/profil/updateprofil.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  //

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = getsize(context);
    final auth = Provider.of<AuthProvider>(context);
    final topFix = size.height * 0.2;
    // VIEWS
    // when connected
    connectedView() {
      return [
        Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage("assets/images/dexter_logo.png"),
                  fit: BoxFit.contain)),
        ),
        // INFO CARD
        Positioned(
          top: topFix - (topFix / 2.5),
          left: 20,
          right: 20,
          child: Consumer<AuthProvider>(
            builder: (context, value, child) {
              return Container(
                width: size.width * 0.95,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customText(
                      text: "${value.firstName} ${value.lastName}",
                      size: 20.0,
                      weight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    customText(text: value.email, size: 13.0),
                    customText(text: value.phone, size: 13.0),
                    const SizedBox(height: 8.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: value.roles
                            .map((role) => Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 25,
                                      color: mainBlue,
                                      child: Center(
                                          child: customText(
                                              text: role['label'] ?? 'NaN',
                                              size: 12.0,
                                              color: Colors.white)),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ))
                            .toList()),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          auth.active
                              ? Icons.check_circle
                              : FontAwesomeIcons.circleExclamation,
                          color:
                              auth.active ? Colors.green[800] : Colors.red[800],
                          size: 15,
                        ),
                        customText(
                          text: auth.active ? "Activé" : "En vérification",
                          size: 10.0,
                          color:
                              auth.active ? Colors.green[800] : Colors.red[800],
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ), // SOME SPACE
        SizedBox(
          height: size.height * 0.1,
        ),
        // ACTIONS
        Positioned(
          top: topFix + (topFix / 1.5),
          right: 7,
          left: 7,
          child: Container(
            width: size.width * 0.9,
            margin: EdgeInsets.only(top: size.height * 0.005),
            child: Column(
              children: [
                // ROW 1
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // MON ACTIVITÉ
                  customButtonRadius(
                      context: context,
                      width: size.width * 0.47,
                      height: size.width * 0.47,
                      color: Colors.grey[300],
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProgrammationsScreen()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customText(
                              text: "Mon activité",
                              size: 16.0,
                              weight: FontWeight.w500,
                              color: Colors.grey[800]),
                          Icon(
                            Icons.calendar_month,
                            color: Colors.grey[500],
                            size: 70,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: size.height * 0.01,
                  ),
                  // MON PROFIL
                  customButtonRadius(
                      context: context,
                      width: size.width * 0.47,
                      height: size.width * 0.47,
                      color: Colors.grey[300],
                      ontap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            shape: const RoundedRectangleBorder(
                              // <-- SEE HERE
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.0),
                              ),
                            ),
                            builder: (context) {
                              return const UpdateProfilScreen();
                            });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Mon profil",
                              textAlign: TextAlign.center,
                              style: textFont(
                                  size: 16.0,
                                  weight: FontWeight.w500,
                                  color: Colors.grey[800])),
                          Icon(
                            Icons.person,
                            color: Colors.grey[500],
                            size: 70,
                          ),
                        ],
                      )),
                ]),
                SizedBox(
                  height: size.height * 0.01,
                ),
                // ROW 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MES BIENS
                    customButtonRadius(
                        context: context,
                        width: size.width * 0.47,
                        height: size.width * 0.47,
                        color: Colors.grey[300],
                        ontap: () {
                          if (auth.isowner) {
                            if (auth.active) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PropertiesScreen()));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text("Compte désactivé !"),
                                      content: customText(
                                          text:
                                              "Votre compte est en cours de vérifiaction. Vous aurez accès à cette partie quand il sera activé."),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Compte Client !"),
                                    content: customText(
                                        text:
                                            "Vous avez un compte Client. Pour accéder à cette partie, vous devez avoir un compte Propriétaire."),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text("Ok"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText(
                                text: "Mes biens",
                                size: 16.0,
                                weight: FontWeight.w500,
                                color: Colors.grey[800]),
                            Icon(
                              Icons.home_work_outlined,
                              color: Colors.grey[500],
                              size: 70,
                            ),
                          ],
                        )),
                    SizedBox(
                      width: size.height * 0.01,
                    ),
                    // DECONNEXION
                    customButtonRadius(
                        context: context,
                        width: size.width * 0.47,
                        height: size.width * 0.47,
                        color: Colors.red[700],
                        ontap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text(
                                      "Voulez vous vraiement vous déconnecter ?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: const Text("Oui"),
                                      onPressed: () async {
                                        await auth.logout();
                                        if (auth.error.isEmpty) {
                                          Navigator.pushReplacementNamed(
                                              context, RouteManager.login);
                                        }
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("Non"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText(
                                text: "Déconnexion",
                                size: 16.0,
                                weight: FontWeight.w500,
                                color: Colors.white),
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 70,
                            ),
                          ],
                        ))
                  ],
                )
              ],
            ),
          ),
        )
      ];
    }

    // when not connected
    notconnectedView() {
      return [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customText(text: "Vous n'êtes pas connecté"),
              customButton(
                  context: context,
                  width: size.width * 0.8,
                  ontap: () {
                    Navigator.pushNamed(context, RouteManager.login);
                  },
                  color: mainBlue,
                  child: customText(text: "Se connecter", color: Colors.white))
            ],
          ),
        )
      ];
    }

    //
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children:
                    auth.connected ? connectedView() : notconnectedView());
          },
        ),
      ),
    );
  }
}
