import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart'; 
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final User? currentUser = FirebaseAuth.instance.currentUser;
  late DatabaseReference userRef;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (currentUser != null) {
      userRef = FirebaseDatabase.instance.ref("users/${currentUser!.uid}");
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      nameController.text = data["name"] ?? "";
      surnameController.text = data["surname"] ?? "";
      birthdateController.text = data["birthdate"] ?? "";
      emailController.text = data["email"] ?? currentUser!.email ?? "";
    } else {
      emailController.text = currentUser!.email ?? "";
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      await userRef.update({
        "name": nameController.text.trim(),
        "surname": surnameController.text.trim(),
        "birthdate": birthdateController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil bilgileri güncellendi"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    birthdateController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return false; 
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Ad",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Ad giriniz" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: surnameController,
                        decoration: const InputDecoration(
                          labelText: "Soyad",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Soyad giriniz" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: birthdateController,
                        decoration: const InputDecoration(
                          labelText: "Doğum Tarihi",
                          hintText: "YYYY-AA-GG",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Doğum tarihi giriniz"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _saveUserData,
                        child: const Text("Güncelle"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
