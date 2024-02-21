// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/propertyprovider.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPropertyScreen extends StatefulWidget {
  const NewPropertyScreen({super.key});

  @override
  State<NewPropertyScreen> createState() => _NewPropertyScreenState();
}

class _NewPropertyScreenState extends State<NewPropertyScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  //
  init() async {
    await context.read<PropertyProvider>().init();
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
    final properte = Provider.of<PropertyProvider>(context);
    //
    // NAME FIELD
    final nameField = SizedBox(
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
          controller: properte.nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Nom du bien (Ex: Résidence Havila)",
            prefixIcon: Icon(
              Icons.abc_sharp,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // ADRESS FIELD
    final addressField = SizedBox(
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
          controller: properte.addressController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Plus de précision..",
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
          controller: properte.gpsController,
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
          controller: properte.roomController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Nombre de pièces..(Ex: 4)",
            prefixIcon: Icon(
              Icons.numbers_outlined,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
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
          controller: properte.personMaxiController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Nbr de personne maxi..(Ex: 5)",
            prefixIcon: Icon(
              Icons.group,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
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
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis";
            }
            return null;
          },
          controller: properte.cautionController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Nbre mois de caution..(Ex: 3)",
            prefixIcon: Icon(
              Icons.timelapse_sharp,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // ILOT FIELD
    final ilotField = SizedBox(
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
          controller: properte.ilotController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Ilot..(Ex: 3)",
            prefixIcon: Icon(
              FontAwesomeIcons.layerGroup,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // LOT FIELD
    final lotField = SizedBox(
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
          controller: properte.lotController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Lot;;(Ex: 1)",
            prefixIcon: Icon(
              CupertinoIcons.square_fill_line_vertical_square,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // AREA FIELD
    final areaField = SizedBox(
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
          controller: properte.areaController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: "Superficie en m2..(Ex: 500)",
            prefixIcon: Icon(
              Icons.square,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.zero),
          ),
        ));
    // COST FIELD
    final costField = SizedBox(
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
          controller: properte.costController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.zero),
            hintText: 'Prix en FCFA..(Ex: 150000)',
            prefixIcon: Icon(
              FontAwesomeIcons.moneyBill1Wave,
              size: 20,
              color: Colors.grey,
            ),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
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
          controller: properte.descriptionController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Ajouter une description..",
            focusColor: Colors.transparent,
            focusedBorder: InputBorder.none,
          ),
        )); //
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              properte.getdata();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: InkWell(
            onTap: () {
              properte.init();
            },
            child: Container(
                margin: const EdgeInsets.only(bottom: 0),
                height: 35,
                width: 35,
                child: Image.asset('assets/images/dexter_logo.png',
                    fit: BoxFit.cover)),
          )),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // BODY
                  Consumer<PropertyProvider>(
                    builder: (context, properte, _) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      style: textFont(size: 13.5),
                                      children: const [
                                    TextSpan(
                                        text: "Ajouter un ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextSpan(
                                        text: "bien\n",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: gold)),
                                    TextSpan(
                                        text:
                                            "Sur Dexter, une fois votre bien ajouté, il est soumis à une vérification par notre équipe. Une fois la vérifiacation du bien faite, il est immédiatement visible par tous les utilisateurs de Dexter. N'est-ce pas un process rapide ?")
                                  ])),
                              const SizedBox(height: 25.0),
                              properte.load
                                  ? Center(
                                      child: loader(),
                                    )
                                  : Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                  items: properte.loctypes.map<
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
                                                      properte.selectedloctype,
                                                  isExpanded: true,
                                                  onChanged: (newValue) {
                                                    properte.selecteloctype(
                                                        newValue);
                                                  }),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          customText(
                                              text:
                                                  "Quel bien voulez vous ajouter ?",
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
                                              child: DropdownButton(
                                                  items: properte.categories
                                                      .map<
                                                          DropdownMenuItem<
                                                              Map>>((element) {
                                                    return DropdownMenuItem<
                                                            Map>(
                                                        value: element,
                                                        child: customText(
                                                            text: element[
                                                                'label']));
                                                  }).toList(),
                                                  value:
                                                      properte.selectedcategory,
                                                  isExpanded: true,
                                                  onChanged: (newValue) {
                                                    properte.selectecategory(
                                                        newValue);
                                                  }),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          // GOOD TITLE
                                          nameField,
                                          const SizedBox(height: 20.0),
                                          customText(
                                              text: "Emplacement du bien",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 5.0),
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
                                                  items: properte.cities.map<
                                                      DropdownMenuItem<
                                                          Map>>((element) {
                                                    return DropdownMenuItem<
                                                            Map>(
                                                        value: element,
                                                        child: customText(
                                                            text: element[
                                                                'name']));
                                                  }).toList(),
                                                  value: properte.selectedcity,
                                                  isExpanded: true,
                                                  onChanged: (newValue) {
                                                    properte
                                                        .selectecity(newValue);
                                                  }),
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
                                                  items: properte.municipalities
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
                                                  value: properte
                                                      .selectedmunicipality,
                                                  isExpanded: true,
                                                  onChanged: (newValue) {
                                                    properte
                                                        .selectemunicipality(
                                                            newValue);
                                                  }),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          // ADDRESS
                                          addressField,
                                          const SizedBox(height: 10.0),
                                          gpsField,
                                          const SizedBox(height: 20.0),
                                          customText(
                                              text: "Caractérisques du bien",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 10.0),
                                          properte.selectedcategory['label'] !=
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
                                                            items: properte.types.map<
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
                                                            value: properte
                                                                .selectedtype,
                                                            isExpanded: true,
                                                            onChanged:
                                                                (newValue) {
                                                              properte
                                                                  .selectetype(
                                                                      newValue);
                                                            }),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    roomField,
                                                    const SizedBox(
                                                        height: 10.0),
                                                    customText(
                                                        text: "Commodités",
                                                        color: Colors.grey[800],
                                                        weight:
                                                            FontWeight.w500),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    // LIST OF COMODITY
                                                    Column(
                                                      children: properte
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
                                                                          properte.updatecomodity(
                                                                              element['comodity_id'],
                                                                              value,
                                                                              false);
                                                                        },
                                                                        items: properte.comvalues.map<DropdownMenuItem<int>>((val) => DropdownMenuItem<int>(value: val, child: customText(text: "x${val.toString()}"))).toList()),
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
                                                                    properte.updatecomodity(
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
                                                                  value: properte
                                                                      .selecetedcomodity,
                                                                  onChanged:
                                                                      (value) {
                                                                    properte
                                                                        .selectcomodity(
                                                                            value);
                                                                  },
                                                                  items: properte
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
                                                                properte.addcomodity(
                                                                    properte
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
                                          properte.selectedcategory['label'] ==
                                                  "Résidence"
                                              ? Column(
                                                  children: [
                                                    maxpeopleField,
                                                    const SizedBox(
                                                        height: 10.0),
                                                  ],
                                                )
                                              : properte.selectedcategory[
                                                          'label'] ==
                                                      "Maison"
                                                  ? Column(
                                                      children: [
                                                        cautionField,
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
                                                        const SizedBox(
                                                            height: 10.0),
                                                      ],
                                                    ),
                                          const SizedBox(height: 20.0),
                                          customText(
                                              text: "Prix & Description",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          const SizedBox(height: 10.0),
                                          costField,
                                          const SizedBox(height: 10.0),
                                          descriptionField,
                                          properte.selectedcategory['label'] ==
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
                                                                        properte
                                                                            .documents,
                                                                    onChanged:
                                                                        (value) {
                                                                      properte.updatedocuments(
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
                                                                        properte
                                                                            .documents,
                                                                    onChanged:
                                                                        (value) {
                                                                      properte.updatedocuments(
                                                                          value);
                                                                    }))
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          const SizedBox(height: 30.0),
                                          customText(
                                              text: "Images du bien",
                                              color: Colors.grey[800],
                                              weight: FontWeight.w500),
                                          // FOUR IMAGES REQUIRE
                                          properte.images.length < 4
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
                                          properte.images.isEmpty
                                              ? Container()
                                              : Container(
                                                  height: size.height * 0.2,
                                                  width: size.width,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: properte.images
                                                        .map<Widget>((element) {
                                                      return InkWell(
                                                        onTap: () {
                                                          properte.updateimages(
                                                              element, true);
                                                        },
                                                        child: Container(
                                                          width:
                                                              size.width * 0.4,
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Image.file(
                                                            File(element.path),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
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
                                                    properte.updateimages(
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
                                                    )
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(height: 20.0),
                                          const Divider(),
                                          customButton(
                                              context: context,
                                              width: size.width,
                                              height: 60.0,
                                              color: mainBlue,
                                              ontap: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  if (properte.images.length <
                                                      4) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: customText(
                                                          text:
                                                              "Il faut au moins 4 images dans le catalogue du bien",
                                                          size: 13.0,
                                                          color: Colors.white),
                                                      showCloseIcon: true,
                                                      closeIconColor:
                                                          Colors.white,
                                                      duration: const Duration(
                                                          milliseconds: 2500),
                                                      backgroundColor:
                                                          Colors.black,
                                                    ));
                                                  } else {
                                                    await properte
                                                        .addproperty(false);
                                                    if (properte
                                                        .error.isEmpty) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return CupertinoAlertDialog(
                                                              title: const Text(
                                                                  "Votre bien a été ajouté avec succès !"),
                                                              content: customText(
                                                                  text:
                                                                      "Votre bien est maintenant en cours de vérification et sera visible par les utilisateurs une fois validé par Dexter. Merci pour votre confiance !"),
                                                              actions: <Widget>[
                                                                CupertinoDialogAction(
                                                                  child:
                                                                      const Text(
                                                                          "Ok"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      debugPrint(
                                                          properte.error);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: customText(
                                                            text:
                                                                properte.error,
                                                            size: 13.0,
                                                            color:
                                                                Colors.white),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2000),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ));
                                                    }
                                                  }
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  customText(
                                                      text: "Envoyer",
                                                      color: Colors.white,
                                                      weight: FontWeight.bold,
                                                      size: 17.0),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  properte.loadsend
                                                      ? const SpinKitChasingDots(
                                                          size: 12,
                                                          color: Colors.white)
                                                      : const Icon(Icons
                                                          .send_and_archive_outlined)
                                                ],
                                              ))
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
    ));
  }
}
