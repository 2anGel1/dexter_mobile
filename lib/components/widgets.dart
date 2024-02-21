import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textFont(
    {size = 15.0, color = Colors.black, weight = FontWeight.normal}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: size.toDouble(), color: color, fontWeight: weight));
}

Text customText(
    {text,
    size = 15.0,
    color = Colors.black,
    weight = FontWeight.normal,
    center = false}) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    textAlign: center ? TextAlign.center : null,
    style: textFont(size: size, color: color, weight: weight),
  );
}

SizedBox customButton(
    {context, child, color, ontap, height = 50.0, width = 0}) {
  final size = MediaQuery.of(context).size;
  return SizedBox(
    height: height,
    width: width == 0 ? size.width : width,
    child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: child),
  );
}

SizedBox customButtonRadius(
    {context, child, color, ontap, height = 50.0, width = 0, radius = 10.0}) {
  final size = MediaQuery.of(context).size;
  return SizedBox(
    height: height,
    width: width == 0 ? size.width : width,
    child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)))),
        child: child),
  );
}

Card itemStyleOne({size, image, place, price, busy = false}) {
  return Card(
    elevation: 3,
    child: SizedBox(
      child: Stack(
        children: [
          SizedBox(
            height: size.height * 0.30,
            width: size.width * 0.5,
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return ErrorWidget('Failed to load image: $error');
              },
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                  height: 60,
                  width: size.width * 0.5,
                  color: const Color.fromARGB(184, 255, 255, 255),
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(
                          text: place, weight: FontWeight.w400, size: 13.5),
                      customText(
                          text: price, weight: FontWeight.bold, size: 14.5)
                    ],
                  ))),
          !busy
              ? Container()
              : Positioned(
                  top: 0,
                  child: Container(
                      height: 30,
                      width: size.width * 0.5,
                      color: Colors.red,
                      padding:
                          const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                              text: "Indisponible",
                              weight: FontWeight.bold,
                              color: Colors.white,
                              size: 12.0)
                        ],
                      )))
        ],
      ),
    ),
  );
}

Container commodityItemOne(size, itemTitle) {
  return Container(
      width: size.width * 0.25,
      decoration: BoxDecoration(
          color: const Color.fromARGB(91, 133, 190, 236),
          border: Border.all(width: 0.4, color: mainBlue),
          borderRadius: const BorderRadius.all(Radius.circular(100))),
      child: Center(
        child: customText(text: itemTitle, size: 11.5, color: Colors.blue[900]),
      ));
}

SizedBox verticalspace(space) {
  return SizedBox(
    height: space.toDouble(),
  );
}

SizedBox horizontalspace(space) {
  return SizedBox(
    width: space.toDouble(),
  );
}

Widget loader() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
          margin: const EdgeInsets.only(bottom: 0),
          height: 35,
          width: 35,
          child:
              Image.asset('assets/images/dexter_logo.png', fit: BoxFit.cover)),
      verticalspace(5),
      customText(text: "Chargement..", size: 13)
    ],
  );
}
