import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _dio = Dio();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  String _errorMessage = '';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loged') ?? false;

    if (loggedIn) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  Future<void> _processLogin() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _errorMessage = '';
    });

    if (!_emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = 'Email inválido.');
      return;
    }

    if (password.isEmpty) {
      setState(() => _errorMessage = 'A senha não pode estar vazia.');
      return;
    }

    try {
      final response = await _dio.post(
        'http://10.144.31.70:8080/api/account/login',
        data: {'email': email, 'password': password},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', email);
        await prefs.setBool('loged', true);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      } else {
        setState(() => _errorMessage = 'Usuário ou senha incorretos.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro ao conectar. Tente novamente.');
      if (kDebugMode) print('Erro: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.8),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text('Faça Login', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24.0),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(fontSize: 18),
                    decoration: _inputDecoration('E-mail'),
                    keyboardType: TextInputType.emailAddress,
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
                    Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _processLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/'),
                    child: const Text('Esqueci a senha', style: TextStyle(color: Colors.lightBlueAccent)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Criar conta', style: TextStyle(color: Colors.lightBlueAccent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
