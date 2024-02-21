// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/screens/pages/reservationsteps/resumereservation.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaiementReservationStepScreen extends StatefulWidget {
  PaiementReservationStepScreen({super.key, this.isNew = true});
  bool isNew;

  @override
  State<PaiementReservationStepScreen> createState() =>
      _PaiementReservationStepScreenState();
}

class _PaiementReservationStepScreenState
    extends State<PaiementReservationStepScreen> {
  //
  final List<TextEditingController> _ncontrollers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  final List<TextEditingController> _dcontrollers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  final List<FocusNode> _nnodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  final List<FocusNode> _dnodes = [FocusNode(), FocusNode(), FocusNode()];
  //
  bool checknumbercardfill() {
    for (var cont in _ncontrollers) {
      if (cont.text.length < 4) {
        return false;
      }
    }
    if (_dcontrollers[0].text.length < 2) {
      return false;
    }
    if (_dcontrollers[1].text.length < 4) {
      return false;
    }
    if (_dcontrollers.last.text.length < 3) {
      return false;
    }
    return true;
  }

  //
  @override
  void dispose() {
    for (var node in _nnodes) {
      node.dispose();
    }
    for (var node in _dnodes) {
      node.dispose();
    }
    for (var contr in _ncontrollers) {
      contr.dispose();
    }
    for (var contr in _dcontrollers) {
      contr.dispose();
    }
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final reservation = Provider.of<ReservationProvider>(context);
    reservation.updateReservationCost();
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gold,
          centerTitle: false,
          title: customText(
              text: "Réservation: étape 3", size: 16.0, color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
          ),
          actions: [
            InkWell(
              onTap: reservation.loading
                  ? null
                  : () async {
                      if (reservation.payment != 0) {
                        showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            enableDrag: false,
                            barrierColor: Colors.black.withOpacity(0),
                            builder: (context) {
                              return const ResumeReservationStepScreen();
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: customText(
                              text:
                                  "Sélectionnez un mode de paiement pour continuer..",
                              size: 13.0,
                              color: Colors.white),
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor: Colors.black,
                        ));
                      }
                    },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: customText(
                    text: "Finaliser",
                    color: Colors.white,
                    weight: FontWeight.w500),
              )),
            )
          ],
        ),
        body: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.only(top: 5),
          child: Stack(children: [
            SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ENTÊTE
                Container(
                  width: size.width,
                  margin: const EdgeInsets.only(top: 15.0),
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: "Paiement de la réservation",
                        size: 16.0,
                        weight: FontWeight.w700,
                      ),
                      customText(
                        text:
                            "Choisissez le moyen de paiement qui vous convient",
                        size: 14.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                // CORPS
                Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PRIX
                      RichText(
                          text: TextSpan(style: textFont(), children: [
                        const TextSpan(text: "Prix/jour: "),
                        TextSpan(
                            text: cfaformat.format(reservation.item['cost']),
                            style: textFont(
                                size: 16.0,
                                weight: FontWeight.w600,
                                color: Colors.grey[800]))
                      ])),
                      SizedBox(height: size.height * 0.006),
                      Container(
                          width: size.width,
                          height: size.height * 0.07,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.01),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.4, color: Colors.blue[900]!)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                  text: "Total (${reservation.nbDays} jrs)",
                                  color: Colors.blue[900]),
                              customText(
                                  text: cfaformat.format(reservation.cost),
                                  size: 20.0,
                                  weight: FontWeight.w600,
                                  color: Colors.blue[900])
                            ],
                          )),
                      // MOYEN DE PAIEMENT
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        height: 70,
                        width: size.width,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: reservation.moyensdepaiement.map((moyen) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      reservation.updatePaymment(moyen.id);
                                    },
                                    child: Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(moyen.image),
                                            fit: BoxFit.cover),
                                      ),
                                      child: reservation.payment != moyen.id
                                          ? Container()
                                          : Container(
                                              width: 70,
                                              height: 70,
                                              color: const Color.fromARGB(
                                                  133, 38, 37, 37),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 45,
                                                ),
                                              )),
                                    ),
                                  ),
                                  SizedBox(width: size.height * 0.02),
                                ],
                              );
                            }).toList()),
                      ),

                      verticalspace(20),
                      //
                    ],
                  ),
                )
              ],
            )),
            // ETAPE SUIVANTE
          ]),
        ),
      ),
    );
  }
}
