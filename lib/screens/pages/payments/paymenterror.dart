import 'dart:async';

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaiementErrorScreen extends StatefulWidget {
  PaiementErrorScreen({super.key, this.times = 0, this.isNew = true});
  int times;
  bool isNew;

  @override
  State<PaiementErrorScreen> createState() => _PaiementErrorScreenState();
}

class _PaiementErrorScreenState extends State<PaiementErrorScreen> {
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
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
          title: customText(text: "Oops..", size: 17.0, color: Colors.white),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          // color: Colors.white,
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CORPS
              Center(
                child: Text(
                    "Impossible d'effectuer le paiement,\n réessayez plutard !",
                    textAlign: TextAlign.center,
                    style: textFont(size: 15.0)),
              ),
              SizedBox(height: size.height * 0.01),
              customButton(
                  context: context,
                  color: Colors.black38,
                  child:
                      customText(text: "OK", color: Colors.white, size: 18.0),
                  width: size.width * 0.5,
                  ontap: () {
                    for (var i = 0; i < widget.times; i++) {
                      Navigator.pop(context);
                    }
                    Timer(const Duration(seconds: 2), () {
                      reservation.reset();
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
