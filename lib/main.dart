import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_flutter/form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormPage(
        title: 'Home',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fb = FirebaseDatabase.instance;
  final _controller = TextEditingController();
  final name = "Nome";
  var retrievedName;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(name),
                const SizedBox(width: 20),
                Expanded(child: TextField(controller: _controller)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                ref.child(name).set(_controller.text);
              },
              child: const Text("Enviar"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.child("name").once().then((event) {
                  final data = event.snapshot;
                  setState(() {
                    retrievedName = data.value;
                  });
                });
              },
              child: const Text("Recuperar nome"),
            ),
            Text(retrievedName ?? ""),
          ],
        )));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
}
