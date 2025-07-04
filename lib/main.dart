import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:teste/register-book.dart';
import 'login.dart';
import 'register.dart';

/// Constantes para requisições de rede e ativos de imagem.
class AppConstants {
  static const String apiUrl = "http://192.168.1.2:8080/api/book/list";
  static const String appLogoUrl = "https://i.imgur.com/h7f6grg.png";
  static const String defaultBookCoverUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPhjUyQ760_j4k4sEKfv_7ALMg84oQUpR3eg&';
}

/// Uma classe de serviço para lidar com chamadas de API relacionadas a livros.
class BookService {
  /// Busca uma lista JSON de livros da [apiUrl] fornecida.
  /// A função espera que o JSON tenha uma chave "data" contendo uma lista.
  static Future<List<dynamic>> fetchBookList(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['data'] is List<dynamic>) {
          return jsonResponse['data'];
        } else {
          throw const FormatException(
              'Estrutura JSON inesperada: lista "data" não encontrada.');
        }
      } else {
        throw Exception(
            'Falha ao carregar dados, código de status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar dados: $error');
    }
  }

  /// Busca a lista JSON de livros da [apiUrl] e retorna as propriedades
  /// especificadas de cada livro como uma Lista de Map<String, String>.
  static Future<List<Map<String, String>>> fetchAndReturnBookList(
      String apiUrl, List<String> properties) async {
    List<Map<String, String>> bookList = [];

    try {
      List<dynamic> books = await fetchBookList(apiUrl);

      for (var book in books) {
        if (book is Map<String, dynamic>) {
          Map<String, String> bookData = {};
          for (var property in properties) {
            bookData[property] = book[property]?.toString() ?? '';
          }
          bookList.add(bookData);
        }
      }
    } catch (error) {
      debugPrint('Erro: $error'); // Use debugPrint para erros de desenvolvimento
      rethrow; // Lança o erro novamente para ser capturado pelo FutureBuilder
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
    'price',
    'genre',
    'coverImageUrl',
    'author'
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
        actions: <Widget>[
          IconButton(
            iconSize: 50.0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),

/*------------------------------------------------------quebrado------------------------------------------------------*/
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
/*------------------------------------------------------------------------------------------------------------*/
      body: FooterView(
        footer: Footer(
          child: Text(""),
        ),
        flex: 1,
        children: [
          _buildBooksGrid(),
        ],
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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                var book = books[index];
                return BookCard(
                  title: book['title'] ?? 'Sem Título',
                  author: book['author'] ?? 'Sem Autor',
                  imageUrl:
                  book['coverImageUrl'] ?? AppConstants.defaultBookCoverUrl,
                  synopsis: book['price'] ?? 'Sem Preço', // Preço usado como sinopse
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

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.synopsis,
  });

  /*----------------------------------------------------------Costomizasão dos livros----------------------------------------*/

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.redAccent),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              author,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              synopsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}