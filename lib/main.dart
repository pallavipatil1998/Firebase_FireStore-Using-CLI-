import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_cli/note_model.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore db;
  var titleController=TextEditingController();
  var descController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db=FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FireStore"),),
      body:FutureBuilder(
          future: db.collection("notes").get(),
          builder: (ctx,snapshot){
            if(snapshot.connectionState== ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Center(child: Text("Error: ${snapshot.error}"));
            }else if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx,index){
                  var model=NoteModel.fromJson(snapshot.data!.docs[index].data());
                  return ListTile(
                    title:Text(model.title!),
                    subtitle: Text(model.body!),
                  );
                  });
            }
            return Container();
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){

            showModalBottomSheet(context: context,
                builder: (ctx){
              return Container(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Add Note"),
                    SizedBox(height: 20,),
                    TextField(controller: titleController,),
                    SizedBox(height: 10,),
                    TextField(controller: descController,),
                    SizedBox(height: 30,),
                    ElevatedButton(onPressed: (){
                      var mTitle=titleController.text.toString();
                      var mDesc=descController.text.toString();

                      db.collection("notes").add(NoteModel(title: mTitle, body: mDesc).toJson()).then((value){
                        print("ID:=> ${value.id}");
                      });
                      titleController.clear();
                      descController.clear();
                      Navigator.pop(context);

                      setState(() {

                      });
                    },
                        child: Text("ADD")
                    )

                  ],
                ),
              );

                }
            );

          },
        child: Icon(Icons.add),
      ),

    );
  }
}

