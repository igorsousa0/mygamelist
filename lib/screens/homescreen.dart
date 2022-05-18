import 'package:flutter/material.dart';
import 'package:mygamelist/Screens/Home/Components/side_menu.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/center/center_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        drawer: SideMenu(
          pageState: 'Home_Page',
        ),
        body: Responsive(
          mobile: SafeArea(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 23),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: CenterScreen(),
            ),
          ])),
          tablet: SafeArea(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 2,
              child: SideMenu(
                pageState: 'Home_Page',
              ),
            ),
            Expanded(
              flex: 6,
              child: CenterScreen(),
            ),
          ])),
          desktop: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: SideMenu(
                pageState: 'Home_Page',
              ),
            ),
            Expanded(
              flex: 5,
              child: CenterScreen(),
            ),
          ]),
        ));
  }
}
