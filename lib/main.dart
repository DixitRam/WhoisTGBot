import 'dart:convert' as convert;
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

void main(List<String> arguments) async {
  final Map<String, String> envVars = Platform.environment;

  final telegram = Telegram(envVars['BOT_TOKEN']!);
  var me = await telegram.getMe();
  final webhook = await Webhook.createHttpWebhok(telegram, envVars['HOST_URL']!,
      serverPort: 8443, port: 443);
  var teledart =
      TeleDart(envVars['BOT_TOKEN']!, Event(me.username!), fetcher: webhook);

  print(teledart.toString());
  teledart.start();
  teledart.onCommand('start').listen((message) => message.reply(
      'Welcome , Send Me Link I Will Give You 𝗜𝗻𝗳𝗼 Abot It. \n It May Be Slow Due to Hosted Server'));

  String Site = "example.com";

  teledart.onUrl().listen((event) =>
      Site = event.text!.replaceAll('http://', '').replaceAll('https://', ''));
  print("Given Site : $Site ");
  teledart
      .onUrl()
      .listen((msg) async => msg.reply(await getsite(Site), parseMode: 'HTML'));
}

Future<String> getsite(site) async {
  try {
    final Map<String, String> envVars = Platform.environment;

    final url = Uri.https(
      "zozor54-whois-lookup-v1.p.rapidapi.com",
      "/",
      {'domain': await site, 'format': 'json'},
    );

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': envVars['RapidKey']!,
      'X-RapidAPI-Host': 'zozor54-whois-lookup-v1.p.rapidapi.com'
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var msg =
          " <b>𝗗𝗼𝗺𝗮𝗶𝗻 𝗜𝗻𝗳𝗼 :</b> \n Domain : ${jsonResponse['name']} \n \n Registar : ${jsonResponse['registrar']['name']} \n \n Registered On : ${jsonResponse['created']} \n \n Updated On : ${jsonResponse['changed']} \n \n Expires On : <span class='tg-spoiler'> ${jsonResponse['expires']}</span> \n \n Status : ${jsonResponse['status'].toString().replaceAll('[', ' ').replaceAll(',', '\n').replaceAll(']', ' ')} \n \n Name Servers : ${jsonResponse['nameserver'].toString().replaceAll('[', ' ').replaceAll(',', '\n').replaceAll(']', ' ')}";

      return msg.toString();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return "Something Went Wrong. Please Check Url";
    }
  } catch (e) {
    return "Something Went Wrong. Please Check Url";
  }
}
