import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_app/l10n/translation_helper.dart';

class KelimePage extends StatefulWidget {
  const KelimePage({super.key});

  @override
  State<KelimePage> createState() => _KelimePageState();
}

class _KelimePageState extends State<KelimePage> {
  String? kelime;
  String? anlam;
  bool isLoading = true;

  final user = FirebaseAuth.instance.currentUser;
  late DatabaseReference userWordsRef;
  int todayWordCount = 0;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      userWordsRef = FirebaseDatabase.instance.ref("users/${user!.uid}/learnedWords");
      kontrolVeGetir();
    }
  }

  Future<void> kontrolVeGetir() async {
    setState(() => isLoading = true);

    final snapshot = await userWordsRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;

    final now = DateTime.now();
    todayWordCount = 0;
    List<String> learnedToday = [];

    if (data != null) {
      for (var value in data.values) {
        final timestamp = value['timestamp'];
        if (timestamp != null) {
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
          if (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day) {
            todayWordCount++;
            learnedToday.add(value['word']);
          }
        }
      }
    }

    if (todayWordCount >= 10) {
      setState(() {
        kelime = "Günlük sınır doldu.";
        anlam = "Yarın tekrar devam edebilirsin!";
        isLoading = false;
      });
    } else {
      await fetchRandomWord(learnedToday);
    }
  }

  Future<void> fetchRandomWord(List<String> alreadyLearned) async {
    try {
      final response = await http.get(Uri.parse('https://random-word-api.herokuapp.com/word'));
      if (response.statusCode == 200) {
        final List words = json.decode(response.body);
        final word = words[0];

        if (alreadyLearned.contains(word)) {
          fetchRandomWord(alreadyLearned);
          return;
        }

        final meaningResponse = await http.get(
          Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/$word"),
        );

        if (meaningResponse.statusCode == 200) {
          final data = json.decode(meaningResponse.body);
          final definition = data[0]['meanings'][0]['definitions'][0]['definition'];

          setState(() {
            kelime = TranslationHelper.getTranslatedWord(context, word);
            anlam = definition;
            isLoading = false;
          });
        } else {
          fetchRandomWord(alreadyLearned);
        }
      }
    } catch (e) {
      setState(() {
        kelime = "Hata";
        anlam = "Kelime getirilemedi.";
        isLoading = false;
      });
    }
  }

  Future<void> markAsLearned() async {
    if (user != null && kelime != null) {
      await userWordsRef.child(kelime!).set({
        'word': kelime,
        'meaning': anlam,
        'timestamp': ServerValue.timestamp,
      });
    }
    kontrolVeGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelimeler")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    kelime ?? "",
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    anlam ?? "",
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: kelime == "Günlük sınır doldu." ? null : markAsLearned,
                        child: const Text("Öğrendim"),
                      ),
                      ElevatedButton(
                        onPressed: kelime == "Günlük sınır doldu." ? null : kontrolVeGetir,
                        child: const Text("Daha Sonra"),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
