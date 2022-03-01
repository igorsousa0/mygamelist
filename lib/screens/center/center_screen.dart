import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'components/header.dart';

class CenterScreen extends StatelessWidget {
  const CenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: defaultPadding),
                child: Header(),
              ),
              //Login(),
              SizedBox(height: defaultPadding),
              Contents(),
              ControlPage(),
            ],
          )),
    );
  }
}

class Contents extends StatelessWidget {
  const Contents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          const SizedBox(height: defaultPadding),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: defaultPadding * 2,
              mainAxisSpacing: defaultPadding * 2,
            ),
            itemBuilder: (context, index) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage(steamIcon)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ControlPage extends StatelessWidget {
  const ControlPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Spacer(),
            Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white54,
              size: 24.0,
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white54,
              size: 24.0,
            ),
          ],
        )
      ],
    );
  }
}
