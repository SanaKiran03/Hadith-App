import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hadith',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme
        scaffoldBackgroundColor: Colors.black, // Black background
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff023E73),
          brightness: Brightness.dark, // Ensure dark mode is consistent
        ),
        useMaterial3: true,
      ),
      home: const SplashScr(),
    );
  }
}

class SplashScr extends StatefulWidget {
  const SplashScr({super.key});

  @override
  State<SplashScr> createState() => _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HadithsScreen()));
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/2.jpg'),
      ),
    );
  }
}

class HadithsScreen extends StatefulWidget {
  const HadithsScreen({super.key});

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen> {
  late Map mapresp;
  late List listresp = [];

  Future apicalling() async {
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    http.Response response = await http
        .get(Uri.parse("https://hadithapi.com/api/books?apiKey=$apiKey"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp = jsonDecode(response.body);
        listresp = mapresp["books"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apicalling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith Books'),
        backgroundColor: const Color(0xff023E73),
        foregroundColor: Colors.white,
      ),
      body: listresp.isNotEmpty
          ? ListView.builder(
              itemCount: listresp.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xff1C1C1E), // Dark card background
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    onTap: () {
                      var bookslug = listresp[index]["bookSlug"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChaptersScreen(bookslug),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo[900],
                      radius: 30,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      listresp[index]["bookName"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      listresp[index]["writerName"],
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hadiths: ${listresp[index]["hadiths_count"]}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Chapters: ${listresp[index]["chapters_count"]}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ChaptersScreen extends StatefulWidget {
  var  bookslug;
  ChaptersScreen(this.bookslug, {super.key});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  late Map mapresp;
  late List listresp = [];

  Future apicalling() async {
    var bookname = widget.bookslug;
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    http.Response response = await http.get(Uri.parse(
        "https://hadithapi.com/api/$bookname/chapters?apiKey=$apiKey"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp = jsonDecode(response.body);
        listresp = mapresp["chapters"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apicalling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapters'),
        backgroundColor: const Color(0xff023E73),
        foregroundColor: Colors.white,
      ),
      body: listresp.isNotEmpty
          ? ListView.builder(
              itemCount: listresp.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xff1C1C1E),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    onTap: () {
                      var bookslug = listresp[index]["bookSlug"];
                      var chapterNumber = listresp[index]["chapterNumber"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HadithScreen(bookslug, chapterNumber),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo[900],
                      radius: 30,
                      child: Text(
                        listresp[index]["chapterNumber"].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      listresp[index]["chapterArabic"],
                      style: GoogleFonts.amiriQuran(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "${listresp[index]["chapterEnglish"]} | ${listresp[index]["chapterUrdu"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class HadithScreen extends StatefulWidget {
  var bookSlug;
  var  chapterNumber;
 HadithScreen(this.bookSlug, this.chapterNumber, {super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  late Map mapresp;
  late List listresp = [];

  Future apicalling() async {
    var bookname = widget.bookSlug;
    var chapterNumber = widget.chapterNumber;
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    http.Response response = await http.get(Uri.parse(
        "https://hadithapi.com/public/api/hadiths?apiKey=$apiKey&book=$bookname&chapter=$chapterNumber&paginate=1000000"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp = jsonDecode(response.body);
        listresp = mapresp["hadiths"]["data"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apicalling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadiths'),
        backgroundColor: const Color(0xff023E73),
        foregroundColor: Colors.white,
      ),
      body: listresp.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: listresp.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xff1C1C1E), // Dark card background
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      listresp[index]["hadithArabic"],
                      style: const TextStyle(
                        fontFamily: "myarabic",
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}


