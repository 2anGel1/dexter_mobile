// ignore_for_file: use_build_context_synchronously

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/programmationprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarCancel extends StatefulWidget {
  const CalendarCancel({super.key});

  @override
  State<CalendarCancel> createState() => _CalendarCancelState();
}

class _CalendarCancelState extends State<CalendarCancel> {
  //

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final programmation = Provider.of<ProgrammationProvider>(context);
    //
    return SizedBox(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gold,
          centerTitle: false,
          title: customText(
              text: "Période alternative", size: 16.0, color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // reservation.reset();
            },
            icon: const Icon(
              Icons.cancel_rounded,
              size: 20,
            ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                if (programmation.nbDays == programmation.currentDays) {
                  programmation.startcancel = true;
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: customText(
                        text:
                            "Le nombre de jour doit être le même que celui de la reservaation actuelle..",
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
                    text: "Valider",
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
                                  programmation.period['date_start']!)),
                          style: textFont(size: 17.0, weight: FontWeight.w500)),
                      const TextSpan(text: " au "),
                      TextSpan(
                          text: DateFormat("EEEE dd", 'fr_FR').format(
                              DateTime.parse(
                                  programmation.period['date_end']!)),
                          style: textFont(size: 17.0, weight: FontWeight.w500)),
                      TextSpan(
                        text: " (${programmation.nbDays} jrs) ",
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
              const SizedBox(height: 5),
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
                      blackoutDates: programmation.busydates),
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
                    programmation.updatePeriod(args);
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
