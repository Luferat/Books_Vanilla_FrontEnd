
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RegisterBook extends StatefulWidget {
  const RegisterBook({super.key});

  @override
  State<RegisterBook> createState() => _RegisterBookState();
}

class _RegisterBookState extends State<RegisterBook> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _releaseDateController = TextEditingController();

  List<String> _selectedCategories = [];
  final List<String> _allCategories = ["Fiction", "Love", "Drama", "Terror", "Sci-fi", "History"];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final uri = Uri.parse('http://192.168.1.2:8080/api/book/create');
    final body = json.encode({
      "title": _titleController.text,
      "subtitle": _subtitleController.text,
      "synopsis": _synopsisController.text,
      "categories": _selectedCategories,
      "releaseDate": _parseDate(_releaseDateController.text),
      "isbn": _isbnController.text,
      "author": _authorController.text,
      "price": double.tryParse(_priceController.text.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0,
    });

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livro cadastrado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar com o servidor: $e')),
      );
    }
  }

  String _parseDate(String date) {
    try {
      final inputFormat = DateFormat("dd/MM/yyyy");
      final outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(inputFormat.parse(date));
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text('Cadastre seu livro', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Será possível adicionar as fotos do livro depois do cadastro', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),

              _buildTextField(_titleController, 'Título'),
              _buildTextField(_synopsisController, 'Sinopse', maxLines: 3),

              const SizedBox(height: 12),
              const Text('Selecione as categorias', style: TextStyle(color: Colors.white)),
              Wrap(
                spacing: 8.0,
                children: _allCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        isSelected
                            ? _selectedCategories.remove(category)
                            : _selectedCategories.add(category);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              _buildTextField(_releaseDateController, 'Data de lançamento'),
              _buildTextField(_isbnController, 'ISBN'),
              _buildTextField(_authorController, 'Autor(a)'),
              _buildTextField(_priceController, 'Preço'),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('Cadastrar Livro', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool required = true, int maxLines = 1, String? hint, String? prefixText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Campo obrigatório';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefixText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
