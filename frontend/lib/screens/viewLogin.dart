import 'package:flutter/material.dart';
import 'package:frontend/viewModel/viewModel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String userType = "Interne";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final classViewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITRE
                  const Text(
                    "Connexion AVIA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Assistant IA de gestion des rendez-vous",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  // ───── CHOIX INTERNE / EXTERNE ─────
                  Row(
                    children: [

                      Expanded(
                        child: _userBox(
                          title: "Interne",
                          description: "Employé de l’entreprise avec accès aux outils internes.",
                          value: "Interne",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _userBox(
                          title: "Externe",
                          description: "Client ou partenaire demandant un rendez-vous.",
                          value: "Externe",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // NOM
                  _input("Nom complet", Icons.person, nameController),

                  const SizedBox(height: 12),

                  // EMAIL
                  _input("Email", Icons.email, emailController),

                  const SizedBox(height: 12),

                  // PASSWORD
                  _input("Mot de passe", Icons.lock, passwordController,
                      obscure: true),

                  const SizedBox(height: 25),

                  // BOUTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () {
                        classViewModel.login(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),

                      child: const Text(
                        "Se connecter",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── USER BOX ─────────────────
  Widget _userBox({
    required String title,
    required String description,
    required String value,
  }) {

    final selected = userType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          userType = value;
        });
      },

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: selected
                ? const Color(0xFF2F80ED)
                : Colors.grey.shade300,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // RADIO + TITLE
            Row(
              children: [

                Container(
                  width: 18,
                  height: 18,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF2F80ED)
                          : Colors.grey,
                      width: 2,
                    ),
                  ),

                  child: selected
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF2F80ED),
                            ),
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 8),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── INPUT ─────────────────
  Widget _input(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}