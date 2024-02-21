import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/searchprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final search = Provider.of<SearchProvider>(context);

    return SizedBox(
      // width: size.width,
      height: size.height * 0.8,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Center(
              child: Container(
                width: 70,
                height: 7,
                decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Positioned(
              child: Container(
            width: size.width,
            height: size.height,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 15,
                    ),
                    // LOCTYPE
                    // customText(text: "Destination"),
                    const SizedBox(height: 5.0),
                    Container(
                      height: size.height * 0.06,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: search.loctypes.length,
                          separatorBuilder: ((context, index) {
                            return const SizedBox(width: 8.0);
                          }),
                          itemBuilder: (context, index) {
                            final loctype = search.loctypes[index];
                            final selected =
                                search.filter['type_id'] == loctype['label'];
                            return InkWell(
                              onTap: () {
                                if (selected) {
                                  search.selectloctype("");
                                } else {
                                  search.selectloctype(loctype['label']);
                                }
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.grey[400]
                                        : Colors.grey[100],
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey[900]!)),
                                child: Center(
                                  child: customText(
                                      text: loctype['label'],
                                      weight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      size: 13.0),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20.0),
                    // CATEGORIES
                    customText(text: "Catégories"),
                    const SizedBox(height: 5.0),
                    Container(
                      height: size.height * 0.06,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: search.categories.length,
                          separatorBuilder: ((context, index) {
                            return const SizedBox(width: 8.0);
                          }),
                          itemBuilder: (context, index) {
                            final category = search.categories[index];
                            final selected = search.filter['category_id'] ==
                                category['label'];
                            return InkWell(
                              onTap: () {
                                if (selected) {
                                  search.selectcategory("");
                                } else {
                                  search.selectcategory(category['label']);
                                }
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.grey[400]
                                        : Colors.grey[100],
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey[900]!)),
                                child: Center(
                                  child: customText(
                                      text: category['label'],
                                      weight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      size: 13.0),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20.0),
                    // TYPE
                    customText(text: "Type"),
                    const SizedBox(height: 5.0),
                    Container(
                      height: size.height * 0.06,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: search.types.length,
                          separatorBuilder: ((context, index) {
                            return const SizedBox(width: 8.0);
                          }),
                          itemBuilder: (context, index) {
                            final type = search.types[index];
                            final selected = search.filter['type'] == type;
                            return InkWell(
                              onTap: () {
                                if (selected) {
                                  search.selecttype("");
                                } else {
                                  search.selecttype(type);
                                }
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.grey[400]
                                        : Colors.grey[100],
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey[900]!)),
                                child: Center(
                                  child: customText(
                                      text: type,
                                      weight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      size: 13.0),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20.0),
                    // VILLES
                    customText(text: "Villes"),
                    const SizedBox(height: 5.0),
                    Container(
                      height: size.height * 0.06,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: search.cities.length,
                          separatorBuilder: ((context, index) {
                            return const SizedBox(width: 8.0);
                          }),
                          itemBuilder: (context, index) {
                            final city = search.cities[index];
                            final selected =
                                search.filter['city_id'] == city['name'];
                            return InkWell(
                              onTap: () {
                                if (selected) {
                                  search.selectcity("");
                                } else {
                                  search.selectcity(city['name']);
                                }
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.grey[400]
                                        : Colors.grey[100],
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey[900]!)),
                                child: Center(
                                  child: customText(
                                      text: city['name'],
                                      weight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      size: 13.0),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20.0),
                    // COMMUNES
                    customText(text: "Communes"),
                    const SizedBox(height: 5.0),
                    Container(
                      height: size.height * 0.06,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: search.municipalities.length,
                          separatorBuilder: ((context, index) {
                            return const SizedBox(width: 8.0);
                          }),
                          itemBuilder: (context, index) {
                            final municipality = search.municipalities[index];
                            final selected = search.filter['municipality_id'] ==
                                municipality['name'];
                            return InkWell(
                              onTap: () {
                                if (selected) {
                                  search.selectmunicipality("");
                                } else {
                                  search
                                      .selectmunicipality(municipality['name']);
                                }
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.grey[400]
                                        : Colors.grey[100],
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey[900]!)),
                                child: Center(
                                  child: customText(
                                      text: municipality['name'],
                                      weight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      size: 13.0),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20.0),
                    // PRIX
                    customText(text: "Prix"),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        customText(
                          text:
                              "${cfaformat.format(search.rangeamount.start.round())} - ${cfaformat.format(search.rangeamount.end)}",
                        )
                      ],
                    ),
                    SfRangeSlider(
                      values: search.rangeamount,
                      min: 1000.0,
                      max: 1000000.0,
                      interval: 1000,
                      activeColor: mainBlue,
                      onChanged: (value) {
                        search.updaterangeamount(value);
                      },
                    ),
                    SizedBox(height: size.height * 0.08),
                    // BUTTONS
                  ]),
            ),
          )),
          Positioned(
              bottom: 0,
              child: Container(
                  width: size.width,
                  height: size.height * 0.1,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, -1),
                            blurRadius: 5,
                            color: Colors.grey)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      customButtonRadius(
                          context: context,
                          width: size.width * 0.4,
                          color: mainBlue,
                          radius: 50.0,
                          ontap: () async {
                            search.search(fromfilter: true);
                            Navigator.pop(context);
                          },
                          child: customText(
                              text: "Rechercher", color: Colors.white)),
                      customButtonRadius(
                          context: context,
                          width: size.width * 0.4,
                          color: gold,
                          radius: 50.0,
                          ontap: () async {
                            await search.resetfilter();
                          },
                          child: customText(
                              text: "Remise à zéro", color: Colors.white))
                    ],
                  )))
        ],
      ),
    );
  }
}
