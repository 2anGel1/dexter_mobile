import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/screens/pages/reservationsteps/paiementreservationstep.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationStepTwoScreen extends StatefulWidget {
  const ReservationStepTwoScreen({super.key});

  @override
  State<ReservationStepTwoScreen> createState() =>
      _ReservationStepTwoScreenState();
}

class _ReservationStepTwoScreenState extends State<ReservationStepTwoScreen> {
  //
  var dropdownValue;
  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final reservation = Provider.of<ReservationProvider>(context);
    final detail = Provider.of<ReservDetailProvider>(context);
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gold,
          centerTitle: false,
          title: customText(
              text: "Réservation: étape 2", size: 16.0, color: Colors.white),
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
              onTap: () {
                if (reservation.nbPerson >= 1) {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: false,
                      barrierColor: Colors.black.withOpacity(0),
                      builder: (context) {
                        return PaiementReservationStepScreen();
                      });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: customText(
                        text:
                            "Choisissez un nombre de personne pour continuer..",
                        size: 13.0,
                        color: Colors.white),
                    duration: const Duration(milliseconds: 3000),
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                    backgroundColor: Colors.black,
                  ));
                }
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: customText(
                    text: "Suivant",
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
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: "Nombre de personne",
                        size: 16.0,
                        weight: FontWeight.w700,
                      ),
                      customText(
                        text:
                            "Choisissez le nombre de personne qui seront présentes dans la résidence",
                        size: 14.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // DROPDOWN BUTTON
                Container(
                  width: size.width,
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
                  margin: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.7, color: Colors.grey[400]!)),
                  child: Center(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: customText(text: "Nombre de personne"),
                      value: dropdownValue,
                      items: detail.persons
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: customText(
                              text: value == '1'
                                  ? '$value personne'
                                  : '$value personnes'),
                        );
                      }).toList(),
                      // Step 5.
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          reservation.updateNbPerson((int.parse(newValue)));
                        });
                      },
                    ),
                  ),
                ),
              ],
            )),
            // ETAPE SUIVANTE
          ]),
        ),
      ),
    );
  }
}


  // DROPDOWN BUTTON
                  // Container(
                  //   width: size.width,
                  //   height: 55,
                  //   padding: const EdgeInsets.all(15),
                  //   decoration: BoxDecoration(
                  //       border:
                  //           Border.all(width: 0.7, color: Colors.grey[400]!)),
                  //   child: Center(
                  //     child: DropdownButton<String>(
                  //       isExpanded: true,
                  //       underline: const SizedBox(),
                  //       hint: customText(text: "Nombre de personne"),
                  //       value: dropdownValue,
                  //       items: <String>['1', '2', '3', '4', '5', '6']
                  //           .map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: customText(
                  //               text: value == '1'
                  //                   ? '$value personne'
                  //                   : '$value personnes'),
                  //         );
                  //       }).toList(),
                  //       // Step 5.
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           dropdownValue = newValue!;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  