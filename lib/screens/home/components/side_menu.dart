import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/homescreen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Stack(
                children: <Widget>[
                  Align(
                    child: Image.asset(logo, color: Colors.white),
                  ),
                  const Align(
                    alignment: Alignment(0, 0.9),
                    child: Text('MyGameList', style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ),
            DrawListTile(
                title: "Pagina Inicial",
                press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    ),
                pngSrc: homeIcon),
            //DrawListTile(title: "Login", press: () {}),
          ],
        ),
      ),
      tablet: SideMenuDraw(),
      desktop: SideMenuDraw(),
    );
  }

  Drawer SideMenuDraw() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Stack(
              children: <Widget>[
                Align(
                  child: Image.asset(logo, color: Colors.white),
                ),
                const Align(
                  alignment: Alignment(0, 0.9),
                  child: Text('MyGameList', style: TextStyle(fontSize: 18)),
                )
              ],
            ),
          ),
          DrawListTile(title: "Pagina Inicial", press: () {}, pngSrc: homeIcon),
          //DrawListTile(title: "Login", press: () {}),
        ],
      ),
    );
  }
}

class DrawListTile extends StatelessWidget {
  const DrawListTile({
    Key? key,
    required this.title,
    required this.pngSrc,
    required this.press,
  }) : super(key: key);

  final String title, pngSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Image.asset(
          pngSrc,
          color: Colors.white54,
          height: 18,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white54),
        ));
  }
}
