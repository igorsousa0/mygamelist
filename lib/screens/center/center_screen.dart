import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/screens/detail_screen.dart';
import 'components/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CenterScreen extends StatelessWidget {
  const CenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(right: defaultPadding),
              child: Header(),
            ),
            //Login(),
            SizedBox(height: defaultPadding),
            Expanded(
              child: Contents(),
            ),
            ControlPage(),
          ],
        ),
      ),
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
  var Steamlenght;
  static var jsonDataSteam;
  static var jsonDataGOG;
  static var gogUrls = [];
  var jsonDataSteamDetail;
  static var steamImages = [];
  static var steamAppids = [];
  static var gogAppids = [];
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
    http.Response responseApiSteam = await http.get(Uri.parse("$api/steam/"));
    var jsonDataApiSteam = jsonDecode(responseApiSteam.body);
    jsonDataSteam = jsonDataApiSteam;
    http.Response responseApiGOG = await http.get(Uri.parse("$api/gog/"));
    var jsonDataApiGOG = jsonDecode(responseApiGOG.body);
    jsonDataGOG = jsonDataApiGOG;
    /*setState(() {
      lenght = jsonData.length;
      jsonDataSteam = jsonData;
    });*/
    Steamlenght = jsonDataApiSteam.length;
    List<Steam> steams = [];
    List<String> steamDetail;
    for (var i in jsonDataApiSteam) {
      //print(i["appid"]);
      var SteamAppid = i["appid"];
      //print(SteamAppid);
      http.Response responseSteam =
          await http.get(Uri.parse("$apiSteam$SteamAppid&cc=BR"));   
      final jsonDataDetail = jsonDecode(responseSteam.body);
      var steamImage = jsonDataDetail["$SteamAppid"]["data"]["header_image"];
      steamImages.add(steamImage);
      steamAppids.add(SteamAppid);
      /*Steam steam = Steam(
        SteamAppid,
        steamImage,
        steamPrice,
      );*/
      /*setState(() {
        steamImages.add(steamImage);
      });*/
    }
    for (var i in jsonDataApiGOG) {
      var gogAppid = i["appid"];
      gogAppids.add(gogAppid);
      //http.Response responseGOGPrice = await http.get(Uri.parse("$apiGOGPrice$gogAppid/prices?countryCode=BR"));
      //final jsonDataPriceGOG = jsonDecode(responseGOGPrice.body);
      //print(jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"]);
      //var gogPrice = jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"];
      //gogPrices.add(gogPrice);
      //print(jsonDataPriceGOG["_embedded"]["prices"]["finalPrice"]);
    }
    return steams;
    /*setState(() {
      lenght = jsonData.length;
      jsonDataSteam = jsonData;
    });
    consultaSteam(1);*/
  }

  /*consultaSteam(index) async {
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
  }*/

  consultarInfoSteam(appid) async {
    http.Response response = await http.get(Uri.parse("$apiSteam$appid"));
    final jsonData = jsonDecode(response.body);
    setState(() {
      jsonDataSteamDetail = jsonData;
    });
    //print(jsonDataSteamDetail['$appid']['data']['header_image']);
  }

  /*_navigationWithText(BuildContext context, index) {
    final result = Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DetailScreen(game: Steamlenght[index])),
  );
    print(context);
  }*/

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
                return ItemCard();
              }
            }
          }),
    );
  }

  Widget ItemCard() {
    return Container(
      padding: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: PageView(
        children: [
          Column(
            children: [
              const SizedBox(height: defaultPadding),
              Expanded(
                child: GridView.builder(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemCount: Steamlenght,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: defaultPadding * 2,
                    mainAxisSpacing: defaultPadding,
                  ),
                  itemBuilder: (context, index) => Container(
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      indexGame: jsonDataSteam[index],
                                      nameGame: jsonDataSteam[index]["name"],
                                      steamAppid: steamAppids[index],
                                      gogAppid: gogAppids[index],
                                    ),
                                  ),
                                ),
                            child: Image.network(steamImages[index])),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: defaultPadding / 2),
                          child: Text(
                            jsonDataSteam[index]["name"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
