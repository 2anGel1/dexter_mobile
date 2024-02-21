// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/screens/pages/visitesteps/resumevisite.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaiementVisiteStepScreen extends StatefulWidget {
  const PaiementVisiteStepScreen({super.key});

  @override
  State<PaiementVisiteStepScreen> createState() =>
      _PaiementVisiteStepScreenState();
}

class _PaiementVisiteStepScreenState extends State<PaiementVisiteStepScreen> {
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
    final detail = Provider.of<ReservDetailProvider>(context);
    reservation.updateVisiteCost(detail.loctype == 'ven' ? 0 : 5000);
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gold,
          centerTitle: false,
          title: customText(
              text: "Visite: étape 2", size: 16.0, color: Colors.white),
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
                        if (reservation.payment == 5) {
                          if (checknumbercardfill()) {
                            String nn = "";
                            for (var con in _ncontrollers) {
                              nn += con.text.toString();
                            }
                            String dd =
                                "${_ncontrollers[0].text}/${_ncontrollers[1].text}";
                            String cvv = _dcontrollers.last.text;
                            reservation.setcardinfo({
                              'card_number': nn,
                              'expired_ar': dd,
                              'cvv': cvv
                            });
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                enableDrag: false,
                                barrierColor: Colors.black.withOpacity(0),
                                builder: (context) {
                                  return const ResumeVisiteStepScreen();
                                });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: customText(
                                  text:
                                      "Renseigez correctement les informations de la carte  pour continuer..",
                                  size: 13.0,
                                  color: Colors.white),
                              duration: const Duration(milliseconds: 1500),
                              backgroundColor: Colors.black,
                            ));
                          }
                        } else {
                          reservation.setcardinfo({});
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              barrierColor: Colors.black.withOpacity(0),
                              builder: (context) {
                                return const ResumeVisiteStepScreen();
                              });
                        }
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
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: "Paiement de la visite",
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
                        const TextSpan(text: "Coût de la visite: "),
                        TextSpan(
                            text: cfaformat.format(reservation.cost),
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
                                  text: "Total", color: Colors.blue[900]),
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

                      verticalspace(size.height * 0.03),

                      reservation.payment != 5
                          ? const SizedBox()
                          : SizedBox(
                              width: size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                      text:
                                          "Entrer les informations de la carte",
                                      size: 13.0,
                                      color: Colors.black,
                                      weight: FontWeight.bold),
                                  verticalspace(size.height * 0.003),
                                  // CARD NUMBER
                                  Container(
                                      height: 60,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // PREFIX
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 20),
                                            child: Icon(
                                              CupertinoIcons.creditcard,
                                              color: Colors.blue[700]!,
                                            ),
                                          ),

                                          // NUMBERS
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              '0',
                                              '-',
                                              '1',
                                              '-',
                                              '2',
                                              '-',
                                              '3'
                                            ].map((e) {
                                              final int ind = e == '-'
                                                  ? 0
                                                  : int.parse(e.toString());
                                              return e == '-'
                                                  ? customText(text: e)
                                                  : SizedBox(
                                                      width: 42,
                                                      child: TextField(
                                                        focusNode: e == '-'
                                                            ? null
                                                            : _nnodes[ind],
                                                        controller:
                                                            _ncontrollers[ind],
                                                        onChanged: (value) {
                                                          if (value.length ==
                                                              4) {
                                                            if (ind != 3) {
                                                              _nnodes[ind + 1]
                                                                  .requestFocus();
                                                            } else {
                                                              _nnodes[ind]
                                                                  .unfocus();
                                                            }
                                                          }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "0000",
                                                                focusColor: Colors
                                                                    .transparent,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    );
                                            }).toList(),
                                          ),
                                        ],
                                      )),

                                  verticalspace(10),

                                  // DATE AND CVV
                                  SizedBox(
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.transparent)),
                                            child: Row(
                                              children: [
                                                // PREFIX
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0, right: 20),
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .calendar_badge_minus,
                                                    color: Colors.blue[700]!,
                                                  ),
                                                ),

                                                //DATE
                                                Row(
                                                  children:
                                                      ['0', 's', '1'].map((e) {
                                                    final int ind = e != 's'
                                                        ? int.parse(
                                                            e.toString())
                                                        : 0;
                                                    return e != 's'
                                                        ? SizedBox(
                                                            width: e == '0'
                                                                ? 30
                                                                : 50,
                                                            child: TextField(
                                                              focusNode:
                                                                  _dnodes[ind],
                                                              controller:
                                                                  _dcontrollers[
                                                                      ind],
                                                              onChanged:
                                                                  (value) {
                                                                if (ind == 0) {
                                                                  if (value
                                                                          .length ==
                                                                      2) {
                                                                    _dnodes[ind +
                                                                            1]
                                                                        .requestFocus();
                                                                  }
                                                                } else {
                                                                  if (value
                                                                          .length ==
                                                                      4) {
                                                                    _dnodes[ind]
                                                                        .unfocus();
                                                                  }
                                                                }
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .datetime,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText: e ==
                                                                          '0'
                                                                      ? "mm"
                                                                      : "yyyy",
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none),
                                                            ),
                                                          )
                                                        : const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5.0),
                                                            child: Text("/"),
                                                          );
                                                  }).toList(),
                                                ),
                                              ],
                                            )),

                                        horizontalspace(20),

                                        // CVV
                                        Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.transparent)),
                                            child: Row(
                                              children: [
                                                // PREFIX
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0, right: 20),
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .number_square,
                                                    color: Colors.blue[700]!,
                                                  ),
                                                ),

                                                // CVV
                                                SizedBox(
                                                  width: 45,
                                                  child: TextField(
                                                    controller:
                                                        _dcontrollers.last,
                                                    focusNode: _dnodes.last,
                                                    onChanged: (value) {
                                                      if (value.length == 3) {
                                                        _dnodes.last.unfocus();
                                                      }
                                                    },
                                                    keyboardType:
                                                        TextInputType.datetime,
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText: "CVV",
                                                            focusColor: Colors
                                                                .transparent,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                      verticalspace(size.height * 0.05),
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
