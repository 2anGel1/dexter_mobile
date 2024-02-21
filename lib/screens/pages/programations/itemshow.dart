// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/programmationprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/screens/pages/programations/calendarcancel.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  ItemDetail({super.key, this.owner = false});
  bool owner;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final program = Provider.of<ReservationProvider>(context);
    final programmation = Provider.of<ProgrammationProvider>(context);
    bool isResidence = program.item['category_id'] == 1;
    final mindate = isResidence
        ? DateTime.parse(
            program.period['date_start'].toString().substring(0, 10))
        : DateTime.parse(program.date.toString().substring(0, 10));
    final cancelled = !program.paynow || programmation.status == "cancelled";
    final comp = isResidence ? -2880 : 0;
    print(programmation.status);
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: gold,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: customText(
                text: program.item['name'] ?? '',
                size: 16.0,
                color: Colors.white),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                program.reset();
              },
              child: const Icon(
                Icons.cancel_rounded,
                size: 20,
              ),
            ),
            actions: [
              widget.owner
                  ? Container()
                  : DateTime.now().difference(mindate).inMinutes > comp
                      ? Container()
                      : cancelled
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: customText(
                                            size: 16.0,
                                            weight: FontWeight.bold,
                                            text: isResidence
                                                ? "Voulez-vous vraiement annuler la réservation ?"
                                                : "Voulez-vous vraiement annuler la visite ?"),
                                        content: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                customText(
                                                    size: 12.0,
                                                    color: Colors.red,
                                                    text: isResidence
                                                        ? "NB: Cette action n'est suivie d'aucun rembourssement. Voulez-vous choisir une période alternative pour votre séjour ?"
                                                        : "NB: Cette action n'est suivie d'aucun rembourssement"),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ]),
                                        ),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text("Oui"),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              isResidence
                                                  ? await showModalBottomSheet(
                                                      context: context,
                                                      isDismissible: false,
                                                      enableDrag: false,
                                                      barrierColor: Colors.black
                                                          .withOpacity(0),
                                                      builder: (context) {
                                                        return const CalendarCancel();
                                                      })
                                                  : await programmation
                                                      .cancelvisite();

                                              if (programmation.startcancel) {
                                                await programmation
                                                    .cancelreservation(
                                                        pp: true);
                                              }

                                              if (programmation.error.isEmpty) {
                                                programmation.loaddata();
                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(SnackBar(
                                                //   content: customText(
                                                //       text:
                                                //           "Votre programmation a bel et bien été reportée à une date ultérieur",
                                                //       size: 13.0,
                                                //       color: Colors.white),
                                                //   showCloseIcon: false,
                                                //   duration: const Duration(
                                                //       milliseconds: 2500),
                                                //   backgroundColor: Colors.green,
                                                // ));
                                                // Navigator.of(context).pop();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: customText(
                                                      text: programmation.error,
                                                      size: 13.0,
                                                      color: Colors.white),
                                                  showCloseIcon: true,
                                                  closeIconColor: Colors.white,
                                                  duration: const Duration(
                                                      milliseconds: 2500),
                                                  backgroundColor: Colors.black,
                                                ));
                                              }
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text("Non"),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              isResidence
                                                  ? await programmation
                                                      .cancelreservation()
                                                  : debugPrint("--");
                                            },
                                          ),
                                          isResidence
                                              ? CupertinoDialogAction(
                                                  child: const Text(
                                                      "Ne pas annuler"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              : const SizedBox(),
                                        ],
                                      );
                                    });
                              },
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: programmation.cancel
                                    ? SpinKitCircle(
                                        size: 20,
                                        color: Colors.red[800],
                                      )
                                    : customText(
                                        text: "Annuler",
                                        color: Colors.red[800],
                                        size: 14,
                                        weight: FontWeight.w600),
                              )),
                            )
            ],
          ),
          body: Container(
            height: size.height,
            width: size.width,
            margin: const EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.only(
                left: size.height * 0.02, top: size.height * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // PERIODE
                  SizedBox(
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: isResidence
                              ? "Période de réservation"
                              : "Date de la visite",
                          size: 16.0,
                          weight: FontWeight.w700,
                        ),
                        isResidence == false
                            ? customText(
                                text: DateFormat("EEEE dd MMMM yyyy", 'fr_FR')
                                    .format(DateTime.parse(program.date)))
                            : RichText(
                                text: TextSpan(
                                    style: textFont(size: 16.0),
                                    children: [
                                    const TextSpan(
                                      text: "Du ",
                                    ),
                                    TextSpan(
                                        text: DateFormat("dd MMMM", 'fr_FR')
                                            .format(DateTime.parse(
                                                program.period['date_start'])),
                                        style: textFont(
                                            size: 17.0,
                                            weight: FontWeight.w500)),
                                    const TextSpan(text: " au "),
                                    TextSpan(
                                        text: DateFormat("dd MMMM", 'fr_FR')
                                            .format(DateTime.parse(
                                                program.period['date_end'])),
                                        style: textFont(
                                            size: 17.0,
                                            weight: FontWeight.w500)),
                                    TextSpan(
                                      text: " (${program.nbDays} jrs) ",
                                    ),
                                  ]))
                      ],
                    ),
                  ),
                  isResidence
                      ? const Divider(
                          thickness: 1,
                        )
                      : Container(),
                  // NOMBRE DE PERSONNE
                  isResidence
                      ? SizedBox(
                          width: size.width,
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
                                  text: program.nbPerson.toString(),
                                  size: 17.0,
                                  weight: FontWeight.w500),
                            ],
                          ),
                        )
                      : Container(),
                  const Divider(
                    thickness: 1,
                  ),
                  // PRIX
                  SizedBox(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(style: textFont(), children: [
                          TextSpan(
                              text: isResidence
                                  ? "Prix/jour: "
                                  : "Coût de la visite: "),
                          TextSpan(
                              text: isResidence
                                  ? cfaformat.format(program.item['cost'])
                                  : program.cost == 0
                                      ? "0 XOF"
                                      : cfaformat.format(program.cost),
                              style: textFont(
                                  size: 16.0,
                                  weight: FontWeight.w600,
                                  color: Colors.grey[800]))
                        ])),
                        SizedBox(height: size.height * 0.006),
                        Container(
                            width: size.width * 0.9,
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
                                    text: isResidence
                                        ? "Total (${program.nbDays} jrs)"
                                        : "Total",
                                    color: Colors.blue[900]),
                                customText(
                                    text: program.cost == 0
                                        ? "0 XOF"
                                        : cfaformat.format(program.cost),
                                    size: 20.0,
                                    weight: FontWeight.w600,
                                    color: Colors.blue[900])
                              ],
                            )),
                      ],
                    ),
                  ),
                  // PAY OR NOT
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: size.width * 0.8,
                        height: 30,
                        color: cancelled ? Colors.red[200] : Colors.green[200],
                        child: Center(
                          child: customText(
                              text: cancelled
                                  ? "Programmation expirée ou annulée"
                                  : "Programmation confirmée",
                              size: 13.0,
                              color: Colors.white),
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
