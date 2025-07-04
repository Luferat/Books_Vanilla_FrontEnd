import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'main.dart';
import 'register.dart';

class PageBook extends StatelessWidget{

  const PageBook({super.key});

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    String? label;
    String? author;
    String? imageUrl;
    String? synopsis;

    if (args != null) {
      label = args['title'];
      author = args['author'];
      imageUrl = args['imageUrl'];
      synopsis = args['synopsis'];
    }

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

      body: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading errors gracefully
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.error, color: Colors.redAccent),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Book Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                author!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                synopsis!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      )
    );
  }


}

