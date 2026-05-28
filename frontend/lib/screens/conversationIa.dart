import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationIa extends StatefulWidget {
  @override
  _ConversationIaState createState() => _ConversationIaState();
}

class _ConversationIaState extends State<ConversationIa> {

  TextEditingController demandeIa = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void dispose() {
    demandeIa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(220, 223, 244, 250),

      appBar: AppBar(
        title: Text("Votre assistant AVIA"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print("Menu clique");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              print("Profile cliqué");
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Column(
            children: [

              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(240, 250, 251, 252),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];

                    return Align(
                      alignment: msg["role"] == "user"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: msg["role"] == "user"
                              ? Colors.blue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg["text"] ?? "",
                          style: TextStyle(
                            color: msg["role"] == "user"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10),

              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(240, 250, 251, 252),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: demandeIa,
                        decoration: InputDecoration(
                          hintText: "Écris ici...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () async {
                        String message = demandeIa.text;

                        // 👉 ajouter message utilisateur
                        setState(() {
                          messages.add({
                            "role": "user",
                            "text": message
                          });
                        });

                        // 👉 appeler API
                        String reponse = await envoyerMessage(message);

                        // 👉 ajouter réponse IA
                        setState(() {
                          messages.add({
                            "role": "ai",
                            "text": reponse
                          });
                        });

                        demandeIa.clear();
                      },
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Future<String> envoyerMessage(String message) async {
  final url = Uri.parse("http://127.0.0.1:8000/flutter/");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"message": message}),
  );

  final data = jsonDecode(response.body);

  return data["reponse"]; // 
}