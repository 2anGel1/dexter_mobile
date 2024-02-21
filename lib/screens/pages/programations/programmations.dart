// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/constants/data.dart';
import 'package:dexter_mobile/providers/programmationprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/screens/pages/programations/itemshow.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProgrammationsScreen extends StatefulWidget {
  const ProgrammationsScreen({super.key});

  @override
  State<ProgrammationsScreen> createState() => _ProgrammationsScreenState();
}

class _ProgrammationsScreenState extends State<ProgrammationsScreen> {
  //

  //
  Future<void> loaddata() async {
    await context.read<ProgrammationProvider>().loaddata();
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
    final programmations = Provider.of<ProgrammationProvider>(context);
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
                                  "Réservations",
                                ),
                                Text("Visites"),
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
                    child: SizedBox(
                        height: size.height * 0.82,
                        width: size.width,
                        child: TabBarView(
                          children: [
                            // RESERVATION VIEW
                            programmations.load
                                ? loader()
                                : programmations.reservations.isEmpty
                                    ? Center(
                                        child: customText(
                                            text: "Pas de réservations"))
                                    : ListView.builder(
                                        itemCount:
                                            programmations.reservations.length,
                                        itemBuilder: (context, index) {
                                          final reservartion = programmations
                                              .reservations[index];
                                          final List images =
                                              reservartion['propriety']
                                                      ['photos'] ??
                                                  [];
                                          return InkWell(
                                            onTap: () async {
                                              programmations
                                                  .setreservationdetails(
                                                      reservartion);
                                              programmations.getbusydates(
                                                  reservartion['propriety']
                                                      ['id']);
                                              context
                                                  .read<ReservationProvider>()
                                                  .setreserv(reservartion);
                                              showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: false,
                                                  builder: (context) {
                                                    return ItemDetail();
                                                  });
                                            },
                                            child: Container(
                                              height: size.height * 0.12,
                                              width: size.width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border(
                                                    bottom: const BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.3),
                                                    right: BorderSide(
                                                        color: reservartion[
                                                                    'status'] ==
                                                                "Annulée"
                                                            ? Colors.red
                                                            : Colors.green,
                                                        width: 5)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: size.width * 0.2,
                                                    height: size.width * 0.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    3)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(images
                                                                    .isNotEmpty
                                                                // ? "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                                                ? "$imageUrl/image/${images[0]['image'].toString()}"
                                                                : "https://badu.ci/uploads/0000/19/2022/02/10/whatsapp-image-2022-02-10-at-110255.jpeg"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      customText(
                                                          text: reservartion[
                                                                  'propriety']
                                                              ['name'],
                                                          size: 16.0,
                                                          color:
                                                              Colors.grey[700],
                                                          weight:
                                                              FontWeight.w600),
                                                      customText(
                                                          size: 12.5,
                                                          text:
                                                              "${DateFormat("dd MMMM", 'fr-FR').format(DateTime.parse(reservartion['date_start'].toString()))} - ${DateFormat("dd MMMM", 'fr-FR').format(DateTime.parse(reservartion['date_end'].toString()))}"),
                                                      SizedBox(
                                                        width: size.width -
                                                            size.width * 0.4,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            customText(
                                                                text: cfaformat.format(
                                                                    reservartion[
                                                                        'cost']),
                                                                size: 13.5),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                            //
                            //
                            //
                            //
                            //
                            // VISITE VIEW
                            programmations.load
                                ? loader()
                                : programmations.visites.isEmpty
                                    ? Center(
                                        child:
                                            customText(text: "Pas de visites"))
                                    : ListView.builder(
                                        itemCount:
                                            programmations.visites.length,
                                        itemBuilder: (context, index) {
                                          final visite =
                                              programmations.visites[index];
                                          final List images =
                                              visite['propriety']['photos'] ??
                                                  [];
                                          String status = visite['status'];
                                          switch (visite['status']) {
                                            case "Attente":
                                              status = "En attente";
                                              break;
                                            case "Annulé":
                                              status = "Annulée";
                                              break;
                                            default:
                                              status = "Éffectuée";
                                          }
                                          if (DateTime.now()
                                                  .difference(DateTime.parse(
                                                      visite['date']
                                                          .toString()
                                                          .substring(0, 10)))
                                                  .inMinutes >
                                              0) {
                                            status = "Non éffectuée";
                                          }
                                          return InkWell(
                                            onTap: () {
                                              programmations
                                                  .setvisitdetails(visite);
                                              context
                                                  .read<ReservationProvider>()
                                                  .setvisit(visite);
                                              showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: false,
                                                  builder: (context) {
                                                    return ItemDetail();
                                                  });
                                            },
                                            child: Container(
                                              height: size.height * 0.12,
                                              width: size.width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border(
                                                    bottom: const BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.3),
                                                    right: BorderSide(
                                                        color: status !=
                                                                "Annulée"
                                                            ? status !=
                                                                    "En attente"
                                                                ? status !=
                                                                        "Non éffectuée"
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .orange
                                                                : Colors.yellow[
                                                                    500]!
                                                            : Colors.red,
                                                        width: 5)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: size.width * 0.2,
                                                    height: size.width * 0.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    3)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(images
                                                                    .isNotEmpty
                                                                // ? "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                                                ? "$imageUrl/image/${images[0]['image'].toString()}"
                                                                : "https://badu.ci/uploads/0000/19/2022/02/10/whatsapp-image-2022-02-10-at-110255.jpeg"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      customText(
                                                          text: visite[
                                                                  'propriety']
                                                              ['name'],
                                                          size: 16.0,
                                                          color:
                                                              Colors.grey[700],
                                                          weight:
                                                              FontWeight.w600),
                                                      customText(
                                                          size: 12.5,
                                                          text: DateFormat(
                                                                  "dd MMMM",
                                                                  'fr-FR')
                                                              .format(DateTime
                                                                  .parse(visite[
                                                                          'date']
                                                                      .toString()))),
                                                      SizedBox(
                                                        width: size.width -
                                                            size.width * 0.3,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            customText(
                                                                text: visite[
                                                                            'cost'] ==
                                                                        0
                                                                    ? "0 XOF"
                                                                    : cfaformat
                                                                        .format(
                                                                            visite['cost']),
                                                                size: 13.5),
                                                            customText(
                                                                text: status,
                                                                size: 13.5),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
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
