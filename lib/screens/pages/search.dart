import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/providers/searchprovider.dart';
import 'package:dexter_mobile/screens/others/filter.dart';
import 'package:dexter_mobile/screens/pages/detailitem.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, required this.focus});
  bool focus = false;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //
  double filterHeight = 0;
  final bool _upAndDown = false;
  final _searcController = TextEditingController();
  //

  Future<void> loadData() async {
    await context.read<SearchProvider>().search(firsttime: true);
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
    final search = Provider.of<SearchProvider>(context);
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
              // FIXED TOP
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
                      // LOGO
                      Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          height: 35,
                          width: 35,
                          child: Image.asset('assets/images/dexter_logo.png',
                              fit: BoxFit.cover)),
                      // FILTER BUTTO,
                      SizedBox(
                          child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                // <-- SEE HERE
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0),
                                ),
                              ),
                              builder: (context) {
                                return const FilterWidget();
                              });
                        },
                        child: const Icon(
                          FontAwesomeIcons.filter,
                          size: 20,
                          color: Colors.white,
                        ),
                      )),
                      // SEARCH BAR
                      Container(
                        height: 30,
                        width: size.width * 0.6,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextField(
                          onChanged: (value) {
                            search.setname(value);
                          },
                          onSubmitted: (value) {
                            search.search();
                          },
                          controller: _searcController,
                          autofocus: widget.focus,
                          style: textFont(size: 12.0),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Rechercher..",
                            hintStyle: textFont(size: 12.0),
                            contentPadding: const EdgeInsets.only(top: 10.0),
                            prefixIcon: const Icon(
                              Icons.search_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                search.setname("");
                                _searcController.clear();
                                search.search();
                              },
                              child: const Icon(
                                Icons.cancel_sharp,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ),
                            focusColor: Colors.transparent,
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // BODY
              Positioned(
                  top: 70,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: size.height * 0.25),
                    child: search.load
                        ? loader()
                        : search.results.isEmpty
                            ? Center(
                                child:
                                    customText(text: "Pas de données trouvées"),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    thickness: 0.3,
                                    color: Colors.grey,
                                  );
                                },
                                itemCount: search.results.length,
                                itemBuilder: (context, index) {
                                  final property = search.results[index];
                                  final List images = property['photos'] ?? [];
                                  final available =
                                      property['status'] == 'Disponible';
                                  return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<ReservDetailProvider>()
                                            .setitemid(property['id']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DetailItem()));
                                      },
                                      child: SizedBox(
                                        width: size.width * 0.8,
                                        height: size.height * 0.40,
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
                                                                    weight:
                                                                        FontWeight
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
                                                                        property['municipality']
                                                                            [
                                                                            'name'],
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    weight:
                                                                        FontWeight
                                                                            .w800,
                                                                    size: 12.0),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      // SOME SPACE
                                                      SizedBox(
                                                          height: size.height *
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
                                                                      color: Colors
                                                                              .blue[
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
                                                                          color: Colors.blue[
                                                                              900],
                                                                          weight: FontWeight
                                                                              .bold,
                                                                          size:
                                                                              12.5),
                                                                  customText(
                                                                      text: cfaformat.format(
                                                                          property[
                                                                              'cost']),
                                                                      weight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                              .green[
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
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width: size.width * 0.3,
                                                      color: available
                                                          ? Colors.green[400]
                                                          : Colors.red[400],
                                                      child: Center(
                                                        child: customText(
                                                            text: available
                                                                ? "Disponible"
                                                                : "Indisponible",
                                                            color:
                                                                Colors.white70,
                                                            size: 13.0,
                                                            weight: FontWeight
                                                                .w600),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                },
                              ),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
