// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentShow extends StatefulWidget {
  PaymentShow({super.key, required this.reservations});
  List reservations;

  @override
  State<PaymentShow> createState() => _PaymentShowState();
}

class _PaymentShowState extends State<PaymentShow> {
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: gold,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: customText(
                text: "Programmations concernées", color: Colors.white),
          ),
          body: SizedBox(
            height: size.height,
            width: size.width,
            child: ListView.builder(
                itemCount: widget.reservations.length,
                itemBuilder: (context, index) {
                  final item = widget.reservations[index];
                  final newprice = item['cost'] - (item['cost'] * 0.2);
                  // print(item);
                  return Container(
                    padding: const EdgeInsets.all(15.0),
                    width: size.width,
                    decoration: const BoxDecoration(
                        color: Colors.black12,
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black26, width: 0.2))),
                    // color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                  text: "Période",
                                  color: Colors.black,
                                  weight: FontWeight.w500,
                                  size: 13.0),
                              customText(
                                  text: DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(item['date_start']
                                          .toString()
                                          .substring(0, 10))),
                                  color: Colors.black38,
                                  weight: FontWeight.bold,
                                  size: 14.5),
                              customText(
                                  text: DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(item['date_end']
                                          .toString()
                                          .substring(0, 10))),
                                  color: Colors.black38,
                                  weight: FontWeight.bold,
                                  size: 14.5),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customText(
                                  text: "Montant",
                                  color: Colors.black,
                                  weight: FontWeight.w500,
                                  size: 13.0),
                              customText(
                                  text: newprice == 0
                                      ? "0 XOF"
                                      : cfaformat.format(newprice.round()),
                                  color: Colors.black38,
                                  weight: FontWeight.bold,
                                  size: 14.5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
