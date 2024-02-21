import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/screens/pages/visitesteps/paiementvisite.dart';
import 'package:dexter_mobile/screens/pages/visitesteps/resumevisite.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class VisiteStepOneScreen extends StatefulWidget {
  const VisiteStepOneScreen({super.key});

  @override
  State<VisiteStepOneScreen> createState() => _VisiteStepOneScreenState();
}

class _VisiteStepOneScreenState extends State<VisiteStepOneScreen> {
  //
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
              text: "Visite: étape 1", size: 16.0, color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              reservation.reset();
            },
            icon: const Icon(
              Icons.cancel_rounded,
              size: 20,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    barrierColor: Colors.black.withOpacity(0),
                    builder: (context) {
                      return detail.loctype == "loc"
                          ? const PaiementVisiteStepScreen()
                          : const ResumeVisiteStepScreen();
                    });
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
                  height: size.height * 0.1,
                  padding: EdgeInsets.only(left: size.height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: "Date de la visite",
                        size: 16.0,
                        weight: FontWeight.w700,
                      ),
                      RichText(
                          text:
                              TextSpan(style: textFont(size: 16.0), children: [
                        TextSpan(
                            text: DateFormat("EEEE dd MMMM", 'fr_FR')
                                .format(DateTime.parse(reservation.date)),
                            style: textFont(size: 17.0)),
                      ]))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // CALENDAR DISPLAY
                detail.loctype == "ven"
                    ? Container(
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(141, 187, 222, 251),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.single,
                          selectionShape:
                              DateRangePickerSelectionShape.rectangle,
                          selectionColor: gold,
                          monthViewSettings: DateRangePickerMonthViewSettings(
                              blackoutDates: reservation.item['busy_dates']),
                          initialSelectedDate: DateTime.now(),
                          rangeTextStyle: textFont(color: Colors.white),
                          headerStyle:
                              DateRangePickerHeaderStyle(textStyle: textFont()),
                          minDate: DateTime.now(),
                          onSelectionChanged: (args) {
                            reservation.updateDate(args);
                          },
                        ))
                    : SizedBox(
                        width: size.width,
                        child: Column(
                          children: [
                            const Divider(),
                            // TODAY
                            InkWell(
                              onTap: () {
                                reservation.selectday(0);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: size.height * 0.1,
                                width: reservation.selectedDay == 0
                                    ? size.width * 0.85
                                    : size.width * 0.8,
                                child: Container(
                                  height: size.height * 0.1,
                                  width: reservation.selectedDay == 0
                                      ? size.width * 0.85
                                      : size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: reservation.selectedDay == 0
                                          ? Colors.grey[400]
                                          : Colors.grey[200],
                                      border: reservation.selectedDay == 0
                                          ? Border.all(
                                              color: Colors.grey[700]!,
                                              width: 2)
                                          : null,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: customText(
                                        text: "Aujourd'hui",
                                        size: reservation.selectedDay == 0
                                            ? 18.0
                                            : 15.0,
                                        weight: reservation.selectedDay == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            // TOMORROW
                            InkWell(
                              onTap: () {
                                reservation.selectday(1);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: size.height * 0.1,
                                width: reservation.selectedDay == 1
                                    ? size.width * 0.85
                                    : size.width * 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: reservation.selectedDay == 1
                                          ? Colors.grey[400]
                                          : Colors.grey[200],
                                      border: reservation.selectedDay == 1
                                          ? Border.all(
                                              color: Colors.grey[700]!,
                                              width: 2)
                                          : null,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: customText(
                                        text: "Demain",
                                        size: reservation.selectedDay == 1
                                            ? 18.0
                                            : 15.0,
                                        weight: reservation.selectedDay == 1
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            // THE DAY AFTER TOMOROW
                            InkWell(
                              onTap: () {
                                reservation.selectday(2);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: size.height * 0.1,
                                width: reservation.selectedDay == 2
                                    ? size.width * 0.85
                                    : size.width * 0.8,
                                child: Container(
                                  height: size.height * 0.1,
                                  width: reservation.selectedDay == 2
                                      ? size.width * 0.85
                                      : size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: reservation.selectedDay == 2
                                          ? Colors.grey[400]
                                          : Colors.grey[200],
                                      border: reservation.selectedDay == 2
                                          ? Border.all(
                                              color: Colors.grey[700]!,
                                              width: 2)
                                          : null,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: customText(
                                        text: "Après demain",
                                        size: reservation.selectedDay == 2
                                            ? 18.0
                                            : 15.0,
                                        weight: reservation.selectedDay == 2
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
