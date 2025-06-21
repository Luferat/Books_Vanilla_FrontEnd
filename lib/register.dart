import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _MyAppState();

}

String parseDate(String birth){
  DateFormat inputFormat = DateFormat("dd/MM/yyyy");
  DateFormat outputFormat = DateFormat("yyyy-MM-dd");

  DateTime dateParse = inputFormat.parse(birth);
  String dateFinal = outputFormat.format(dateParse);
  return dateFinal;
}

class _MyAppState extends State<Register>{
  String _username = '';
  String _email = '';
  String _password = '';
  String _password2 = '';
  String _cpf = '';
  String _tel = '';
  String _address = '';
  String _birth = '';

  String _message = '';


  void setUsername(String username) {
    setState(() {
      _username = username;
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

  void setEmail(String email){
    setState((){
      _email = email;
    });
  }

 void setCpf(String cpf){
    setState(() {
      _cpf = cpf;
    });
 }

 void setTel(String tel){
    setState(() {
      _tel = tel;
    });
 }

 void setAddress(String address){
    setState(() {
      _address = address;
    });
 }

 void setBirth(String birth){
    setState(() {
      _birth = parseDate(birth);
    });
 }


  Future<void> register() async{
    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse('http://192.168.1.3:8080/api/account/create');

    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': _username,
          'email': _email,
          'password': _password,
          'password2': _password2,
          'cpf': _cpf,
          'tel': _tel,
          'address': _address,
          'birth': _birth,
        }),
    );

    setState(() {
      if (response.statusCode == 200) {
        _message = 'Register successful';
      } else {
        final dataMessage = jsonDecode(utf8.decode(response.bodyBytes));
        _message = dataMessage['message'] ?? 'Erro de mensagem';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
         home: RegisterPage(
          setUsername: setUsername,
          setPassword: setPassword,
          setPassword2: setPassword2,
          setEmail: setEmail,
          setCpf: setCpf,
          setTel: setTel,
          setAddress: setAddress,
          setBirth: setBirth,
          register: register,
             message: _message
      ),
    );
  }
}

class RegisterPage extends StatelessWidget{
  final Function(String) setUsername;
  final Function(String) setPassword;
  final Function(String) setPassword2;
  final Function(String) setEmail;
  final Function(String) setCpf;
  final Function(String) setTel;
  final Function(String) setAddress;
  final Function(String) setBirth;
  final Function() register;
  final String message;

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
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        actions: [TextButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }, child: Text("Voltar"))],
      ),

      body: Center(
        child: Padding(padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextField(
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  labelText: 'Your name',
                ),
                onChanged: (value) => setUsername(value)
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                  labelText: 'choice your password'
                ),

                obscureText: true,

                onChanged: (value) => setPassword(value),
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                    labelText: 'rewrite your password'
                ),

                obscureText: true,

                onChanged: (value) => setPassword2(value),
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                    labelText: 'Email'
                ),

                onChanged: (value) => setEmail(value),
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                    labelText: 'Cpf'
                ),

                onChanged: (value) => setCpf(value),
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                    labelText: 'Telefone'
                ),

                onChanged: (value) => setTel(value),
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                    labelText: 'Address'
                ),

                onChanged: (value) => setAddress(value),
              ),

              TextField(
                style: const TextStyle(fontSize: 20),

                decoration: const InputDecoration(
                    labelText: 'Birth'
                ),

                onChanged: (value) => setBirth(value),
              ),

              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => register(),
                child: Text("create account successfully"),),
              if(message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          )
        ),


      ),
      ),
    );
  }


}


