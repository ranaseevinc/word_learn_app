import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profil_page.dart';
import 'kelime_page.dart';
import 'package:lottie/lottie.dart';
import 'ogrenilen_kelimeler_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.email?.split('@').first ?? "Kullanıcı";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 224, 239),
        title: const Text("Kelime Öğrenme Uygulaması"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Lottie.network(
              'https://assets2.lottiefiles.com/packages/lf20_tfb3estd.json',
              width: 180,
              height: 180,
              repeat: true,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              "Hoş geldin, $displayName 👋",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color.fromARGB(255, 117, 81, 167),
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Bugün öğrenmen için 10 kelime hazır!",
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _HomeCard(
                    icon: Icons.book,
                    label: "Kelimeler",
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelimePage(),
                        ),
                      );
                    },
                  ),
                  _HomeCard(
                    icon: Icons.check,
                    label: "Öğrenilenler",
                    color: Colors.deepOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OgrenilenKelimelerPage(),
                        ),
                      );
                    },
                  ),
                  _HomeCard(
                    icon: Icons.person,
                    label: "Profil",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _HomeCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // ignore: deprecated_member_use
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
