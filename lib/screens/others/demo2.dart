import 'package:flutter/material.dart';

class DemoTwoScreen extends StatefulWidget {
  const DemoTwoScreen({super.key});

  @override
  State<DemoTwoScreen> createState() => _DemoTwoScreenState();
}

class _DemoTwoScreenState extends State<DemoTwoScreen> {
  //
  int _currentview = 0;
  List<Widget> pages = [];
  //

  //
  @override
  void initState() {
    super.initState();
    pages = [page1(), page2()];
  }
  //

  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    //
    return SizedBox(
      height: size.height * 0.7,
      width: size.width,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    _currentview++;
                  });
                },
                child: const Text("Next"),
              )
            ],
          ),
          body: pages[_currentview]),
    );
  }

  // page 1
  Widget page1() {
    return Container(
      child: const Center(
        child: Text("Page 1"),
      ),
    );
  }

  Widget page2() {
    return Container(
      child: const Center(
        child: Text("Page 2"),
      ),
    );
  }
}
