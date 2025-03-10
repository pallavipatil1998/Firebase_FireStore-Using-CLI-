import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_cli/Note%20App_with%20firestore/Email%20Authentication/signup_page.dart';
import 'package:flutter_fire_cli/main.dart';

import 'note_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Stack(
          children: [
            Container(
              color:Colors.blue.shade50
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login",style: TextStyle(
                      fontSize: 30,fontWeight: FontWeight.bold,shadows: [Shadow(color: Colors.grey,blurRadius: 3,)]
                  ),),
                  SizedBox(height: 50,),
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
                  SizedBox(height:30,),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      label: Text("Password",style: TextStyle(fontSize: 20),),
                      hintText: "Enter Password",
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                    ),
                  ),
                  SizedBox(height:35,),
                  ElevatedButton(
                    onPressed: ()async{
                    var mEmail=emailController.text.toString();
                    var mPass=passwordController.text.toString();
                    var auth=await FirebaseAuth.instance;
                    try{
                      var cred=await auth.signInWithEmailAndPassword(email: mEmail, password: mPass);
                      print("Success: User Logged in..");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoteHomePage(id: cred.user!.uid),));


                    }on FirebaseAuthException catch(e){
                      print("Error: ${e.code}");

                    }

                  },
                    child: Text("Login",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,

                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Create Account",style: TextStyle(fontSize: 15),),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));

                        },
                          child: Text("Sign Up",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold,),)),
                    ],
                  )



                ],
              ),
            ),
          ],
     ),
    );
  }
}
