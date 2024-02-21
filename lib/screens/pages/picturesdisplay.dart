import 'package:carousel_slider/carousel_slider.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:flutter/material.dart';

class PicturesDisplayScreen extends StatefulWidget {
  PicturesDisplayScreen({super.key, required this.images});

  List images;

  @override
  State<PicturesDisplayScreen> createState() => _PicturesDisplayScreenState();
}

class _PicturesDisplayScreenState extends State<PicturesDisplayScreen> {
  //
  CarouselController buttonCarouselController = CarouselController();
  bool _showbuttons = true;
  //

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
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
            child: Icon(
              Icons.arrow_back,
              color: _showbuttons ? Colors.white : Colors.black,
            ),
          ),
          title: _showbuttons
              ? Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/images/dexter_logo.png',
                      fit: BoxFit.cover))
              : Container(),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  buttonCarouselController.previousPage(curve: Curves.linear);
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    color: _showbuttons ? Colors.white : Colors.black,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  buttonCarouselController.nextPage(curve: Curves.linear);
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_forward,
                    color: _showbuttons ? Colors.white : Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        body: InkWell(
          onTap: () {
            setState(() {
              _showbuttons = !_showbuttons;
            });
          },
          child: Container(
              height: size.height,
              width: size.width,
              color: Colors.black,
              child: Center(
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.7,
                  child: CarouselSlider(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      // enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 0.5,
                      initialPage: 0,
                    ),
                    items: widget.images.map((iimage) {
                      return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    // "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                    "$imageUrl/image/${iimage['image'].toString()}"),
                                fit: BoxFit.contain)),
                      );
                    }).toList(),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
// buttonCarouselController.nextPage(
            // duration: Duration(milliseconds: 300), curve: Curves.linear),