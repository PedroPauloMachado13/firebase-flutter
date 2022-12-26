import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key, required this.title});
  final String title;

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final dbRef = FirebaseDatabase.instance.ref().child("pets");
  final List lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.hasData) {
                //lists.clear();
                Map<dynamic, dynamic> values =
                    snapshot.data!.snapshot.value as Map;
                values.forEach((key, values) {
                  lists.add(values);
                });
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Nome: " + lists[index]["name"]),
                            Text("Idade: " + lists[index]["age"]),
                            Text("Raça: " + lists[index]["type"]),
                          ],
                        ),
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
