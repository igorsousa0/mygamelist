import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'components/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CenterScreen extends StatelessWidget {
  const CenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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

class Contents extends StatefulWidget {
  const Contents({
    Key? key,
  }) : super(key: key);

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  var lenght = 0;
  var jsonDataSteam;
  var jsonDataSteamDetail;
  var listImage = [];
  var steamPrice;
  String jsonSteamImage = '';

  consultaImageSteam(index, appid) async {
    http.Response responseDetail = await http.get(Uri.parse("$apiSteam$appid"));
    final jsonDataDetail = jsonDecode(responseDetail.body);
    final jsonDataImage = jsonDataDetail['$appid']['data']['header_image'];
    final jsonDataPrice =
        jsonDataDetail['$appid']['data']['price_overview']['final_formatted'];
    /*setState(() {
      jsonSteamImage = '$jsonDataImage';
      listImage.add(jsonSteamImage);
      steamPrice = jsonDataPrice;
    });*/
  }

  @override
  void initState() {
    //consultarTamanhoSteam();
    //consultarInfoSteam(2990);
    super.initState();
  }

  /*Future consultarTamanhoSteam() async {
    http.Response response = await http.get(Uri.parse("$api/steam/"));
    final jsonData = jsonDecode(response.body);
    setState(() {
      lenght = jsonData.length;
      jsonDataSteam = jsonData;
    });
    consultaSteam(1);
  }*/

  Future<List<Steam>> consultarTamanhoSteam() async {
    http.Response response = await http.get(Uri.parse("$api/steam/"));
    final jsonData = jsonDecode(response.body);
    List<Steam> steams = [];
    for (var u in jsonData) {
      print(u("appid"));
      /*var SteamAppid = u("appid");
      http.Response responseSteam =
          await http.get(Uri.parse("$apiSteam$SteamAppid"));
      final jsonDataDetail = jsonDecode(responseSteam.body);
      Steam steam = Steam(
        SteamAppid,
        jsonDataDetail['$SteamAppid']['data']['header_image'],
        jsonDataDetail['$SteamAppid']['data']['price_overview']
            ['final_formatted'],
      );*/
      //steams.add(steam);
    }
    //print(steams.length);
    return steams;
    /*setState(() {
      lenght = jsonData.length;
      jsonDataSteam = jsonData;
    });
    consultaSteam(1);*/
  }

  consultaSteam(index) async {
    while (index < lenght) {
      http.Response response = await http.get(Uri.parse("$api/steam/$index"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final appid = jsonData['appid'];
        consultaImageSteam(index, appid);
        index = index + 1;
      }
    }
    print(listImage);
  }

  consultarInfoSteam(appid) async {
    http.Response response = await http.get(Uri.parse("$apiSteam$appid"));
    final jsonData = jsonDecode(response.body);
    setState(() {
      jsonDataSteamDetail = jsonData;
    });
    //print(jsonDataSteamDetail['$appid']['data']['header_image']);
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: FutureBuilder(
            future: consultarTamanhoSteam(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Algum error ocorreu'),
                  );
                } else {
                  return const Center(
                      child: Text(
                    'Rodando',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )); //BuildSteam();
                }
              }
            }),
      );
  }
  Widget BuildSteam() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          const SizedBox(height: defaultPadding),
          GridView.builder(
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: defaultPadding * 2,
              mainAxisSpacing: defaultPadding * 2,
            ),
            itemBuilder: (context, index) => Container(
              child: Column(
                children: [
                  //Image.network(listImage[index]),
                  Text(
                    'Teste',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  /*@override
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
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: lenght,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: defaultPadding * 2,
              mainAxisSpacing: defaultPadding * 2,
            ),
            itemBuilder: (context, index) => Container(
              child: Column(
                children: [
                  Image.network(listImage[index]),
                  Text(
                    jsonDataSteam[index]['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }*/
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
