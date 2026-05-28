import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginViewModel {

  Future<void> login(String name, String email, String password) async {

    final url = Uri.parse('http://127.0.0.1:8000/users/');

    final reponse = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        
      }),
    );

    print("Envoi...");
    print(name);
    print(email);
    print(password);


    print(reponse.statusCode);
    print(reponse.body);
  }

}