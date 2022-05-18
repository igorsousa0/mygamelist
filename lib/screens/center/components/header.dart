import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/responsive.dart';
import 'package:mygamelist/screens/center/center_screen.dart';
import 'package:mygamelist/user.dart';
import 'dart:convert';

class Header extends StatelessWidget {
  final String pageText;
  final String pageState;
  final Function changeState;
  Header({
    required this.pageText,
    required this.pageState,
    required this.changeState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPadding, left: defaultPadding),
            child: Text(pageText,
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.4)),
          ),
          const Spacer(flex: 1),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: SearchField(changeState: changeState),
          )),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: ProfileCard(),
          ),
        ],
      ),
      tablet: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPadding, left: defaultPadding),
            child: Text(pageText, style: Theme.of(context).textTheme.headline6),
          ),
          const Spacer(flex: 1),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: SearchField(changeState: changeState),
          )),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: ProfileCard(),
          ),
        ],
      ),
      desktop: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPadding, left: defaultPadding),
            child: Text(pageText, style: Theme.of(context).textTheme.headline6),
          ),
          const Spacer(flex: 2),
          pageState == 'Home_Page'
              ? Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: SearchField(changeState: changeState),
                ))
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: ProfileCard(),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showLoginDialog(BuildContext context) async {
    if (loginGlobal == false) {
      return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingUser =
              TextEditingController();
          final TextEditingController _textEditingPassword =
              TextEditingController();
          return AlertDialog(
            title: const Center(child: Text('Login')),
            content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: defaultPadding * 0.3),
                    TextFormField(
                      controller: _textEditingUser,
                      decoration: const InputDecoration(labelText: "Usuário"),
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Usuário Obrigatório";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _textEditingPassword,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Senha"),
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Senha Obrigatório";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: defaultPadding * 1.2),
                  ],
                )),
            actions: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      child: const Text("Cadastre-se"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser(
                              _textEditingUser.text, _textEditingPassword.text);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("Acessar"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          consultUser(
                              _textEditingUser.text, _textEditingPassword.text);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(loginTextGlobal)),
            content: Container(
              margin: const EdgeInsets.only(right: defaultPadding),
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              decoration: BoxDecoration(
                  color: textFieldColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.white10)),
              child: InkWell(
                onTap: () {
                  logoutUser();
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.white54,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      child: const Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> showModalDialog(BuildContext context, title, text) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(title)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text(text)),
                  const SizedBox(height: defaultPadding * 1.2),
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
          color: textFieldColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10)),
      child: InkWell(
        onTap: () async {
          await showLoginDialog(context);
        },
        child: Row(
          children: [
            Icon(
              Icons.account_circle_outlined,
              color: Colors.grey,
              size: 30.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            //Image.asset(loginIcon),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(loginTextGlobal),
            )
          ],
        ),
      ),
    );
  }

  void registerUser(user, password) async {
    http.Response response = await http.get(Uri.parse("$api/user/$user/"));
    if (response.statusCode == 200) {
      showModalDialog(context, 'Cadastro', 'Usuário está em uso');
    } else {
      response = await http.post(Uri.parse("$api/users/create/"),
          body: {'username': user, 'password': password});
      if (response.statusCode == 200) {
        showModalDialog(context, 'Cadastro', 'Usuário cadastrado com sucesso!');
      }
    }
  }

  consultUser(user, pass) async {
    http.Response response = await http.get(Uri.parse("$api/user/$user/"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["password"] == pass) {
        setState(() {
          loginTextGlobal = jsonData["username"];
          loginGlobal = true;
        });
      } else {
        showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
      }
    } else {
      showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
    }
  }

  logoutUser() {
    setState(() {
      loginTextGlobal = 'Login';
      loginGlobal = false;
    });
  }
}

class SearchField extends StatefulWidget {
  final Function changeState;
  SearchField({
    required this.changeState,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchQuery = TextEditingController();
  late List<Steam> _list;
  late List<Steam> _searchList;
  final key = GlobalKey<ScaffoldState>();
  late bool _IsSearching;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
  }

  Widget build(BuildContext context) {
    return TextField(
      controller: _searchQuery,
      decoration: InputDecoration(
          hintText: "Search",
          fillColor: textFieldColor,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {
              widget.changeState(_searchQuery.text);
            },
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.70),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: iconSearchColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: InkWell(
                onTap: () {
                  widget.changeState(_searchQuery.text);
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 20.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ), /*Image.asset(
                  searchIcon,
                ),*/
              ),
            ),
          )),
      onSubmitted: (_searchQuery) {
        widget.changeState(_searchQuery);
      },
      textInputAction: TextInputAction.search,
    );
  }
}
