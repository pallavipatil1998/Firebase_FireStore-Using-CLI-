import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_cli/Note%20App_with%20firestore/Email%20Authentication/user_preference.dart';

import 'note_user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var confirmPassController=TextEditingController();
  var genderController=TextEditingController();
  var ageController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              color:Colors.blue.shade50
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text("Sign Up",style: TextStyle(
                        fontSize: 30,fontWeight: FontWeight.bold,shadows: [Shadow(color: Colors.grey,blurRadius: 3,)]
                    ),),
                  ),
                  SizedBox(height: 50,),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      label: Text("Name",style: TextStyle(fontSize: 20),),
                      hintText: "Enter Your Name",
                      prefixIcon: Icon(Icons.text_format),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
            
                    ),
                  ),
                  SizedBox(height:25,),
                  TextField(
                    controller: genderController,
                    decoration: InputDecoration(
                      label: Text("Gender",style: TextStyle(fontSize: 20),),
                      hintText: "Enter Your Gender",
                      prefixIcon: Icon(Icons.man),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
            
                    ),
                  ),
                  SizedBox(height:25,),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      label: Text("Age",style: TextStyle(fontSize: 20),),
                      hintText: "Enter Your Age",
                      prefixIcon: Icon(Icons.man),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                    ),
                  ),
                  SizedBox(height:25,),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: Text("Email",style: TextStyle(fontSize: 20),),
                      hintText: "Enter Your Email_id",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
            
                    ),
                  ),
                  SizedBox(height:25,),
                  TextField(
                    controller: passwordController,
                    obscuringCharacter: "*",
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Password",style: TextStyle(fontSize: 20),),
                      hintText: "Enter Password",
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
            
                    ),
                  ),
                  SizedBox(height:25,),
                  TextField(
                    controller: confirmPassController,
                    decoration: InputDecoration(
                      label: Text("Confirm Password",style: TextStyle(fontSize: 20),),
                      hintText: "Confirm Your Password",
                      prefixIcon: Icon(Icons.password_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
            
                    ),
                  ),
                  SizedBox(height:35,),
                  ElevatedButton(onPressed: ()async{
                    if(passwordController.text.toString()==confirmPassController.text.toString()){
                      var auth=FirebaseAuth.instance;
                      var email=emailController.text.toString();
                      var pass=passwordController.text.toString();
                      var name=nameController.text.toString();
                      var gender=genderController.text.toString();
                      var age=int.parse(ageController.text.toString());

                      try{
                        var cred= await auth.createUserWithEmailAndPassword(email: email, password: pass);
                        var db=FirebaseFirestore.instance;
                        db.collection("User").doc(cred.user!.uid).set(NoteUserModel(
                          name: name, email: email,gender: gender,age: age,
                          id: cred.user!.uid
                        ).toJson());

                        UserPreferences().setUID(cred.user!.uid);

                        print("User Added: ${cred.user!.uid}");
                        Navigator.pop(context);

                      }on FirebaseAuthException catch(e){
                        print("Error:${e.code}");
                      }

                    }

            
                  },
                    child: Text("Sign Up",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
            
                    ),
                  ),
            
            
            
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
