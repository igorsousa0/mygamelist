import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/user.dart';
import 'dart:convert';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Pagina Inicial', style: Theme.of(context).textTheme.headline6),
        const Spacer(flex: 2),
        const FilterField(),
        const Expanded(child: SearchField()),
        const ProfileCard(),
      ],
    );
  }
}

class FilterField extends StatelessWidget {
  const FilterField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
          color: textFieldColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10)),
      child: Row(
        children: const [
          Icon(
            Icons.filter_alt_outlined,
            color: Colors.white54,
            size: 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text('Filter'),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  var loginText = 'Login';
  var login = false;
  List<User> users = [];

  @override
  void initState() {
    _retrieveUser();
    super.initState();
  }

  _retrieveUser() async {
    users = [];
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body);
      data.forEach((user) {
        users.add(User.fromMap(user));
      });
    } catch (e) {
      print('Error is $e');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showLoginDialog(BuildContext context) async {
    if (login == false) {
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
            title: Center(child: Text(loginText)),
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
            Image.asset(loginIcon),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text('$loginText'),
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
    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonData["password"] == pass) {
      setState(() {
        loginText = jsonData["username"];
        login = true;
      });
      return '';
    } else {
      showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
    }
  }

  logoutUser() {
    setState(() {
      loginText = 'Login';
      login = false;
    });
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: "Search",
          fillColor: textFieldColor,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: iconSearchColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Image.asset(
                searchIcon,
              ),
            ),
          )),
    );
  }
}
