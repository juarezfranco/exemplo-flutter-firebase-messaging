import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:teste_fcm_flutter/lib_awesome_notifications.dart';
import 'package:teste_fcm_flutter/lib_flutter_local_notifications.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseMessaging = await FirebaseMessaging.instance;

  // firebaseMessaging.getToken(); // prints nas callbacks não funcionam sem antes chamar getToken: https://stackoverflow.com/a/68619500

  firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  // await iniciliazarFlutterLocalNotifications();
  await inicializarAwesomeNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exemplo"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              token = await FirebaseMessaging.instance.getToken();
              print(token);
              setState(() => {});
            },
            child: const Text("Pegar token"),
          ),
          Text("Token: $token")
        ],
      ),
    );
  }
}
