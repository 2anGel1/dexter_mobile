// ignore_for_file: use_build_context_synchronously

import 'package:cinetpay/cinetpay.dart';
import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/screens/pages/payments/paymentcomplete.dart';
import 'package:dexter_mobile/screens/pages/payments/paymenterror.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ResumeVisiteStepScreen extends StatefulWidget {
  const ResumeVisiteStepScreen({super.key});

  @override
  State<ResumeVisiteStepScreen> createState() => _ResumeVisiteStepScreenState();
}

class _ResumeVisiteStepScreenState extends State<ResumeVisiteStepScreen> {
  //
  final String _confButton = "Finaliser";
  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final reservation = Provider.of<ReservationProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    String payurl = "";
    switch (reservation.payment) {
      case 1:
        payurl = "assets/images/moyensdepaiements/wave.png";
        break;
      case 2:
        payurl = "assets/images/moyensdepaiements/orange.png";
        break;
      case 3:
        payurl = "assets/images/moyensdepaiements/moov.png";
        break;
      case 4:
        payurl = "assets/images/moyensdepaiements/moov.png";
        break;
      default:
        payurl = "assets/images/moyensdepaiements/carte.jpeg";
    }
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gold,
          centerTitle: false,
          title: customText(text: "Résumé", size: 16.0, color: Colors.white),
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
                      if (reservation.payment == 0) {
                        reservation.cost = 0;
                      } else {
                        reservation.cost = 5000;
                      }
                      await reservation.makevisite();
                      if (reservation.error == "") {
                        if (reservation.payment != 0) {
                          await showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context) {
                                reservation.paymentstart = true;
                                return CinetPayCheckout(
                                    title: 'Paiement de la visite',
                                    configData: <String, dynamic>{
                                      'apikey': Links.cinetpayapikey,
                                      'site_id': Links.cinetpaysiteid,
                                      'notify_url':
                                          'https://mondomaine.com/notify/'
                                    },
                                    paymentData: <String, dynamic>{
                                      'transaction_id': reservation
                                          .trans, //widget.transId.toString(),
                                      'amount': reservation.cost,
                                      'currency': 'XOF',
                                      'channels': reservation
                                          .getmodpay()
                                          .modelchannelcinet,
                                      'description': "Paiement: visite",
                                      'customer_name':
                                          user.firstName.toUpperCase(),
                                      'customer_city': 'city',
                                      'customer_email': user.email,
                                      'customer_surname':
                                          user.lastName.toUpperCase(),
                                      'customer_address': 'address',
                                      'customer_country': "CI",
                                      'customer_zip_code': "zip_code",
                                      'customer_phone_number':
                                          user.phone.toString()
                                    },
                                    waitResponse: (response) {
                                      debugPrint("CINETPAY RESPONSE\n");
                                      print(response);
                                      if (response['status'] == "ACCEPTED") {
                                        reservation.paymentcomplete = true;
                                      } else {
                                        reservation.paymentcomplete = false;
                                      }
                                      Navigator.pop(context);
                                    },
                                    onError: (error) {
                                      debugPrint("CINETPAY ERROR\n");
                                      print(error);
                                      reservation.paymentcomplete = false;
                                      Navigator.pop(context);
                                    });
                              });
                          await reservation.checkPayment();
                          await context.read<ReservDetailProvider>().loadItem();
                          if (reservation.paymentcomplete) {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                enableDrag: false,
                                barrierColor: Colors.black.withOpacity(0),
                                builder: (context) {
                                  return PaiementCompleteScreen(
                                    times: reservation.payment == 0 ? 3 : 4,
                                  );
                                });
                          } else {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                enableDrag: false,
                                barrierColor: Colors.black.withOpacity(0),
                                builder: (context) {
                                  return PaiementErrorScreen(
                                    times: 5,
                                  );
                                });
                          }
                        } else {
                          await context.read<ReservDetailProvider>().loadItem();
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              barrierColor: Colors.black.withOpacity(0),
                              builder: (context) {
                                return PaiementCompleteScreen(
                                  times: reservation.payment == 0 ? 3 : 4,
                                );
                              });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: customText(
                              text: reservation.error,
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
                child: reservation.loading
                    ? customText(
                        text: "Envoie..",
                        color: Colors.white,
                        weight: FontWeight.w500)
                    : customText(
                        text: "Confirmer",
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
                        text: "Résumé de la programmation",
                        size: 16.0,
                        weight: FontWeight.w700,
                      ),
                      customText(
                        text:
                            "Cliquer sur 'Confimer' si vous êtes d'accord avec les informations de votre programmation",
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
                                  text: "Total à payer",
                                  color: Colors.blue[900]),
                              customText(
                                  text: reservation.cost == 0
                                      ? "0 XOF"
                                      : cfaformat.format(reservation.cost),
                                  size: 20.0,
                                  weight: FontWeight.w600,
                                  color: Colors.blue[900])
                            ],
                          )),
                      SizedBox(height: size.height * 0.01),
                      // DATE
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
                              customText(text: "Date", color: Colors.blue[900]),
                              customText(
                                  text: DateFormat("EEEE dd MMMM", 'fr_FR')
                                      .format(DateTime.parse(reservation.date)),
                                  size: 17.0,
                                  weight: FontWeight.w600,
                                  color: Colors.blue[900])
                            ],
                          )),
                      SizedBox(height: size.height * 0.01),
                      // PAYMENT
                      reservation.cost == 0
                          ? Container()
                          : Container(
                              width: size.width,
                              height: size.height * 0.07,
                              padding:
                                  EdgeInsets.only(left: size.height * 0.01),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 0.4, color: Colors.blue[900]!)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(
                                      text: "Moyen de paiement",
                                      color: Colors.blue[900],
                                      size: 14.0),
                                  Container(
                                    width: size.width * 0.17,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(payurl),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              )),
                      SizedBox(height: size.height * 0.05),
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
