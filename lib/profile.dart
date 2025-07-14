
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<String?> getSavedCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void saveCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loged', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: getSavedCookie(), // Call the async function
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the data is loading, show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there was an error, display it
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // If the data is available, display it
              String? username = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bem Vindo, $username!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle logout logic here
                      saveCookie();
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            } else {
              // If no data is found
              return const Text('No cookie found.');
            }
          },
        ),
      ),
    );
  }
}
