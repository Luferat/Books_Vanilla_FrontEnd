
import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

String parseDate(String birth) {
  DateFormat inputFormat = DateFormat("dd/MM/yyyy");
  DateFormat outputFormat = DateFormat("yyyy-MM-dd");

  DateTime dateParse = inputFormat.parse(birth);
  String dateFinal = outputFormat.format(dateParse);
  return dateFinal;
}

class _Register extends State<Register> {
  String _username = '';
  String _email = '';
  String _password = '';
  String _password2 = '';
  String _cpf = '';
  String _tel = '';
  String _address = '';
  String _birth = '';

  String _errorMessage = '';

  void setUsername(String username) {
    setState(() {
      _username = username;
      print('nonono');
    });
  }

  void setPassword(String password) {
    setState(() {
      _password = password;
    });
  }

  void setPassword2(String password2) {
    setState(() {
      _password2 = password2;
    });
  }

  void setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void setCpf(String cpf) {
    setState(() {
      _cpf = cpf;
    });
  }

  void setTel(String tel) {
    setState(() {
      _tel = tel;
    });
  }

  void setAddress(String address) {
    setState(() {
      _address = address;
    });
  }

  void setBirth(String birth) {
    setState(() {
      _birth = parseDate(birth);
    });
  }

  Future<void> sendRegister() async {
    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse('http://10.144.31.70:8080/api/account/create');

    final body = json.encode({
      'name': _username,
      'email': _email,
      'password': _password,
      'password2': _password2,
      'cpf': _cpf,
      'tel': _tel,
      'address': _address,
      'birth': _birth,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
        'Accept': 'application/json',
      },
      body: body,
    );

    setState(() {
      if (response.statusCode == 200) {
        _errorMessage = '';
        print('Register successful: ${response.body}');
      } else {
        _errorMessage = 'Invalid field';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // DO NOT return a new MaterialApp here.
    // Instead, directly return the widget that represents your Register screen.
    return RegisterPage(
      setUsername: setUsername,
      setPassword: setPassword,
      setPassword2: setPassword2,
      setEmail: setEmail,
      setCpf: setCpf,
      setTel: setTel,
      setAddress: setAddress,
      setBirth: setBirth,
      register: sendRegister,
      errorMessage: _errorMessage,
    );
  }
}

class RegisterPage extends StatelessWidget {
  final Function(String) setUsername;
  final Function(String) setPassword;
  final Function(String) setPassword2;
  final Function(String) setEmail;
  final Function(String) setCpf;
  final Function(String) setTel;
  final Function(String) setAddress;
  final Function(String) setBirth;
  final Function() register;
  final String errorMessage;

  const RegisterPage({
    super.key,
    required this.setUsername,
    required this.setPassword,
    required this.setPassword2,
    required this.setEmail,
    required this.setCpf,
    required this.setTel,
    required this.setAddress,
    required this.setBirth,
    required this.register,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,

        leading: IconButton(
          iconSize: 30.0,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/',
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Cadastrar livro'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/register-book'); // Usar pushNamed para ir para /test
              },
            ),

          ],
        ),
      ),



      body: SingleChildScrollView( child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 350, maxHeight: 700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setUsername(value),
                  ),

                  const SizedBox(height: 16.0),

                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),

                    obscureText: true,

                    onChanged: (value) => setPassword(value),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(
                      labelText: 'Repita a senha',
                      border: OutlineInputBorder(),
                    ),

                    obscureText: true,

                    onChanged: (value) => setPassword2(value),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(labelText: 'Email',
                      border: OutlineInputBorder(),),

                    onChanged: (value) => setEmail(value),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(labelText: 'Cpf',
                      border: OutlineInputBorder(),),

                    onChanged: (value) => setCpf(value),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(labelText: 'Telefone',
                      border: OutlineInputBorder(),),

                    onChanged: (value) => setTel(value),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(labelText: 'Address',
                      border: OutlineInputBorder(),),

                    onChanged: (value) => setAddress(value),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),

                    decoration: const InputDecoration(labelText: 'Birth',
                      border: OutlineInputBorder(),),

                    onChanged: (value) => setBirth(value),
                  ),
                  const SizedBox(height: 36.0),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black
                    ),
                    onPressed: () => register(),
                    child: const Text("Cadastrar"),
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),);
  }
}
