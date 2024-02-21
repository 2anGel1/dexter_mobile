import 'package:dexter_mobile/screens/pages/home/home.dart';
import 'package:dexter_mobile/screens/pages/profil/profil.dart';
import 'package:dexter_mobile/screens/pages/search.dart';
import 'package:dexter_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  //
  int _cuurentIndex = 0;
  List _pages = [
    HomeScreen(
      search: () {},
    ),
    SearchScreen(focus: true),
    const ProfilScreen()
  ];
  //
  goToSearch() {
    setState(() {
      _pages[1] = SearchScreen(focus: true);
      _cuurentIndex = 1;
    });
  }

  //
  @override
  void initState() {
    super.initState();
    setState(() {
      _pages = [
        HomeScreen(search: () {
          goToSearch();
        }),
        SearchScreen(
          focus: true,
        ),
        const ProfilScreen()
      ];
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_cuurentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          currentIndex: _cuurentIndex,
          selectedItemColor: gold,
          onTap: (value) {
            setState(() {
              _cuurentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: "Acceuil"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search), label: "Recherche"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_fill), label: "Profil")
          ]),
    );
  }
}
