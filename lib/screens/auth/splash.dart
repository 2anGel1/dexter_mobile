// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/routes/routemanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () async {
        await init();
      },
    );
  }

  init() async {
    // final localstorage = await SharedPreferences.getInstance();
    // localstorage.clear();
    // print("done");
    await context.read<AuthProvider>().loadstate();
    if (context.read<AuthProvider>().connected) {
      await context.read<AuthProvider>().loaduser();
      Navigator.pushReplacementNamed(context, RouteManager.root);
    } else {
      {
        Navigator.pushReplacementNamed(context, RouteManager.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: size.width * 0.5,
            height: size.width * 0.5,
            child: SizedBox(
                child: Image.asset(
              "assets/images/dexter_logo.png",
              fit: BoxFit.cover,
            )),
          ),
        ),
      ),
    );
  }
}
