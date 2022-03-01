import 'package:flutter/material.dart';
import 'package:mygamelist/Screens/Home/Components/side_menu.dart';
import 'package:mygamelist/screens/center/center_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideMenu(),
        body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
          Expanded(
            child: SideMenu(),
          ),
          Expanded(
            flex: 5,
            child: CenterScreen(),
          ),
        ])));
  }
}