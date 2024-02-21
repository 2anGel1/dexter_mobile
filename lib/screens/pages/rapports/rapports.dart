// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/constants/data.dart';
import 'package:dexter_mobile/providers/rapportsprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/screens/pages/programations/itemshow.dart';
import 'package:dexter_mobile/screens/pages/rapports/paymentshow.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RapportsScreen extends StatefulWidget {
  const RapportsScreen({super.key});

  @override
  State<RapportsScreen> createState() => _RapportsScreenState();
}

class _RapportsScreenState extends State<RapportsScreen> {
  //
  //
  Future<void> loaddata() async {
    await context.read<RapportsProvider>().loaddata();
  }

  //

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = getsize(context);
    final rapport = Provider.of<RapportsProvider>(context);
    //
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: Stack(
                children: [
                  // TAB BAR
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 70,
                      width: size.width,
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          SizedBox(
                              width: 50,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              )),
                          // LOGO
                          Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              height: 35,
                              width: 35,
                              child: Image.asset(
                                  'assets/images/dexter_logo.png',
                                  fit: BoxFit.cover)),
                          const Expanded(
                            child: TabBar(
                              tabs: [
                                Text(
                                  "Sollicitations",
                                ),
                                Text("Paiements"),
                              ],
                              padding: EdgeInsets.all(8.0),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelPadding: EdgeInsets.all(8.0),
                              unselectedLabelColor: Colors.grey,
                              labelColor: Colors.white,
                              indicator: BoxDecoration(
                                  color: gold,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TAB VIWER
                  Positioned(
                    top: 70,
                    child: Container(
                        height: size.height * 0.9,
                        width: size.width,
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/dexter_logo.png"),
                                fit: BoxFit.contain)),
                        child: rapport.load
                            ? Center(
                                child: Container(
                                  width: size.width * 0.4,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Center(
                                      child: SpinKitCircle(
                                          color: Colors.black, size: 25)),
                                ),
                              )
                            : TabBarView(
                                children: [
                                  // SOLLICITATIONS VIEW
                                  rapport.sollicitations.isEmpty
                                      ? Center(
                                          child: Container(
                                            width: size.width * 0.8,
                                            height: 100,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                              child: customText(
                                                text: "Pas de sollicitations",
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              rapport.sollicitations.length,
                                          itemBuilder: (context, index) {
                                            final item =
                                                rapport.sollicitations[index];
                                            final type =
                                                item['date_start'] != null
                                                    ? "res"
                                                    : "vis";
                                            final newprice = item['cost'];
                                            // print(item);
                                            return InkWell(
                                              onTap: () {
                                                if (type == "res") {
                                                  context
                                                      .read<
                                                          ReservationProvider>()
                                                      .setreserv(item,
                                                          other: rapport.good);
                                                } else {
                                                  context
                                                      .read<
                                                          ReservationProvider>()
                                                      .setvisit(item,
                                                          other: rapport.good);
                                                }
                                                showModalBottomSheet(
                                                    context: context,
                                                    isDismissible: false,
                                                    builder: (context) {
                                                      return ItemDetail(
                                                          owner: true);
                                                    });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                width: size.width,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white54,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.black26,
                                                            width: 0.2))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // TYPE
                                                        customText(
                                                            text: type == "res"
                                                                ? "Réservation"
                                                                : "Visite",
                                                            size: 14.0,
                                                            color:
                                                                Colors.black),
                                                        // DATE
                                                        customText(
                                                            text: item[
                                                                    'created_at']
                                                                .toString()
                                                                .substring(
                                                                    0, 10),
                                                            color:
                                                                Colors.black38,
                                                            weight:
                                                                FontWeight.w500,
                                                            size: 16.5),
                                                        // COST
                                                        customText(
                                                            text: newprice == 0
                                                                ? "0 XOF"
                                                                : cfaformat.format(
                                                                    newprice
                                                                        .round()),
                                                            size: 17.0,
                                                            weight: FontWeight
                                                                .bold),
                                                      ],
                                                    ),
                                                    // STATE
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          type == "vis"
                                                              ? Icons
                                                                  .check_circle
                                                              : item['paid'] !=
                                                                      'Impayer'
                                                                  ? Icons
                                                                      .check_circle
                                                                  : FontAwesomeIcons
                                                                      .circleExclamation,
                                                          color: type == "vis"
                                                              ? Colors.green
                                                              : item['paid'] !=
                                                                      'Impayer'
                                                                  ? Colors.green[
                                                                      800]
                                                                  : Colors
                                                                      .red[800],
                                                          size: 35,
                                                        ),
                                                        customText(
                                                            text: type == "vis"
                                                                ? "Payée"
                                                                : item['paid'] !=
                                                                        'Impayer'
                                                                    ? "Payée"
                                                                    : "Impayée",
                                                            size: 13.5,
                                                            color:
                                                                Colors.black45)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                  //
                                  //
                                  //
                                  //
                                  //
                                  // PAIEMENTS VIEW
                                  rapport.paiements.isEmpty
                                      ? Center(
                                          child: Container(
                                            width: size.width * 0.8,
                                            height: 100,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                              child: customText(
                                                text: "Pas de paiements",
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: rapport.paiements.length,
                                          itemBuilder: (context, index) {
                                            final thekey = rapport
                                                .paiements[index].keys
                                                .toList()[0];
                                            final payment = rapport
                                                .paiements[index][thekey];
                                            final total = getTotal(payment);
                                            final paid = payment[0]['paid'] !=
                                                "En Cours";

                                            return InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return PaymentShow(
                                                        reservations: payment,
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  width: size.width,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white54,
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black26,
                                                                  width: 0.2))),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // TYPE
                                                            customText(
                                                                text:
                                                                    "${payment.length} réservation(s)",
                                                                size: 14.0,
                                                                color: Colors
                                                                    .black),
                                                            // DATE
                                                            customText(
                                                                text: thekey,
                                                                color: Colors
                                                                    .black38,
                                                                weight:
                                                                    FontWeight
                                                                        .w500,
                                                                size: 16.5),
                                                            // COST
                                                            customText(
                                                                text: total == 0
                                                                    ? "0 XOF"
                                                                    : cfaformat
                                                                        .format(total
                                                                            .round()),
                                                                size: 17.0,
                                                                weight:
                                                                    FontWeight
                                                                        .bold),
                                                          ],
                                                        ),
                                                        // STATE
                                                        paid
                                                            ? Column(children: [
                                                                const Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 35,
                                                                ),
                                                                customText(
                                                                    text:
                                                                        "Payée",
                                                                    size: 13.5,
                                                                    color: Colors
                                                                        .black45)
                                                              ])
                                                            : TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  bool yes =
                                                                      false;
                                                                  await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return CupertinoAlertDialog(
                                                                          title:
                                                                              const Text("Voulez vous vraiement valider le paiement ?"),
                                                                          actions: <Widget>[
                                                                            CupertinoDialogAction(
                                                                              child: const Text("Oui"),
                                                                              onPressed: () {
                                                                                yes = true;
                                                                                Navigator.of(context).pop();
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

                                                                  if (yes) {
                                                                    await rapport
                                                                        .validatePayment();
                                                                    if (rapport
                                                                        .error
                                                                        .isEmpty) {
                                                                      rapport
                                                                          .loaddata();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content: customText(
                                                                            text:
                                                                                "Paiement validé avec succès",
                                                                            size:
                                                                                13.0,
                                                                            color:
                                                                                Colors.white),
                                                                        duration:
                                                                            const Duration(milliseconds: 1500),
                                                                        closeIconColor:
                                                                            Colors.white,
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                      ));
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content: customText(
                                                                            text: rapport
                                                                                .error,
                                                                            size:
                                                                                13.0,
                                                                            color:
                                                                                Colors.white),
                                                                        duration:
                                                                            const Duration(milliseconds: 1500),
                                                                        showCloseIcon:
                                                                            true,
                                                                        closeIconColor:
                                                                            Colors.white,
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ));
                                                                    }
                                                                  }
                                                                },
                                                                child:
                                                                    customText(
                                                                  text:
                                                                      "Valider le paiement",
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .green[
                                                                      800],
                                                                ))
                                                      ])),
                                            );
                                          }),
                                ],
                              )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
