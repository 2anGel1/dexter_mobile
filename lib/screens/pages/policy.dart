import 'package:dexter_mobile/components/widgets.dart';
import 'package:dexter_mobile/providers/searchprovider.dart';
import 'package:dexter_mobile/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyWidget extends StatefulWidget {
  const PolicyWidget({super.key});

  @override
  State<PolicyWidget> createState() => _PolicyWidgetState();
}

class _PolicyWidgetState extends State<PolicyWidget> {
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
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 15,
                    ),
                    // LOCTYPE
                    InkWell(
                      onTap: () async {
                        if (await launchUrl(Uri.parse(Links.policy))) {
                        } else {
                          debugPrint("Impossible d'ouvrir l'url");
                        }
                      },
                      child: Center(
                          child: customText(
                        text: "cliquer pour pour voir nos Politiques ->",
                      )),
                    )
                    // BUTTONS
                  ]),
            ),
          )),
        ],
      ),
    );
  }
}
