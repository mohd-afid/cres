import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List student = List.empty();
  String name = "";
  String DOB = "";

  @override
  void initState() {
    super.initState();
    student = ["Hello", "Hey There"];
  }

  createstudent() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("student").doc(name);

    Map<String, String> todoList = {"studentname": name, "DOB": DOB};

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deletestudent(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("student").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *0.73,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("student").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          QueryDocumentSnapshot<Object> documentSnapshot =
                              snapshot.data?.docs[index];
                          return Dismissible(
                              key: Key(index.toString()),
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text((documentSnapshot != null)
                                      ? (documentSnapshot["studentname"])
                                      : ""),
                                  subtitle: Text((documentSnapshot != null)
                                      ? ((documentSnapshot["DOB"] != null)
                                          ? documentSnapshot["DOB"]
                                          : "")
                                      : ""),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        //todos.removeAt(index);
                                        deletestudent((documentSnapshot != null)
                                            ? (documentSnapshot["studentname"])
                                            : "");
                                      });
                                    },
                                  ),
                                ),
                              ));
                        });
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("Enter Data"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 400,
                      height: 180,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration.collapsed(hintText: 'Name'),
                              onChanged: (String value) {
                                name = value;
                              },
                            ),
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration:
                                  InputDecoration.collapsed(hintText: 'DOB'),
                              onChanged: (String value) {
                                DOB = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.black54,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                createstudent();
                              },
                              child: const Text("Submit"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
