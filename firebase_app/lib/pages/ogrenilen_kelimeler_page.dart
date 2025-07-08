import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class OgrenilenKelimelerPage extends StatefulWidget {
  const OgrenilenKelimelerPage({super.key});

  @override
  State<OgrenilenKelimelerPage> createState() => _OgrenilenKelimelerPageState();
}

class _OgrenilenKelimelerPageState extends State<OgrenilenKelimelerPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> ogrenilenKelimeler = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLearnedWords();
  }

  Future<void> fetchLearnedWords() async {
    final ref = FirebaseDatabase.instance.ref("users/${user!.uid}/learnedWords");
    final snapshot = await ref.get();

    final data = snapshot.value as Map?;
    ogrenilenKelimeler.clear();

    if (data != null) {
      data.forEach((key, value) {
        ogrenilenKelimeler.add({
          'kelime': key,
          'anlam': value['meaning'] ?? '',
          'timestamp': value['timestamp'] ?? 0,
        });
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrenilen Kelimeler"),
        backgroundColor: const Color.fromARGB(255, 252, 230, 223),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ogrenilenKelimeler.isEmpty
              ? const Center(child: Text("Henüz öğrenilen kelime yok."))
              : ListView.builder(
                  itemCount: ogrenilenKelimeler.length,
                  itemBuilder: (context, index) {
                    final kelime = ogrenilenKelimeler[index];
                    final tarih = DateTime.fromMillisecondsSinceEpoch(kelime['timestamp']);

                    return ListTile(
                      leading: const Icon(Icons.check, color: Colors.green),
                      title: Text(kelime['kelime']),
                      subtitle: Text(kelime['anlam']),
                      trailing: Text(
                        "${tarih.day}.${tarih.month}.${tarih.year}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
    );
  }
}
