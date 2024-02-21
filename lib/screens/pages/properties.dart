import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/providers/propertyprovider.dart';
import 'package:dexter_mobile/screens/pages/newproperty.dart';
import 'package:dexter_mobile/screens/pages/propertydetail.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  //

  //
  Future<void> fetchdaata() async {
    await context.read<PropertyProvider>().getdata(fromprofile: true);
  }

  //
  @override
  void initState() {
    super.initState();
    fetchdaata();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final prop = Provider.of<PropertyProvider>(context);
    //
    return SafeArea(
      child: Scaffold(
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
                // TOP
                Positioned(
                    top: 0,
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back button
                          SizedBox(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          )),
                          // LOGO
                          Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              height: 35,
                              width: 35,
                              child: Image.asset(
                                  'assets/images/dexter_logo.png',
                                  fit: BoxFit.cover)),
                          // SEARCH BAR
                          Container(
                            height: 30,
                            width: size.width * 0.6,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                              child: TextField(
                                style: textFont(size: 12.0),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Rechercher..",
                                  hintStyle: textFont(size: 12.0),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10.0),
                                  prefixIcon: const Icon(
                                    Icons.search_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  focusColor: Colors.transparent,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                // BODY
                Positioned(
                    top: 70,
                    child: Container(
                      height: size.height,
                      width: size.width,
                      color: Colors.white,
                      padding: EdgeInsets.only(bottom: size.height * 0.25),
                      child: prop.load
                          ? loader()
                          : prop.properties.isEmpty
                              ? Center(
                                  child: customText(
                                      text: "Pas de données trouvées"),
                                )
                              : ListView.separated(
                                  itemCount: prop.properties.length,
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final property = prop.properties[index];
                                    final published =
                                        property['status'] != 'Indisponible';
                                    final List images =
                                        property['photos'] ?? [];
                                    return GestureDetector(
                                        onTap: () {
                                          prop.setid(property['id']);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyPropertyScreen()));
                                        },
                                        child: Container(
                                          width: size.width * 0.8,
                                          height: size.height * 0.40,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // ITEM DETAILS
                                              Expanded(
                                                  flex: 0,
                                                  child: SizedBox(
                                                    width: size.width,
                                                    // color: Colors.blue,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // HEAD: TITLE AND LOCALISATION
                                                        SizedBox(
                                                          width: size.width,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // TITLE
                                                              Expanded(
                                                                  child: customText(
                                                                      text: property[
                                                                          'name'],
                                                                      weight: FontWeight
                                                                          .bold,
                                                                      size:
                                                                          15.5)),
                                                              // LOCALISATION
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .place_rounded,
                                                                      color: Colors
                                                                              .blue[
                                                                          900],
                                                                      size: 15),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  customText(
                                                                      text: property['adress'] ??
                                                                          (property['municipality'] == null
                                                                              ? "nan"
                                                                              : property['municipality'][
                                                                                  'name']),
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      weight: FontWeight
                                                                          .w800,
                                                                      size:
                                                                          12.0),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        // SOME SPACE
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01),
                                                        // DESCRIPTION, COMODITY AND PRICE
                                                        SizedBox(
                                                          width: size.width,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // DESCRIPTION
                                                              Expanded(
                                                                flex: 1,
                                                                child: SizedBox(
                                                                    height: 50,
                                                                    child: Text(
                                                                      property[
                                                                              'description'] ??
                                                                          "nan",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: textFont(
                                                                          size:
                                                                              12.5),
                                                                    )),
                                                              ),
                                                              // COM AND PRICE
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    customText(
                                                                        text: property['type'] ??
                                                                            "lot: ${property['lot']}",
                                                                        color: Colors.blue[
                                                                            900],
                                                                        weight: FontWeight
                                                                            .bold,
                                                                        size:
                                                                            12.5),
                                                                    property['room'] !=
                                                                            null
                                                                        ? customText(
                                                                            text:
                                                                                "pièces: ${property['room']}",
                                                                            color: Colors.blue[
                                                                                900],
                                                                            weight: FontWeight
                                                                                .bold,
                                                                            size:
                                                                                12.5)
                                                                        : customText(
                                                                            text: property['room'] ??
                                                                                "ilot: ${property['ilot']}",
                                                                            color:
                                                                                Colors.blue[900],
                                                                            weight: FontWeight.bold,
                                                                            size: 12.5),
                                                                    customText(
                                                                        text: cfaformat.format(property[
                                                                            'cost']),
                                                                        weight: FontWeight
                                                                            .bold,
                                                                        color: Colors.green[
                                                                            900],
                                                                        size:
                                                                            17.0),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        // const SizedBox(height: 5),
                                                      ],
                                                    ),
                                                  )),
                                              // ITEM IMAGE
                                              Expanded(
                                                child: Container(
                                                  width: size.width,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(images
                                                                  .isNotEmpty
                                                              // ? "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"
                                                              ? "$imageUrl/image/${images[0]['image'].toString()}"
                                                              : "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg"),
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: size.width * 0.3,
                                                        color: published
                                                            ? Colors.green[400]
                                                            : Colors.red[400],
                                                        child: Center(
                                                          child: customText(
                                                              text: published
                                                                  ? "Publié"
                                                                  : "En vérification",
                                                              color: Colors
                                                                  .white70,
                                                              size: 13.0,
                                                              weight: FontWeight
                                                                  .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  }),
                    )),
                // BOTTOM
                Positioned(
                    bottom: 0,
                    child: Container(
                        width: size.width,
                        height: size.height * 0.07,
                        padding: EdgeInsets.all(size.height * 0.005),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, -0.5),
                                blurRadius: 5.0,
                              )
                            ]),
                        child: customButtonRadius(
                            context: context,
                            width: size.width * 0.7,
                            height: 20.0,
                            radius: 0.0,
                            color: gold,
                            ontap: () {
                              if (context.read<AuthProvider>().active) {
                                prop.resetProperty();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NewPropertyScreen()));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: customText(
                                      text:
                                          "Votre compte n'est pas encore activé, vous ne pouvez pas ajouter de bien..",
                                      size: 13.0,
                                      color: Colors.white),
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.black,
                                ));
                              }
                            },
                            child: customText(
                                text: "Ajouter un bien +",
                                color: Colors.white,
                                size: 16.0))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
