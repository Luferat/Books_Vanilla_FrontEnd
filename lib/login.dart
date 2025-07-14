import 'dart:convert';
 


 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _dio = Dio();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  String _username = '';
  String _password = '';
  bool _isLoggedIn = false;
  String _errorMessage = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 

  @override
  void initState() {
    super.initState();
    _loadSavedCookie();
  }

  Future<void> _loadSavedCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loged');
    setState(() {
      _isLoggedIn = loggedIn ?? false; // Default to false if null
    });
    print(prefs.getBool('loged'));
    if (_isLoggedIn) {
      print('move');
      Navigator.pushNamed(context, '/profile');
    }
  }

 
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  /*final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
  );*/

  @override
  void initState() {
    super.initState();
    _loadSavedCookie();
  }

  Future<void> _loadSavedCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loged');
    setState(() {
      _isLoggedIn = loggedIn ?? false;
    });

    if (_isLoggedIn) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text(
          'Faça Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration('E-mail'),
                      keyboardType: TextInputType.emailAddress,
                    ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // deslocamento da sombra
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: Center( child: Text('Login', style: TextStyle(color: Colors.white))),
                    decoration: BoxDecoration(color: Colors.black),
                  ),*/
                  const SizedBox(height: 26.0),

                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      fillColor: Colors.white12,
                      filled: true,
                      labelText: 'E-mail:',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email.';
                      }
                      // Validação de e-mail com Regex
                      if (!_emailRegex.hasMatch(value)) {
                        return 'Por favor, insira um email válido.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 26.0),

                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      fillColor: Colors.white12,
                      filled: true,
                      labelText: 'Password:',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha.';
                      }
                      // Validação de e-mail com Regex
                      if (!_passwordRegex.hasMatch(value)) {
                        return 'Por favor, digite uma senha válida.';
                      }
                      return null;
                    },
                  ),
 

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(fontSize: 18),
                      decoration: _inputDecoration('Senha'),
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),

                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _processLogin,
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 30),

                    InkWell(
                      child: const Text(
                        'Esqueci a senha',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/'),
                    ),

                    const SizedBox(height: 20),

                    const Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        'Criar conta',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.8),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _processLogin() async {
 
    setState(() {
      _username = _usernameController.text.trim();
      _password = _passwordController.text;
      _errorMessage = '';
    });

    if (!_emailRegex.hasMatch(_username)) {
      setState(() => _errorMessage = 'Email inválido.');
      return;
    }

    /*if (!_passwordRegex.hasMatch(_password)) {
      setState(() => _errorMessage =
      'Senha deve conter pelo menos 8 caracteres, uma letra maiúscula e um número.');
      return;
    }*/

    try {
      final Response response = await _dio.post(
        'http://10.144.31.70:8080/api/account/login',
        data: {'email': _username, 'password': _password},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username);
        await prefs.setBool('loged', true);

        setState(() {
          _isLoggedIn = true;
        });

        if (!mounted) return;
        Navigator.pushNamed(context, '/profile');
      } else {
        setState(() => _errorMessage = 'Usuário ou senha incorretos.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro ao conectar. Tente novamente.');
      if (kDebugMode) print('Erro: $e');

    await Future.delayed(const Duration(seconds: 1));
    // Create the request body
    /*      final body = json.encode({'email': _username, 'password': _password});

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
          'Accept': 'application/json',
        },
        body: body,
      );*/

    setState(() {
      _username =
          _usernameController.text; // Get the username from the controller
      _password =
          _passwordController.text; // Get the password from the controller
    });

    final url = Uri.parse('http://10.144.31.70:8080/api/account/login');
    final body = json.encode({"email": _username, 'password': _password});
    // Envia a requisição POST com Dio de forma assíncrona
    final Response response = await _dio.post(
      'http://10.144.31.70:8080/api/account/login',
      data: {'email': _username, 'password': _password},
      // O Dio converte automaticamente o Map para JSON
      options: Options(
        // Define o Content-Type como JSON
        contentType: Headers.jsonContentType,
      ),
    );

    // Get the cookies from the response headers
    String? cookie = _username;

    if (response.statusCode == 200) {
      // Print all response headers for debugging
      //print('Response headers: ${response.headers}');

      // Save the cookie using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', cookie);
      await prefs.setBool('loged', true);

      setState(() {
        _isLoggedIn = true;
        _errorMessage = '';
        if (kDebugMode) {
          print('Login successful');
        }
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _errorMessage = 'Invalid username or password';
        if (kDebugMode) {
          print('Não logou');
        }
      });
    }

    if (_isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/profile');
 
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
