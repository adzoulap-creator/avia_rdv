import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http ;

class ViewModelCreateEntreprise {

  Future <void> createEntreprise({

    required String nameEntreprise , 
    required String secteurEntreprise ,
    required String villeEntreprise ,
    required String tailleEntrprise,
    Uint8List? logoEntreprise,
    required String namePDG,
    required String firstNamePDG,
    required String emailPDG,
    required String pwdPDG,
    required String confirPwdPDG,
    required String telPDG,
    required String serviceEntreprise,
    required int nbServices,

  }) async {


    final url = Uri.parse("http://127.0.0.1:8000/mail/");

    final reponse = await http.post(
      url,
      headers:{"content-type": "application/json"},
      body:jsonEncode({
        "nameEntreprise": nameEntreprise,
        "secteurEntreprise": secteurEntreprise,
        "villeEntreprise": villeEntreprise,
        "tailleEntrprise": tailleEntrprise,
        "logoEntreprise": "",

        "namePDG": namePDG,
        "firstNamePDG": firstNamePDG,
        "emailPDG": emailPDG,
        "pwdPDG": pwdPDG,
        "confirPwdPDG": confirPwdPDG,

        "telPDG": telPDG,

        "nbServices": nbServices,

        "serviceEntreprise": serviceEntreprise,
      })

    );

      print("nameEntreprise: $nameEntreprise");
      print("secteurEntreprise: $secteurEntreprise");
      print("villeEntreprise: $villeEntreprise");
      print("tailleEntrprise: $tailleEntrprise");
      print("logoEntreprise: $logoEntreprise");

      print("namePDG: $namePDG");
      print("firstNamePDG: $firstNamePDG");
      print("emailPDG: $emailPDG");
      print("pwdPDG: $pwdPDG");
      print("confirPwdPDG: $confirPwdPDG");

      print("telPDG: $telPDG");

      print("nbServices: $nbServices");

      print("serviceEntreprise: $serviceEntreprise");


      print(reponse.statusCode);
      print(reponse.body);

  }

}