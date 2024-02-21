import 'dart:async';

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaiementCompleteScreen extends StatefulWidget {
  PaiementCompleteScreen({super.key, this.times = 0, this.isNew = true});
  int times;
  bool isNew;

  @override
  State<PaiementCompleteScreen> createState() => _PaiementCompleteScreenState();
}

class _PaiementCompleteScreenState extends State<PaiementCompleteScreen> {
  //

  //

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final reservation = Provider.of<ReservationProvider>(context);
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gold,
          automaticallyImplyLeading: false,
          title: customText(
              text: widget.isNew
                  ? reservation.item['category']['label'] == "Résidence"
                      ? "Réservation effectuée"
                      : "Visite programmée"
                  : "Programmation confirmée",
              size: 16.0,
              color: Colors.white),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          // color: Colors.white,
          padding: const EdgeInsets.only(top: 5),
          child: Stack(children: [
            SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CORPS
                Container(
                    width: size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.03),
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        Container(
                          width: size.width * 0.4,
                          height: size.width * 0.4,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/gifs/completed.gif"),
                                  fit: BoxFit.cover)),
                          child: Image.asset("assets/images/dexter_white.png"),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Center(
                          child: Text(
                              widget.isNew
                                  ? reservation.item['category']['label'] ==
                                          "Résidence"
                                      ? "La réservation a été effectuée avec succès. Un mail contenant votre code d'ouverture vous a été envoyé."
                                      : "La visite a été programmée avec succès. Un mail contenant les informations de la visite a a été envoyé."
                                  : "Votre programmation est maintenant confirmée. Les détails vous ont été envoyés par email.",
                              textAlign: TextAlign.center,
                              style: textFont(size: 15.0)),
                        ),
                        SizedBox(height: size.height * 0.01),
                        customButton(
                            context: context,
                            color: Colors.blue[700],
                            child: customText(
                                text: "Ok", color: Colors.white, size: 18.0),
                            width: size.width * 0.5,
                            ontap: () {
                              for (var i = 0; i < widget.times; i++) {
                                Navigator.pop(context);
                              }
                              Timer(const Duration(seconds: 2), () {
                                reservation.reset();
                              });
                            }),
                      ],
                    ))
              ],
            )),
            // ETAPE SUIVANTE
          ]),
        ),
      ),
    );
  }
}
