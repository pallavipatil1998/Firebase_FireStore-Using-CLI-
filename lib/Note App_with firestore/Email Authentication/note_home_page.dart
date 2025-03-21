import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_cli/Note%20App_with%20firestore/Email%20Authentication/user_preference.dart';

import '../../note_model.dart';
import 'login_page.dart';

class NoteHomePage extends StatefulWidget {
  String id;
  NoteHomePage({required this.id});

  @override
  State<NoteHomePage> createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  late FirebaseFirestore db;
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue.shade100,centerTitle: true,
        title: Text("Notes App"),
      ),
      body: StreamBuilder(
          stream: db.collection("User").doc(widget.id).collection("Note").snapshots(),
          // future: db.collection("notes").get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    var model =
                    NoteModel.fromJson(snapshot.data!.docs[index].data());
                    model.id= snapshot.data!.docs[index].id!;

                    return InkWell(
                      onTap: () {
                        titleController.text = model.title!;
                        descController.text = model.body!;

                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Container(
                                height:
                                MediaQuery.of(context).viewInsets.bottom == 0.0 ? 400 : 800,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.lightBlueAccent.shade100
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Update Note"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                            ),
                                            hintText: "Enter Title",
                                            label: Text("Title")
                                        ),

                                        controller: titleController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                            ),
                                            hintText: "Enter Desc",
                                            label: Text("Desc")
                                        ),
                                        controller: descController,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            var mMTitle =
                                            titleController.text.toString();
                                            var mDDesc =
                                            descController.text.toString();

                                            db.collection("Note").doc(model.id).set(NoteModel(
                                                title:mMTitle ,
                                                body: mDDesc
                                            ).toJson()
                                            );

                                            /* db.collection("notes").doc(model.id).update(NoteModel(
                                              title:mMTitle ,
                                              body:mDDesc ,
                                            ).toJson());*/


                                            titleController.clear();
                                            descController.clear();
                                            Navigator.pop(context);

                                          },
                                          child: Text("Update"))
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(model.title!),
                        subtitle: Text(model.body!),
                        trailing: InkWell(
                            onTap: () {
                              db.collection("Note").doc(model.id).delete();
                            },
                            child: Icon(Icons.delete)),
                      ),
                    );
                  });
            }
            return Container();
          }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "Logout Button",
            onPressed: (){
            Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginPage(),));
            UserPreferences().setUID("");
          },
            child: Icon(Icons.logout),tooltip:"LogOut",

          ),
          FloatingActionButton(
            heroTag: "Add Note",
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      color: Colors.blue.shade100,
                      height:MediaQuery.of(context).viewInsets.bottom ==
                          0.0
                          ? 400
                          : 900,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Add Note"),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                  ),
                                  hintText: "Enter Title",
                                  label: Text("Title")
                              ),
                              controller: titleController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                  ),
                                  hintText: "Enter Desc",
                                  label: Text("Desc")
                              ),
                              controller: descController,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  var mTitle = titleController.text.toString();
                                  var mDesc = descController.text.toString();

                                  db.collection("User").doc(widget.id)
                                      .collection("Note")
                                      .add(NoteModel(title: mTitle, body: mDesc)
                                      .toJson())
                                      .then((value) {
                                    print("ID:=> ${value.id}");
                                  });
                                  titleController.clear();
                                  descController.clear();
                                  Navigator.pop(context);

                                },
                                child: Text("ADD"))
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Icon(Icons.add),tooltip:"Add",
          ),
        ],
      ),
    );
  }
}