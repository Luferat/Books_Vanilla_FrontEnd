import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:teste/page_books.dart';
import 'package:teste/register-book.dart';
import 'login.dart';
import 'register.dart';
import 'profile.dart';

/// Constantes globais do app
class AppConstants {
  static const String apiUrl = "http://10.144.31.70:8080/api/book/list";
  static const String appLogoUrl = "https://i.imgur.com/h7f6grg.png";
  static const String defaultBookCoverUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPhjUyQ760_j4k4sEKfv_7ALMg84oQUpR3eg&';
}

/// Serviço responsável pelas requisições de livros
class BookService {
  static Future<List<dynamic>> fetchBookList(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['data'] is List<dynamic>) {
          return jsonResponse['data'];
        } else {
          throw const FormatException('Estrutura JSON inesperada.');
        }
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar dados: $error');
    }
  }

  static Future<List<Map<String, String>>> fetchAndReturnBookList(
      String apiUrl,
      List<String> properties,
      ) async {
    List<Map<String, String>> bookList = [];
    try {
      List<dynamic> books = await fetchBookList(apiUrl);
      for (var book in books) {
        if (book is Map<String, dynamic>) {
          Map<String, String> bookData = {};
          for (var prop in properties) {
            bookData[prop] = book[prop]?.toString() ?? '';
          }
          bookList.add(bookData);
        }
      }
    } catch (error) {
      debugPrint('Erro: $error');
      rethrow;
    }
    return bookList;
  }
}

void main() {
  runApp(const BooksVanilla());
}

class BooksVanilla extends StatelessWidget {
  const BooksVanilla({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books Vanilla',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/register-book': (context) => const RegisterBook(),
        '/book': (context) => const PageBook(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, String>>> _booksFuture;

  final List<String> _bookProperties = [
    'title',
    'author',
    'synopsis',
    'coverImageUrl',
    'genre',
    'price',
  ];

  @override
  void initState() {
    super.initState();
    _booksFuture =
        BookService.fetchAndReturnBookList(AppConstants.apiUrl, _bookProperties);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        toolbarHeight: 200,
        foregroundColor: Colors.white,
        title: SizedBox(
          width: 400,
          height: 400,
          child: Image.network(AppConstants.appLogoUrl),
        ),
        actions: [
          IconButton(
            iconSize: 50,
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Cadastrar livro'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/register-book');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      body: FooterView(
        footer: Footer(child: Text("Rodapé aqui")),
        flex: 2,
        children: [_buildBooksGrid()],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, '/register-book'),
        tooltip: 'Registrar um livro',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBooksGrid() {
    return FutureBuilder<List<Map<String, String>>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum livro encontrado.'));
        } else {
          final books = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              itemCount: books.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 5,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                var book = books[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/book',
                      arguments: {
                        'title': book['title'],
                        'author': book['author'],
                        'imageUrl': book['coverImageUrl'],
                        'synopsis': book['synopsis'],
                        'price': book['price'],
                      },
                    );
                  },
                  child: BookCard(
                    title: book['title'] ?? 'Sem título',
                    author: book['author'] ?? 'Desconhecido',
                    imageUrl: book['coverImageUrl'] ?? AppConstants.defaultBookCoverUrl,
                    synopsis: book['synopsis'] ?? 'Sem sinopse',
                    price: book['price'] ?? '0.0',
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String synopsis;
  final String price;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.synopsis,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Autor(a): $author',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  synopsis,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ $price',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
