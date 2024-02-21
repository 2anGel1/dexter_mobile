import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/homeprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/providers/searchprovider.dart';
import 'package:dexter_mobile/routes/routemanager.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef MapCallBack = void Function();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.search});
  final MapCallBack search;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  double _size = 200;
  //
  Future<void> loadData() async {
    await context.read<HomeProvider>().fetchResidences();
  }

  //
  @override
  void initState() {
    super.initState();
    loadData();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final home = Provider.of<HomeProvider>(context);
    final search = Provider.of<SearchProvider>(context);
    double topSize = _size;
    //
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.axis == Axis.vertical) {
                        if (scrollNotification.metrics.pixels > 50) {
                          _size = size.height * 0.15;
                        } else {
                          _size = size.height * 0.25;
                        }
                        setState(() {});
                      }
                      return true;
                    },
                    child: ListView(children: [
                      // FIXED TOP SPACE COMPLETE
                      SizedBox(
                        height: topSize,
                        width: size.width,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // QUE CHERCHEZ-VOUS
                              customText(
                                  text: "Que cherchez-vous ?",
                                  size: 20.0,
                                  color: Colors.grey[900],
                                  weight: FontWeight.bold),
                              // LIST OF CATEGORIES
                              SizedBox(
                                height: size.height * 0.08,
                                width: size.width,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  children: [
                                    // MAISON
                                    customButtonRadius(
                                        context: context,
                                        ontap: () {
                                          search.selectcategory("Résidence");
                                          widget.search();
                                        },
                                        radius: 5.0,
                                        color: gold,
                                        width: size.width * 0.4,
                                        child: customText(
                                            text: "Résidence >",
                                            color: Colors.white)),
                                    const SizedBox(width: 10),
                                    customButtonRadius(
                                        context: context,
                                        ontap: () {
                                          search.selectcategory("Maison");
                                          widget.search();
                                        },
                                        radius: 5.0,
                                        color: gold,
                                        width: size.width * 0.4,
                                        child: customText(
                                            text: "Maison >",
                                            color: Colors.white)),
                                    const SizedBox(width: 10),
                                    customButtonRadius(
                                        context: context,
                                        ontap: () {
                                          search.selectcategory("Térrain");
                                          widget.search();
                                        },
                                        radius: 5.0,
                                        color: gold,
                                        width: size.width * 0.4,
                                        child: customText(
                                            text: "Terrain >",
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                              // SOME SPACE
                              const SizedBox(height: 20),
                              // NOS RESIDENCES...
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  customText(
                                      text: "Nos résidences\nmeublées",
                                      size: 18.0,
                                      color: Colors.blueGrey[800],
                                      weight: FontWeight.bold),
                                  GestureDetector(
                                    onTap: () {
                                      search.selectcategory("Résidence");
                                      widget.search();
                                    },
                                    child: customText(
                                        text: "Voir plus ->",
                                        size: 12.0,
                                        color: gold,
                                        weight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // LIST OF RESIDENCES
                              // ROW 1
                              SizedBox(
                                  height: size.height * 0.30,
                                  width: size.width,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: home.residences1.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 5);
                                    },
                                    itemBuilder: (context, index) {
                                      final property = home.residences1[index];
                                      final List images =
                                          property['photos'] ?? [];
                                      return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<ReservDetailProvider>()
                                                .setitemid(property['id']);
                                            Navigator.pushNamed(context,
                                                RouteManager.itemDetail);
                                          },
                                          child: itemStyleOne(
                                              image: images.isNotEmpty
                                                  // ? "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                                  ? "$imageUrl/image/${images[0]['image'].toString()}"
                                                  : "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg",
                                              size: size,
                                              place: property['municipality']
                                                      ['name']
                                                  .toString()
                                                  .toUpperCase(),
                                              price: cfaformat
                                                  .format(property['cost']),
                                              busy: false));
                                    },
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              // ROW 2
                              home.residences2.isEmpty
                                  ? Container()
                                  : SizedBox(
                                      height: size.height * 0.30,
                                      width: size.width,
                                      child: ListView.separated(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: home.residences2.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 5);
                                        },
                                        itemBuilder: (context, index) {
                                          final property =
                                              home.residences2[index];
                                          final List images =
                                              property['photos'];
                                          return GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<ReservDetailProvider>()
                                                  .setitemid(property['id']);
                                              Navigator.pushNamed(context,
                                                  RouteManager.itemDetail);
                                            },
                                            child: itemStyleOne(
                                                image: images.isNotEmpty
                                                    // ? "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                                    ? "$imageUrl/image/${images[0]['image'].toString()}"
                                                    : "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg",
                                                size: size,
                                                place: property['municipality']
                                                        ['name']
                                                    .toString()
                                                    .toUpperCase(),
                                                price: cfaformat
                                                    .format(property['cost']),
                                                busy: false),
                                          );
                                        },
                                      )),
                              const SizedBox(
                                height: 20,
                              ),
                              // À LA RECHERCHE...
                              customText(
                                  text: "À la recherche de terrain ?",
                                  size: 18.0,
                                  color: Colors.blueGrey[800],
                                  weight: FontWeight.bold),
                              customText(
                                text:
                                    "Trouvez en quelques instants des terrains sur tout le territoire grâce à DEXTER. ",
                                size: 14.0,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // AERA PICTURE AND EXPLORE BUTTON
                              Container(
                                  height: size.height * 0.25,
                                  width: size.width,
                                  padding: const EdgeInsets.only(top: 15),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "https://www.parcelle-a-vendre.com/wp-content/uploads/annonces/dcd3785d8a70f0fff6f2edf6562f74ba_1.png"))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // EXPLORER >
                                      customButtonRadius(
                                          context: context,
                                          color: const Color.fromARGB(
                                              147, 238, 231, 231),
                                          ontap: () {
                                            search.selectcategory("Terrain");
                                            widget.search();
                                          },
                                          width: size.width * 0.7,
                                          height: 50.0,
                                          radius: 20.0,
                                          child: customText(
                                              text: "Explorer >", size: 15.5))
                                    ],
                                  )),
                            ],
                          ))
                    ])),

                // FIXED TOP IMAGE
                Positioned(
                    top: 0,
                    child: AnimatedContainer(
                        height: topSize,
                        width: size.width,
                        duration: const Duration(milliseconds: 150),
                        child: Image.asset(
                          "assets/images/dexter_logo.png",
                          fit: BoxFit.cover,
                        ))),

                // FIXED TOP SEARCH BAR
                Positioned(
                    top: topSize - 20,
                    left: 10,
                    right: 10,
                    child: Card(
                        elevation: 5,
                        child: SizedBox(
                            height: 35,
                            width: size.width,
                            child: Center(
                                child: TextField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              onTap: () {
                                widget.search();
                              },
                              decoration: InputDecoration(
                                  hintText:
                                      "Ex: 3 pièces cocody, villa bingerville..",
                                  hintStyle: textFont(size: 13.0),
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, bottom: 15),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Colors.grey,
                                  )),
                            )))))
              ],
            ),
          )),
    );
  }
}
