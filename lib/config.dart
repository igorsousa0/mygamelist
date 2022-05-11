import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mygamelist/user.dart';

//Global Variables

//API
const String api = 'http://127.0.0.1:8000';
//const String api = 'https://backend-my-game-list.herokuapp.com';
const String apiSteam =
    'https://mycorssite.herokuapp.com/https://store.steampowered.com/api/appdetails?appids=';
const String apiGOG =
    'https://mycorssite.herokuapp.com/https://api.gog.com/v2/games/';
const String apiGOGPrice =
    'https://mycorssite.herokuapp.com/https://api.gog.com/products/';
const String apiMetacritic =
    'https://mycorssite.herokuapp.com/http://www.metacritic.com/game/pc';

//Colores
var bgColor = const Color.fromARGB(255, 37, 38, 43);
var kTextColor = const Color.fromARGB(255, 56, 56, 56);
var textFieldColor = const Color(0xFF2A2D3E);
var kAppBarColor = const Color.fromARGB(255, 199, 199, 199);
var iconSearchColor = const Color.fromARGB(255, 35, 83, 243);

//Espaçamento
const defaultPadding = 16.0;

//Icones
const homeIcon = 'assets/icons/home.png';
const logo = 'assets/img/logo.png';
const loginIcon = 'assets/icons/login.png';
const steamIcon = 'assets/icons/steam-icon.png';
const searchIcon = 'assets/icons/search.png';
const gogIcon = 'assets/icons/gog_icon.png';

//Paginas
const steam = 'https://store.steampowered.com/app/';
