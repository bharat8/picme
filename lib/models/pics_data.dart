import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picme/widgets/options_to_upload_button.dart';
import 'package:dio/dio.dart';

class PicsData {
  Stream<QuerySnapshot> getStreamImages() {
    return FirebaseFirestore.instance
        .collection("Images Location")
        .orderBy("TimeStamp", descending: true)
        .snapshots();
  }

  void uploadImages(String option) async {
    File _imageFile;
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
        source: option == "Camera" ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 40);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      addToServerStorage(_imageFile);
    }
  }

  void addToServerStorage(File image) async {
    //add Images to Firebase bucket
    await Firebase.initializeApp();
    int count;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      firebase_storage.ListResult list = await storage.ref('Images').listAll();
      if (list.items.length > 0)
        count = list.items.length + 1;
      else
        count = 1;
      await storage
          .ref('Images/image$count')
          .putFile(image)
          .then((firebase_storage.TaskSnapshot snapshot) async {
        //add to firestore DB
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference loc = firestore.collection('Images Location');
        String path = await snapshot.ref.getDownloadURL();
        loc.add({
          'ImageName': "image$count",
          'ImageUrl': "$path",
          'TimeStamp': Timestamp.now(),
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void uploadPhotoToServer(BuildContext context, double width) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OptionsToUpload(
              width: width / 2,
              height: 80,
              option: "Camera",
            ),
            OptionsToUpload(
              width: width / 2,
              height: 80,
              option: "Gallery",
            ),
          ],
        ),
      ),
    );
  }

  void deletePhotoFromServer(String imageName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snap = await firestore.collection('Images Location').get();
    snap.docs.forEach((element) {
      if (element.data().containsValue(imageName))
        firestore.collection('Images Location').doc(element.id).delete();
    });

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Images/$imageName')
          .delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<bool> addToDeviceStorage(String imageName) async {
    bool successfull = false;
    try {
      String url = await firebase_storage.FirebaseStorage.instance
          .ref('Images/$imageName')
          .getDownloadURL();
      await _saveNetworkImage(url, imageName).then((value) {
        successfull = value;
      });
    } on FirebaseException catch (e) {
      print(e);
    }
    return successfull;
  }

  Future<bool> _saveNetworkImage(String url, String imageName) async {
    if (!await Permission.storage.isGranted) {
      await [
        Permission.storage,
      ].request();
    }
    //create Path for images
    Directory appDocDir = await getExternalStorageDirectory();
    String path = "${appDocDir.path}/UserImages";
    var imagesDir = Directory(path);
    bool check = await imagesDir.exists();
    if (check == false) await imagesDir.create();
    String imagePath = "$path/$imageName.jpeg";

    //Download image
    await Dio().download(url, imagePath, onReceiveProgress: (count, total) {
      // print((count / total * 100).toStringAsFixed(0) + "%");
    });
    await ImageGallerySaver.saveFile("$imagePath").onError((error, stackTrace) {
      print(error);
      return false;
    });
    return true;
  }
}
