import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_cli/Users/user_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late FirebaseFirestore db;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var ageController = TextEditingController();

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
        title: Text("User App"),
      ),
      body: StreamBuilder(
          stream: db.collection("users").snapshots(),
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
                    var model = UserModel.fromJson(snapshot.data!.docs[index].data());
                    model.id= snapshot.data!.docs[index].id!;

                    return InkWell(
                      onTap: () {
                        nameController.text = model.name!;
                        emailController.text = model.email!;
                        ageController.text = model.age.toString();

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
                                      Text("Update User"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                            ),
                                            hintText: "Enter Name",
                                            label: Text("Name")
                                        ),

                                        controller: nameController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                            ),
                                            hintText: "Enter Email",
                                            label: Text("Email")
                                        ),
                                        controller: emailController,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                                            ),
                                            hintText: "Enter Age",
                                            label: Text("Age")
                                        ),
                                        controller: ageController,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            var mNName = nameController.text.toString();
                                            var mEEmail = emailController.text.toString();
                                            var mAAge = int.parse(ageController.text.toString());

                                            db.collection("users").doc(model.id).set(UserModel(
                                               name: mNName,
                                              email:mEEmail ,
                                              age: mAAge
                                            ).toJson()
                                            );

                                            /* db.collection("notes").doc(model.id).update(NoteModel(
                                              title:mMTitle ,
                                              body:mDDesc ,
                                            ).toJson());*/


                                            nameController.clear();
                                            emailController.clear();
                                            ageController.clear();
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${model.name}"),
                            SizedBox(width: 10,),
                            Text("Age: ${model.age}"),
                          ],
                        ),
                        subtitle: Text("${model.email}"),
                        trailing: InkWell(
                            onTap: () {
                              db.collection("users").doc(model.id).delete();
                            },
                            child: Icon(Icons.delete)),
                      ),
                    );
                  });
            }
            return Container();
          }),
      floatingActionButton: FloatingActionButton(
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
                        Text("Add User"),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                              ),
                              hintText: "Enter Name",
                              label: Text("Name")
                          ),
                          controller: nameController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                              ),
                              hintText: "Enter Email",
                              label: Text("Email")
                          ),
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius:BorderRadius.circular(5),
                              ),
                              hintText: "Enter Age",
                              label: Text("Age")
                          ),
                          controller: ageController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              var mName = nameController.text.toString();
                              var mEmail = emailController.text.toString();
                              var mAge = int.parse(ageController.text.toString());

                              db
                                  .collection("users")
                                  .add(UserModel(name: mName,email: mEmail,age: mAge)
                                  .toJson())
                                  .then((value) {
                                print("ID:=> ${value.id}");
                              });
                              nameController.clear();
                              emailController.clear();
                              ageController.clear();
                              Navigator.pop(context);

                            },
                            child: Text("ADD"))
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
