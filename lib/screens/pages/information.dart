import 'package:dexter_mobile/providers/searchprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final search = Provider.of<SearchProvider>(context);

    return SizedBox(
      // width: size.width,
      height: size.height * 0.9,
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
            child: const SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Divider(),
                     SizedBox(
                      height: 15,
                    ),
                    // LOCTYPE
                    
                    // BUTTONS
                  ]),
            ),
          )),
        ],
      ),
    );
  }
}
