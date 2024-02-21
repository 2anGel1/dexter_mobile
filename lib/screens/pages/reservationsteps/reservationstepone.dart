import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/screens/pages/reservationsteps/reservationsteptwo.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReservationStepOneScreen extends StatefulWidget {
  const ReservationStepOneScreen({super.key});

  @override
  State<ReservationStepOneScreen> createState() =>
      _ReservationStepOneScreenState();
}

class _ReservationStepOneScreenState extends State<ReservationStepOneScreen> {
  //
  final _selectedPeriod = {
    'date_start': DateTime.now().toString(),
    'date_end': DateTime.now().add(const Duration(days: 1)).toString()
  };
  final _periodController = TextEditingController();
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
          backgroundColor: gold,
          centerTitle: false,
          title: customText(
              text: "Réservation: étape 1", size: 16.0, color: Colors.white),
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
                if (reservation.nbDays >= 1) {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: false,
                      barrierColor: Colors.black.withOpacity(0),
                      builder: (context) {
                        return const ReservationStepTwoScreen();
                      });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: customText(
                        text:
                            "Choisisser une période d'au moins 1 jour pour continuer..",
                        size: 13.0,
                        color: Colors.white),
                    duration: const Duration(milliseconds: 3000),
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
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENTÊTE
              Container(
                width: size.width,
                height: size.height * 0.1,
                padding: EdgeInsets.only(left: size.height * 0.05),
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: "Période de réservation",
                      size: 16.0,
                      weight: FontWeight.w700,
                    ),
                    RichText(
                        text: TextSpan(style: textFont(size: 16.0), children: [
                      const TextSpan(
                        text: "Du ",
                      ),
                      TextSpan(
                          text: DateFormat("EEEE dd", 'fr_FR').format(
                              DateTime.parse(
                                  reservation.period['date_start']!)),
                          style: textFont(size: 17.0, weight: FontWeight.w500)),
                      const TextSpan(text: " au "),
                      TextSpan(
                          text: DateFormat("EEEE dd", 'fr_FR').format(
                              DateTime.parse(reservation.period['date_end']!)),
                          style: textFont(size: 17.0, weight: FontWeight.w500)),
                      TextSpan(
                        text: " (${reservation.nbDays} jrs) ",
                      ),
                    ]))
                  ],
                ),
              ),
              Row(
                children: [
                  horizontalspace(size.height * 0.05),
                  Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: customText(
                        text: "12",
                        size: 12.0,
                        color: Colors.white,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  customText(
                    text: " = date indisponible",
                    size: 12.0,
                    weight: FontWeight.w400,
                  )
                ],
              ),
              verticalspace(5),
              // CALENDAR DISPLAY
              Container(
                width: size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(141, 187, 222, 251),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  startRangeSelectionColor: gold,
                  endRangeSelectionColor: gold,
                  rangeSelectionColor: gold,
                  initialSelectedDate: DateTime.now(),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      blackoutDates: reservation.item['busy_dates']),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      blackoutDateTextStyle: textFont(
                        color: Colors.white,
                      ),
                      blackoutDatesDecoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(10))),
                  rangeTextStyle: textFont(color: Colors.white),
                  headerStyle:
                      DateRangePickerHeaderStyle(textStyle: textFont()),
                  minDate: DateTime.now(),
                  initialSelectedRange: PickerDateRange(DateTime.now(),
                      DateTime.now().add(const Duration(days: 1))),
                  onSelectionChanged: (args) {
                    reservation.updatePeriod(args);
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
