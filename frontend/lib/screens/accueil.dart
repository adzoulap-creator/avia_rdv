import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'conversationIa.dart';
import 'create_entreprise.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // ───────────── LOGO IA ─────────────

                Container(
                  width: 70,
                  height: 70,

                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Color(0xFF6C5CE7),
                    size: 38,
                  ),
                ),

                const SizedBox(height: 30),

                // ───────────── TITRE ─────────────

                const Text(
                  'Assistant Virtuel IA\npour la gestion\ndes rendez-vous',

                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A2E),
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 20),

                // ───────────── DESCRIPTION ─────────────

                const Text(
                  'Une solution intelligente permettant aux entreprises de gérer automatiquement les rendez-vous internes et externes grâce à l’intelligence artificielle.',

                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 35),

                // ───────────── BOUTON ─────────────

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.calendar_month),

                    label: const Text(
                      'Commencer',
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                RichText(
                  textAlign: TextAlign.center,

                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),

                    children: [

                      const TextSpan(
                        text: "Pour plus de détails sur l’application, demander à ",
                      ),

                      TextSpan(
                        text: "Assistant AVIA",
                        style: const TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.bold,
                        ),

                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationIa(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                // ───────────── CARD PRINCIPALE ─────────────

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      // TOP BAR

                      Row(
                        children: [

                          Container(
                            width: 12,
                            height: 12,

                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Container(
                            width: 12,
                            height: 12,

                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Container(
                            width: 12,
                            height: 12,

                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // IA CARD

                      Container(
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Row(
                          children: [

                            Container(
                              width: 55,
                              height: 55,

                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: const Icon(
                                Icons.support_agent,
                                color: Color(0xFF6C5CE7),
                                size: 30,
                              ),
                            ),

                            const SizedBox(width: 16),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    "Assistant intelligent",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    "Planification automatique des rendez-vous",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // FONCTIONNALITÉS

                      const Text(
                        "Fonctionnalités",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _item(Icons.people_alt_outlined,
                          "Gestion des rendez-vous internes"),

                      _item(Icons.public,
                          "Gestion des rendez-vous externes"),

                      _item(Icons.chat_bubble_outline,
                          "Interaction en langage naturel"),

                      _item(Icons.lock_outline,
                          "Authentification sécurisée"),

                      _item(Icons.notifications_active_outlined,
                          "Notifications automatiques"),

                      _item(Icons.history,
                          "Historique des rendez-vous"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────── ITEM ─────────────

  Widget _item(IconData icon, String text) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF6C5CE7),
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}