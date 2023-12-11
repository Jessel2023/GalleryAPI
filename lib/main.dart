import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
        useMaterial3: false,
      ).copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 190, 227, 245),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => FirstPage();
}

class FirstPage extends State<Home> {
  List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    // Fetch initial set of photos
    getPhotos();
  }

  getPhotos() async {
    var apiKey = 'j-xmGfdx9Qp7Ra_dDkmPd0kBCJs5bdgEyeCH-hEmq3s';
    var url = Uri.parse(
        'https://api.unsplash.com/photos?client_id=$apiKey&per_page=30&page=');

    var response = await http.get(url);

    setState(() {
      photos.addAll(json.decode(response.body));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.code),
        title: Text("API Activity"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondPage(
                    photoUrl: photos[index]["urls"]["regular"],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(photos[index]["urls"]["thumb"]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String photoUrl;

  SecondPage({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Second page"),
        centerTitle: true,
      ),
      body: Center(
        child: Image.network(
          photoUrl,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            print('Error loading image: $error');
            print('StackTrace: $stackTrace');
            return Center(
              child: Text('Error loading image'),
            );
          },
        ),
      ),
    );
  }
}
