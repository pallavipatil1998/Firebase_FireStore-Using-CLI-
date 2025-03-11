import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late FirebaseStorage firebaseStorage;
  List<String> listImgUrl = [];

  File? pickedImgFile;
  String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    firebaseStorage = FirebaseStorage.instance;

    FirebaseFirestore.instance
        .collection("users")
        .doc("OTFFhsDT29fbO7CjaLg3wrDvvZo2")
        .get()
        .then((value) {
      profilePicUrl = value.get("profile_pic");
      setState(() {});
    });

    var storageRef = firebaseStorage.ref();
    getImgUrl(storageRef);
/*var imgRef = storageRef.child("images/earphone_bg.png");
    getImgUrl(imgRef);
    var imgRef2 = storageRef.child("images/cake_bg.png");
    getImgUrl(imgRef2);*/
  }

  void getImgUrl(Reference ref) async {
    ListResult result = await ref.child("images").listAll();

    for (Reference item in result.items) {
      var imgUrl = await item.getDownloadURL();
      listImgUrl.add(imgUrl);
    }

    setState(() {});

/* var imgUrl = await ref.getDownloadURL();
    listImgUrl.add(imgUrl);
    setState(() {

    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Storage'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
//imagePicker
                  var imgFromGallery = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  ///FireStore Update
                  if (imgFromGallery != null) {
//pickedImgFile = File(imgFromGallery.path);
                    var croppedFile = await ImageCropper().cropImage(
                      sourcePath: imgFromGallery.path,
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false),
                        IOSUiSettings(
                          title: 'Cropper',
                        ),
                       /* WebUiSettings(
                          context: context,
                          presentStyle: CropperPresentStyle.dialog,
                          boundary: const CroppieBoundary(
                            width: 520,
                            height: 520,
                          ),
                          viewPort: const CroppieViewPort(
                              width: 480, height: 480, type: 'circle'),
                          enableExif: true,
                          enableZoom: true,
                          showZoomer: true,
                        ),*/
                      ],
                    );
                    if (croppedFile != null) {
                      pickedImgFile = File(croppedFile!.path);
                    }

//Fire
                    setState(() {});
                  }
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: pickedImgFile != null
                          ? DecorationImage(
                              image: FileImage(pickedImgFile!),
                              fit: BoxFit.cover)
                          : profilePicUrl != ""
                              ? DecorationImage(
                                  image: NetworkImage(profilePicUrl))
                              : null),
                ),
              ),
              Text(
                "WsCube tech",
                style: TextStyle(fontSize: 21),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (pickedImgFile != null) {
                      var currTime = DateTime.now().millisecondsSinceEpoch;
                      var uploadRef = firebaseStorage
                          .ref()
                          .child("images/profilepic/img_$currTime.jpg");

                      try {
                        uploadRef.putFile(pickedImgFile!).then((p0) async {
                          print("File uploaded!!");
//firestore update the url
                          var downloadUrl = await p0.ref.getDownloadURL();

//maintaining all profile pics
// (optional)
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc("OTFFhsDT29fbO7CjaLg3wrDvvZo2")
                              .collection("profilepic")
                              .add({
                            "profile_pic": downloadUrl,
                          }).then((value) {
                            print("Profile Picture updates");

// updating current profile pic
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc("OTFFhsDT29fbO7CjaLg3wrDvvZo2")
                                .update({
                              "email": "rajeev@gmail.com",
                              "id": "OTFFhsDT29fbO7CjaLg3wrDvvZo2",
                              "name": "Rajeev",
                              "profile_pic": downloadUrl
                            }).then((value) =>
                                    print("Current profile pic updated!"));
                          });
/* .update({
                            "email": "rajeev@gmail.com",
                            "id": "OTFFhsDT29fbO7CjaLg3wrDvvZo2",
                            "name": "Rajeev",
                            "profile_pic": downloadUrl
                          })*/
                        });
                      } catch (e) {
                        print("Error: ${e.toString()}");
                      }
                    }
                  },
                  child: Text('Upload Profile')),
              Expanded(
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc("OTFFhsDT29fbO7CjaLg3wrDvvZo2")
                    .collection("profilepic")
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) => Image.network(
                          snapshot.data!.docs[index].data()["profile_pic"]),
                    );
                  }
                  return Container();
                },
              )),
            ],
          ),
        ));
  }
}
