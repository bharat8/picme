import 'package:flutter/material.dart';
import 'package:picme/widgets/gallery_view.dart';
import 'package:picme/widgets/upload_photo_button.dart';
import '../widgets/app_name.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double calWidth = MediaQuery.of(context).size.width;
    double calHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: calWidth,
              height: calHeight * 0.1,
              child: AppName(),
            ),
            Container(
              width: double.infinity,
              height: calHeight * 0.75 - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.all(5),
              child: GalleyView(),
            ),
            Container(
                width: calWidth,
                height: calHeight * 0.15,
                // color: Colors.black12,
                child: PhotoUploadButton()),
          ],
        ),
      ),
    );
  }
}
