// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/propertyprovider.dart';
import 'package:dexter_mobile/providers/rapportsprovider.dart';
import 'package:dexter_mobile/screens/pages/information.dart';
import 'package:dexter_mobile/screens/pages/rapports/rapports.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyPropertyScreen extends StatefulWidget {
  const MyPropertyScreen({super.key});

  @override
  State<MyPropertyScreen> createState() => _MyPropertyScreenState();
}

class _MyPropertyScreenState extends State<MyPropertyScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  //
  init() async {
    await context.read<PropertyProvider>().loaditem();
  }

  //
  @override
  void initState() {
    super.initState();
    init();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final property = Provider.of<PropertyProvider>(context);

    print(property.selectedcategory['id']);
    final canmodify = property.selectedcategory['id'] != 1
        ? true
        : !property.available
            ? true
            : false;
    //
    // NAME FIELD
    final nameField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          enabled: canmodify,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.nameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.name,
            prefixIcon: const Icon(
              Icons.abc_sharp,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // ADRESS FIELD
    final addressField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          enabled: canmodify,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.addressController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.address,
            prefixIcon: const Icon(
              CupertinoIcons.location_solid,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // GPS FIELD
    final gpsField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.gpsController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Localisation GPS (lien Maps)",
            prefixIcon: Icon(
              CupertinoIcons.location_solid,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // ROOMFIELD
    final roomField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          enabled: canmodify,
          controller: property.roomController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.room,
            prefixIcon: const Icon(
              Icons.numbers_outlined,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // MAXPEOPLE FILED
    final maxpeopleField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.personMaxiController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.personMaxi,
            prefixIcon: const Icon(
              Icons.numbers_outlined,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // CAUTION FIELD
    final cautionField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          enabled: canmodify,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.cautionController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.caution,
            prefixIcon: const Icon(
              Icons.timelapse_sharp,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // ILOT FIELD
    final ilotField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          enabled: canmodify,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.ilotController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.ilot,
            prefixIcon: const Icon(
              FontAwesomeIcons.layerGroup,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // LOT FIELD
    final lotField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          enabled: canmodify,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.lotController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.lot,
            prefixIcon: const Icon(
              CupertinoIcons.square_fill_line_vertical_square,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // AREA FIELD
    final areaField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          enabled: canmodify,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.areaController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.area,
            prefixIcon: const Icon(
              Icons.square,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // COST FIELD
    final costField = SizedBox(
        height: 60,
        width: size.width,
        child: TextFormField(
          // enabled: canmodify,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.costController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: property.item.cost,
            prefixIcon: const Icon(
              FontAwesomeIcons.moneyBill1Wave,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // DESCRIPTION FIELD
    final descriptionField = SizedBox(
        height: 100,
        width: size.width,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 10,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: property.descriptionController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: property.item.description,
            focusColor: Colors.transparent,
            focusedBorder: InputBorder.none,
          ),
        ));
    // LIMIT PERSO DAY FIELD
    // final limitpersodayField = SizedBox(
    //     height: 60,
    //     width: size.width,
    //     child: TextFormField(
    //       textInputAction: TextInputAction.next,
    //       keyboardType: TextInputType.number,
    //       validator: (value) {
    //         if (value!.isEmpty) {
    //           return "Champ requis";
    //         }
    //         return null;
    //       },
    //       controller: property.limitpersodayController,
    //       decoration: InputDecoration(
    //         border: const OutlineInputBorder(
    //             borderSide: BorderSide(width: 1),
    //             borderRadius: BorderRadius.zero),
    //         hintText: property.item.limitpersoday,
    //         prefixIcon: const Icon(
    //           FontAwesomeIcons.userGroup,
    //           size: 20,
    //           color: Colors.grey,
    //         ),
    //         focusColor: Colors.transparent,
    //         focusedBorder: const OutlineInputBorder(
    //             borderSide: BorderSide(width: 2, color: Colors.grey),
    //             borderRadius: BorderRadius.zero),
    //       ),
    //     ));
    //
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Container(
            margin: const EdgeInsets.only(bottom: 0),
            height: 35,
            width: 35,
            child: Image.asset('assets/images/dexter_logo.png',
                fit: BoxFit.cover)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
                child: customButtonRadius(
                    context: context,
                    width: size.width * 0.45,
                    height: 30.0,
                    radius: 10.0,
                    color: gold,
                    ontap: () {
                      context.read<RapportsProvider>().setgoodid(property.id);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const RapportsScreen();
                        },
                      ));
                    },
                    child: customText(
                        text: 'Rapport d\'activités',
                        color: Colors.white,
                        size: 12.5))),
          )
        ],
      ),
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
            child: property.load
                ? Center(child: loader())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // BODY
                        Consumer<PropertyProvider>(
                          builder: (context, property, _) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // AVAILABLE
                                          property.published
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    customText(
                                                        text: "Disponible",
                                                        weight: FontWeight.w600,
                                                        // color: Colors.green,
                                                        size: 16.0),
                                                    CupertinoSwitch(
                                                      activeColor:
                                                          Colors.red[300],
                                                      thumbColor: Colors.white,
                                                      trackColor:
                                                          Colors.green[300],
                                                      value:
                                                          !property.available,
                                                      onChanged: (value) {
                                                        property
                                                            .switchavailable();
                                                        if (property
                                                            .error.isNotEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: customText(
                                                                text:
                                                                    "Un bien vendu ne peut plus être disponible. contacter nous si c'est un cas exceptionel.",
                                                                size: 13.0,
                                                                color: Colors
                                                                    .white),
                                                            showCloseIcon: true,
                                                            closeIconColor:
                                                                Colors.white,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        3500),
                                                            backgroundColor:
                                                                Colors.black,
                                                          ));
                                                        }
                                                      },
                                                    ),
                                                    customText(
                                                        text: "Indisponible",
                                                        weight: FontWeight.w600,
                                                        // color: Colors.red,
                                                        size: 16.0),
                                                  ],
                                                )
                                              : Container(),
                                          const SizedBox(height: 15.0),
                                          property.published
                                              ? customText(
                                                  text:
                                                      "*Note: un bien indisponible ne peut pas être reservé ou visité. Si il est vendu, il ne peut plus être rendu disponible à nouvaeu.*",
                                                  size: 12.0,
                                                  color: Colors.red[300])
                                              : customText(
                                                  text:
                                                      "*Note: votre bien n'est pas encore publié, donc non visible par les utilisiateurs. Les équipes de Dexter procèdent à sa vérification.*",
                                                  size: 12.0,
                                                  color: Colors.red[300]),
                                          const SizedBox(height: 5.0),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    // <-- SEE HERE
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  builder: (context) {
                                                    return const InformationScreen();
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                customText(
                                                    text: "À savoir",
                                                    size: 15.0,
                                                    color: Colors.black54),
                                                const SizedBox(width: 5),
                                                const Icon(
                                                  CupertinoIcons
                                                      .question_circle,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 15.0),
                                          const Divider(),
                                          customText(
                                              text: "Caractéristiques",
                                              color: Colors.grey[800],
                                              size: 17.0,
                                              weight: FontWeight.w700),
                                          const SizedBox(height: 5.0),
                                          customText(
                                              text: "Le bien est destiné à la",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 5.0),
                                          Container(
                                            width: size.width,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  items: property.loctypes.map<
                                                      DropdownMenuItem<
                                                          int>>((element) {
                                                    return DropdownMenuItem<
                                                            int>(
                                                        value: element['id'],
                                                        child: customText(
                                                            text: element[
                                                                'label']));
                                                  }).toList(),
                                                  value:
                                                      property.selectedloctype,
                                                  isExpanded: true,
                                                  onChanged: null),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          customText(
                                              text: "Sa catégorie",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 5.0),
                                          // CATEGORY DROPDOWN
                                          Container(
                                            width: size.width,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<Map>(
                                                items: property.categories
                                                    .map<DropdownMenuItem<Map>>(
                                                        (element) {
                                                  return DropdownMenuItem<Map>(
                                                      value: element,
                                                      child: customText(
                                                          text: element[
                                                              'label']));
                                                }).toList(),
                                                value:
                                                    property.selectedcategory,
                                                isExpanded: true,
                                                onChanged: canmodify
                                                    ? (value) {
                                                        property
                                                            .selectecategory(
                                                                value);
                                                      }
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          // GOOD TITLE
                                          nameField,
                                          const SizedBox(height: 10.0),
                                          // CITY DROPDOWN
                                          Container(
                                            width: size.width,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  hint: customText(
                                                    text: "--Ville--",
                                                  ),
                                                  items: property.cities.map<
                                                      DropdownMenuItem<
                                                          Map>>((element) {
                                                    return DropdownMenuItem<
                                                            Map>(
                                                        value: element,
                                                        child: customText(
                                                            text: element[
                                                                'name']));
                                                  }).toList(),
                                                  value: property.selectedcity,
                                                  isExpanded: true,
                                                  onChanged: canmodify
                                                      ? (value) {
                                                          property.selectecity(
                                                              value);
                                                        }
                                                      : null),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          // MUNICIPALITY DROPDOWN
                                          Container(
                                            width: size.width,
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  hint: customText(
                                                    text: "--Quartier--",
                                                  ),
                                                  items: property.municipalities
                                                      .map<
                                                          DropdownMenuItem<
                                                              int>>((element) {
                                                    return DropdownMenuItem<
                                                            int>(
                                                        value: element['id'],
                                                        child: customText(
                                                            text: element[
                                                                'name']));
                                                  }).toList(),
                                                  value: property
                                                      .selectedmunicipality,
                                                  isExpanded: true,
                                                  onChanged: canmodify
                                                      ? (value) {
                                                          property
                                                              .selectemunicipality(
                                                                  value);
                                                        }
                                                      : null),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          // ADDRESS
                                          addressField,
                                          const SizedBox(height: 10.0),
                                          gpsField,
                                          const SizedBox(height: 10.0),
                                          property.selectedcategory['label'] !=
                                                  'Terrain'
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // TYPE DROPDOWN
                                                    Container(
                                                      width: size.width,
                                                      height: 60,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5)),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                            items: property.types.map<
                                                                    DropdownMenuItem<
                                                                        String>>(
                                                                (element) {
                                                              return DropdownMenuItem<
                                                                      String>(
                                                                  value:
                                                                      element,
                                                                  child: customText(
                                                                      text:
                                                                          element));
                                                            }).toList(),
                                                            value: property
                                                                .selectedtype,
                                                            isExpanded: true,
                                                            onChanged: canmodify
                                                                ? (value) {
                                                                    property
                                                                        .selectetype(
                                                                            value);
                                                                  }
                                                                : null),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    roomField,
                                                    const SizedBox(
                                                        height: 10.0),
                                                    // COMMODITIES
                                                    customText(
                                                        text: "Commodités",
                                                        color: Colors.grey[800],
                                                        weight:
                                                            FontWeight.w500),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    // LIST OF COMODITY
                                                    Column(
                                                      children: property
                                                          .comodites
                                                          .map((element) {
                                                        return Container(
                                                          height: 35,
                                                          width: size.width,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              // ELEMENT NAME
                                                              Container(
                                                                  width:
                                                                      size.width *
                                                                          0.4,
                                                                  height: 35.0,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              0.5)),
                                                                  child: Center(
                                                                    child: customText(
                                                                        text: element[
                                                                            'label']),
                                                                  )),
                                                              // NUMBER
                                                              Container(
                                                                  width:
                                                                      size.width *
                                                                          0.25,
                                                                  height: 35.0,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              0.5)),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child: DropdownButton(
                                                                        value: element['number'],
                                                                        onChanged: (value) {
                                                                          property.updatecomodity(
                                                                              element['comodity_id'],
                                                                              value,
                                                                              false);
                                                                        },
                                                                        items: property.comvalues.map<DropdownMenuItem<int>>((val) => DropdownMenuItem<int>(value: val, child: customText(text: "x${val.toString()}"))).toList()),
                                                                  )),
                                                              // BUTTON
                                                              customButton(
                                                                  context:
                                                                      context,
                                                                  width:
                                                                      size.width *
                                                                          0.25,
                                                                  height: 35.0,
                                                                  ontap:
                                                                      () async {
                                                                    property.updatecomodity(
                                                                        element[
                                                                            'comodity_id'],
                                                                        0,
                                                                        true);
                                                                  },
                                                                  color: Colors
                                                                      .red[700],
                                                                  child:
                                                                      const Icon(
                                                                    CupertinoIcons
                                                                        .delete_solid,
                                                                    size: 20,
                                                                  )),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    // ADD COMODITY
                                                    Container(
                                                      height: 35,
                                                      width: size.width,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          // ELEMENT NAME
                                                          Container(
                                                              width: size
                                                                      .width *
                                                                  0.7,
                                                              height: 35.0,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          0.5)),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton(
                                                                  value: property
                                                                      .selecetedcomodity,
                                                                  onChanged:
                                                                      (value) {
                                                                    property
                                                                        .selectcomodity(
                                                                            value);
                                                                  },
                                                                  items: property
                                                                      .allcomodities
                                                                      .map((element) => DropdownMenuItem(
                                                                          value:
                                                                              element,
                                                                          child:
                                                                              customText(text: element['label'])))
                                                                      .toList(),
                                                                ),
                                                              )),
                                                          // BUTTON
                                                          customButton(
                                                              context: context,
                                                              width:
                                                                  size.width *
                                                                      0.25,
                                                              height: 35.0,
                                                              ontap: () {
                                                                property.addcomodity(
                                                                    property
                                                                        .selecetedcomodity);
                                                              },
                                                              color: Colors
                                                                  .blue[700],
                                                              child: const Icon(
                                                                CupertinoIcons
                                                                    .add_circled,
                                                                size: 20,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                  ],
                                                )
                                              : Container(),
                                          property.selectedcategory['label'] ==
                                                  "Résidence"
                                              ? Column(
                                                  children: [
                                                    maxpeopleField,
                                                    const SizedBox(
                                                        height: 10.0),
                                                  ],
                                                )
                                              : property.selectedcategory[
                                                          'label'] ==
                                                      "Maison"
                                                  ? Column(
                                                      children: [
                                                        cautionField,
                                                        // const SizedBox(
                                                        //     height: 10.0),
                                                        // limitpersodayField,
                                                        const SizedBox(
                                                            height: 10.0),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        areaField,
                                                        const SizedBox(
                                                            height: 10.0),
                                                        ilotField,
                                                        const SizedBox(
                                                            height: 10.0),
                                                        lotField,
                                                        // const SizedBox(
                                                        //     height: 10.0),
                                                        // limitpersodayField,
                                                        const SizedBox(
                                                            height: 10.0),
                                                      ],
                                                    ),
                                          property.selectedcategory['label'] ==
                                                  'Terrain'
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                        height: 10.0),
                                                    customText(
                                                        text:
                                                            "Documents juridiques du bien",
                                                        color: Colors.grey[800],
                                                        weight:
                                                            FontWeight.w500),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                RadioListTile(
                                                                    value:
                                                                        "ACD",
                                                                    activeColor:
                                                                        Colors.blue[
                                                                            800],
                                                                    title: customText(
                                                                        text:
                                                                            "ACD",
                                                                        size:
                                                                            13.0),
                                                                    groupValue:
                                                                        property
                                                                            .documents,
                                                                    onChanged:
                                                                        (value) {
                                                                      property.updatedocuments(
                                                                          value);
                                                                    })),
                                                        Expanded(
                                                            child:
                                                                RadioListTile(
                                                                    value:
                                                                        "ACD en cours",
                                                                    activeColor:
                                                                        Colors.blue[
                                                                            800],
                                                                    title: customText(
                                                                        text:
                                                                            "ACD en cours",
                                                                        size:
                                                                            13.0),
                                                                    groupValue:
                                                                        property
                                                                            .documents,
                                                                    onChanged:
                                                                        (value) {
                                                                      property.updatedocuments(
                                                                          value);
                                                                    }))
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(height: 30.0),
                                          const SizedBox(height: 20.0),
                                          customText(
                                              text: "Prix & Description",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 10.0),
                                          costField,
                                          const SizedBox(height: 10.0),
                                          descriptionField,
                                          customText(
                                              text: "Images du bien",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 10.0),
                                          // FOUR IMAGES REQUIRE
                                          property.images.length < 4
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: customText(
                                                      text:
                                                          "(Vous devez charger au moins quatre(4) images)*",
                                                      color: Colors.red[500],
                                                      size: 13.0,
                                                      weight: FontWeight.w500),
                                                )
                                              : Container(),
                                          // IMAGE LIST
                                          property.images.isEmpty
                                              ? Container()
                                              : Container(
                                                  height: size.height * 0.25,
                                                  width: size.width,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: property.images
                                                        .map<Widget>((element) {
                                                          return Container(
                                                              width: size
                                                                      .width *
                                                                  0.6,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        size.width *
                                                                            0.6,
                                                                    height:
                                                                        size.height *
                                                                            0.2,
                                                                    child: element
                                                                            is XFile
                                                                        ? Image
                                                                            .file(
                                                                            File(element.path),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            // "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg",
                                                                            "$imageUrl/image/${element['image']}",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        size.width *
                                                                            0.6,
                                                                    height: size
                                                                            .height *
                                                                        0.04,
                                                                    color: Colors
                                                                            .red[
                                                                        800],
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        if (element
                                                                            is XFile) {
                                                                          property.updateimages(
                                                                              element,
                                                                              true);
                                                                        } else {
                                                                          if (property.images.length >
                                                                              4) {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return CupertinoAlertDialog(
                                                                                    title: customText(text: "Voulez vous vraiement supprimer l'image ?", weight: FontWeight.bold),
                                                                                    content: customText(text: "Cette action est irreversible."),
                                                                                    actions: <Widget>[
                                                                                      CupertinoDialogAction(
                                                                                        child: const Text("Oui"),
                                                                                        onPressed: () async {
                                                                                          Navigator.pop(context);
                                                                                          await property.removeimage(element['id']);
                                                                                        },
                                                                                      ),
                                                                                      CupertinoDialogAction(
                                                                                        child: const Text("Non"),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                });
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: customText(text: "Suppression impossible. Il faut au moins 04 images dans le cathalogue.", size: 13.0, color: Colors.white),
                                                                              duration: const Duration(milliseconds: 2500),
                                                                              backgroundColor: Colors.black,
                                                                            ));
                                                                          }
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Icon(
                                                                        FontAwesomeIcons
                                                                            .trash,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ));
                                                        })
                                                        .toList()
                                                        .reversed
                                                        .toList(),
                                                  ),
                                                ),
                                          // ADD NEW IMAGE
                                          SizedBox(
                                            height: 35,
                                            width: size.width,
                                            child: customButton(
                                                context: context,
                                                ontap: () async {
                                                  final result =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  if (result != null) {
                                                    property.updateimages(
                                                        result, false);
                                                  }
                                                },
                                                color: Colors.blue[700],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    customText(
                                                        text:
                                                            "Charger une image",
                                                        color: Colors.white),
                                                    const SizedBox(width: 15.0),
                                                    const Icon(
                                                      Icons
                                                          .add_photo_alternate_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(height: 30.0),
                                          const Divider(),
                                          customButton(
                                              context: context,
                                              width: size.width,
                                              height: 60.0,
                                              color: mainBlue,
                                              ontap: () async {
                                                canmodify
                                                    ? await property
                                                        .addproperty(true)
                                                    : await property
                                                        .makerequest();
                                                if (property.error.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: customText(
                                                        text: canmodify
                                                            ? "Modifications appliquées avec succès"
                                                            : "La réquête de modifcation a été envoyée avec succès.",
                                                        size: 13.0,
                                                        color: Colors.white),
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ));
                                                } else {
                                                  debugPrint(property.error);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: customText(
                                                        text:
                                                            "Oups: ${property.error}",
                                                        size: 13.0,
                                                        color: Colors.white),
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  customText(
                                                      text: canmodify
                                                          ? "Appliquer les modifications"
                                                          : "Enoyer la requête",
                                                      color: Colors.white,
                                                      weight: FontWeight.bold,
                                                      size: 17.0),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  property.loadsend
                                                      ? const SpinKitChasingDots(
                                                          size: 12,
                                                          color: Colors.white)
                                                      : const Icon(
                                                          Icons
                                                              .send_and_archive_rounded,
                                                          color: Colors.white,
                                                        )
                                                ],
                                              )),
                                          const SizedBox(height: 25.0),
                                          customText(
                                              text: "Zone dangereuse",
                                              color: Colors.red[800],
                                              weight: FontWeight.w500),

                                          const Divider(),
                                          customButton(
                                              context: context,
                                              width: size.width,
                                              height: 60.0,
                                              color: Colors.red[800],
                                              ontap: () {},
                                              child: customText(
                                                  text: "Supprimer le bien",
                                                  color: Colors.white,
                                                  weight: FontWeight.bold))
                                        ],
                                      ),
                                    )
                                  ]),
                            );
                          },
                        )
                      ],
                    ),
                  )),
      ),
    );
  }
}
