// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/screens/pages/picturesdisplay.dart';
import 'package:dexter_mobile/screens/pages/reservationsteps/reservationstepone.dart';
import 'package:dexter_mobile/screens/pages/visitesteps/visitestepone.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailItem extends StatefulWidget {
  const DetailItem({super.key});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  //

  //
  Future<void> loaddata() async {
    await context.read<ReservDetailProvider>().loadItem();
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
    final size = MediaQuery.of(context).size;
    final detail = Provider.of<ReservDetailProvider>(context);
    final List images = detail.item['photos'] ?? [];
    //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: InkWell(
            onTap: () {
              detail.loadItem(fromInside: true);
            },
            child: Container(
                margin: const EdgeInsets.only(bottom: 0),
                height: 35,
                width: 35,
                child: Image.asset('assets/images/dexter_logo.png',
                    fit: BoxFit.cover)),
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          color: Colors.grey[100],
          child: detail.load
              ? Center(
                  child: loader(),
                )
              : Stack(
                  children: [
                    ListView(
                      children: [
                        // ITEM IMAGES
                        CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            aspectRatio: 1.5,
                            initialPage: 0,
                          ),
                          items: images.isEmpty
                              ? [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"),
                                            fit: BoxFit.contain)),
                                  ),
                                ]
                              : images.map((iimage) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PicturesDisplayScreen(
                                                      images: images)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  // "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                                  "$imageUrl/image/${iimage['image'].toString()}"),
                                              fit: BoxFit.contain)),
                                    ),
                                  );
                                }).toList(),
                        ),
                        // ITEM TITLE, LOCATION, VISIT NOW BUTTON
                        Container(
                            color: Colors.white,
                            width: size.width,
                            padding: EdgeInsets.only(
                                left: size.height * 0.01,
                                top: size.height * 0.015),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TITLE AND LOCATION
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                          text: detail.item['name'],
                                          size: 17.5,
                                          weight: FontWeight.w600),
                                      Row(
                                        children: [
                                          Icon(Icons.place_rounded,
                                              color: Colors.blue[900],
                                              size: 15),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            height: 40,
                                            child: customText(
                                                text:
                                                    "${detail.item['municipality']['name'].toString().toUpperCase()} ,\n${detail.item['adress'] ?? ""}",
                                                color: Colors.grey[600],
                                                weight: FontWeight.w500,
                                                size: 11.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // VISIT NOW BUTTON
                                detail.category != "res"
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: customButtonRadius(
                                            context: context,
                                            width: size.width * 0.45,
                                            height: 35.0,
                                            color: Colors.grey[800],
                                            radius: 20.0,
                                            child: customText(
                                                text: "Visiter maintenant",
                                                color: Colors.white,
                                                size: 13.0),
                                            ontap: () {
                                              if (context
                                                  .read<AuthProvider>()
                                                  .connected) {
                                                if (detail.available) {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isDismissible: false,
                                                      enableDrag: false,
                                                      builder: (context) {
                                                        Provider.of<ReservationProvider>(
                                                                context,
                                                                listen: false)
                                                            .setitem(
                                                                detail.item);

                                                        return const VisiteStepOneScreen();
                                                      });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    showCloseIcon: true,
                                                    closeIconColor:
                                                        Colors.white,
                                                    content: Text(
                                                        "Désolé, ce bien n'est pas diponible actuellement !"),
                                                    duration: Duration(
                                                        milliseconds: 2000),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Vous n'êtes pas connecté"),
                                                  duration: Duration(
                                                      milliseconds: 1500),
                                                  backgroundColor: Colors.black,
                                                ));
                                              }
                                            }),
                                      )
                                    : Container()
                              ],
                            )),
                        // SEPARATOR
                        Container(
                          width: size.width,
                          color: Colors.white,
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[500],
                          ),
                        ),
                        // LISTE COMMODITY
                        detail.item['comodites'] == null ||
                                detail.item['comodites'].isEmpty
                            ? Container()
                            : Container(
                                width: size.width,
                                height: size.height * 0.05,
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.height * 0.01),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: size.height * 0.01);
                                  },
                                  itemCount: detail.item['comodites'].length,
                                  itemBuilder: (context, index) {
                                    final com = detail.item['comodites'][index];
                                    return commodityItemOne(size,
                                        "${com['label']} x${com['pivot']['number']}");
                                  },
                                )),
                        // PRICE
                        Container(
                            width: size.width,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border(bottom: BorderSide(width: 0.05))),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: size.width * 0.2,
                                      color: Colors.black,
                                      child: Center(
                                        child: customText(
                                            text: detail.loctype == "ven"
                                                ? "À vendre"
                                                : "À louer",
                                            size: 12.0,
                                            color: Colors.white,
                                            weight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: size.width * 0.25,
                                      color: detail.available
                                          ? Colors.green
                                          : Colors.red,
                                      child: Center(
                                        child: customText(
                                            text: detail.available
                                                ? "Disponible"
                                                : "Indisponible",
                                            size: 12.0,
                                            color: Colors.white,
                                            weight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // SizedBox(height: size.height * 0.04),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.money,
                                            size: 20,
                                            color: Colors.blueGrey[700],
                                          ),
                                          const SizedBox(width: 2),
                                          customText(
                                              text: detail.category == "res"
                                                  ? "Prix /jour"
                                                  : "Prix",
                                              size: 13.0,
                                              color: Colors.blueGrey[900],
                                              weight: FontWeight.w500),
                                        ]),
                                    customText(
                                        text: cfaformat
                                            .format(detail.item['cost']),
                                        size: 18.5,
                                        color: Colors.black,
                                        weight: FontWeight.bold)
                                  ],
                                )
                              ],
                            )),
                        const Divider(
                          thickness: 2,
                          color: Colors.white,
                        ),
                        // OTHER INFORMATIONS
                        Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.03),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(width: 0.05),
                                  bottom: BorderSide(width: 0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: size.height * 0.02),
                              // ROW 1
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ITEM 1
                                    SizedBox(
                                        width: size.width * 0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                                text: "Ville",
                                                size: 14.5,
                                                weight: FontWeight.w600),
                                            customText(
                                                text:
                                                    detail.item['municipality']
                                                            ['city']['name'] ??
                                                        "nan",
                                                size: 13.5,
                                                color: Colors.blue[900])
                                          ],
                                        )),
                                    VerticalDivider(
                                      color: Colors.grey[500],
                                    ),
                                    SizedBox(
                                      width: size.width * 0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customText(
                                              text: "Commune",
                                              size: 14.5,
                                              weight: FontWeight.w600),
                                          customText(
                                              text: detail.item['municipality']
                                                  ['name'],
                                              size: 13.5,
                                              color: Colors.blue[900])
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SOME SPACE
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              // ROW 2
                              detail.category != "ter"
                                  ? IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // ITEM 1
                                          SizedBox(
                                              width: size.width * 0.4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      text: "Type de bien",
                                                      size: 14.5,
                                                      weight: FontWeight.w600),
                                                  customText(
                                                      text:
                                                          detail.item['type'] ??
                                                              "nan",
                                                      size: 13.5,
                                                      color: Colors.blue[900])
                                                ],
                                              )),
                                          VerticalDivider(
                                              color: Colors.grey[500]),
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                customText(
                                                    text: "Nombre de pièces",
                                                    size: 14.5,
                                                    weight: FontWeight.w600),
                                                customText(
                                                    text: detail.item['room'] ??
                                                        "nan",
                                                    size: 13.5,
                                                    color: Colors.blue[900])
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // ITEM 1
                                          SizedBox(
                                              width: size.width * 0.4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      text: "Superficie",
                                                      size: 14.5,
                                                      weight: FontWeight.w600),
                                                  customText(
                                                      text:
                                                          "${detail.item['area']} m2",
                                                      size: 13.5,
                                                      color: Colors.blue[900])
                                                ],
                                              )),
                                          VerticalDivider(
                                              color: Colors.grey[500]),
                                          // ITEM 2
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                customText(
                                                    text: "Ilot",
                                                    size: 14.5,
                                                    weight: FontWeight.w600),
                                                customText(
                                                    text: detail.item['ilot'],
                                                    size: 13.5,
                                                    color: Colors.blue[900])
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              // SPACE
                              SizedBox(height: size.height * 0.05),
                            ],
                          ),
                        ),
                        // SOME SPACE
                        const Divider(
                          thickness: 2,
                          color: Colors.white,
                        ),
                        // DESCRIPTION
                        Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.03),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(width: 0.05),
                                  bottom: BorderSide(width: 0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SPACE
                              SizedBox(height: size.height * 0.02),
                              // DESCRIPTION
                              customText(
                                  text: "Description",
                                  size: 16.0,
                                  weight: FontWeight.w600),
                              // SPACE
                              SizedBox(height: size.height * 0.01),
                              // TEXTE
                              customText(
                                text: detail.item['description'] ?? "nan",
                                size: 13.0,
                              ),
                              // SPACE
                              SizedBox(height: size.height * 0.02),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.white,
                        ),
                        // OWNER INFO
                        Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.03),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(width: 0.05),
                                    bottom: BorderSide(width: 0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.02),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ITEM 1
                                      SizedBox(
                                          width: size.width * 0.4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              customText(
                                                  text: "Localisation GPS",
                                                  size: 14.5,
                                                  weight: FontWeight.w600),
                                              detail.item['localisation_gps'] ==
                                                      null
                                                  ? Column(
                                                      children: [
                                                        verticalspace(10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .warning_amber_rounded,
                                                              color: Colors
                                                                  .black54,
                                                              size: 14,
                                                            ),
                                                            customText(
                                                                text:
                                                                    "pas précisée",
                                                                size: 13.5,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black54),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : InkWell(
                                                      onTap: () async {
                                                        if (await launchUrl(
                                                            Uri.parse(detail
                                                                .item[
                                                                    'localisation_gps']
                                                                .toString()))) {
                                                        } else {
                                                          debugPrint(
                                                              "Impossible d'ouvrir l'url");
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 75,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/gps.webp"),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                    )
                                            ],
                                          )),
                                      VerticalDivider(
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            customText(
                                                text: "Contactez-nous",
                                                size: 14.5,
                                                weight: FontWeight.w600),
                                            verticalspace(10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: customButtonRadius(
                                                  context: context,
                                                  width: size.width * 0.8,
                                                  height: 25.0,
                                                  color: gold,
                                                  radius: 20.0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      customText(
                                                          text: detail
                                                                  .item['user']
                                                              ['phone'],
                                                          size: 13,
                                                          weight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                      const Center(
                                                        child: Icon(
                                                          Icons.phone,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ontap: () async {
                                                    if (context
                                                        .read<AuthProvider>()
                                                        .connected) {
                                                      final url =
                                                          "tel:+225${detail.item['user']['phone']}";

                                                      if (await canLaunchUrl(
                                                          Uri.parse(url))) {
                                                        await launchUrl(
                                                            Uri.parse(url));
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Impossible de contacter $url."),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1500),
                                                          backgroundColor:
                                                              Colors.black,
                                                        ));
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            "Vous ne pouver pas éffecetuer cette action si vous n'êtes pas connectés."),
                                                        duration: Duration(
                                                            milliseconds: 1500),
                                                        backgroundColor:
                                                            Colors.black,
                                                      ));
                                                    }
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: detail.category == 'res'
                                        ? size.height * 0.12
                                        : size.height * 0.05),
                              ],
                            ))
                      ],
                    ),
                    // RESERVATION BUTTON
                    detail.category == 'res'
                        ? Positioned(
                            bottom: 0,
                            child: Container(
                              width: size.width,
                              height: size.height * 0.1,
                              padding: EdgeInsets.all(size.height * 0.015),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, -0.5),
                                      blurRadius: 5.0,
                                    )
                                  ]),
                              child: customButton(
                                  context: context,
                                  ontap: () {
                                    if (context
                                        .read<AuthProvider>()
                                        .connected) {
                                      if (detail.available) {
                                        showModalBottomSheet(
                                            context: context,
                                            isDismissible: false,
                                            enableDrag: false,
                                            builder: (context) {
                                              Provider.of<ReservationProvider>(
                                                      context,
                                                      listen: false)
                                                  .setitem(detail.item);
                                              return const ReservationStepOneScreen();
                                            });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          showCloseIcon: true,
                                          closeIconColor: Colors.white,
                                          content: Text(
                                              "Désolé, ce bien n'est pas diponible actuellement !"),
                                          duration:
                                              Duration(milliseconds: 2000),
                                          backgroundColor: Colors.black,
                                        ));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Vous n'êtes pas connecté"),
                                        duration: Duration(milliseconds: 1500),
                                        backgroundColor: Colors.black,
                                      ));
                                    }
                                  },
                                  height: 20.0,
                                  width: size.width * 0.7,
                                  color: gold, //mainBlue,
                                  child: customText(
                                      text: "Faire une réservation",
                                      color: Colors.white,
                                      size: 15.5)),
                            ))
                        : Container()
                  ],
                ),
        ),
      ),
    );
  }
}
