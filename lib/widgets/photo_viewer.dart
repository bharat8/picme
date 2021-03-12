import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/appbar_for_photo_viewer.dart';

class PhotoViewer extends StatelessWidget {
  final String imageName;
  final String imagePath;
  final String createdOn;
  PhotoViewer({this.imageName, this.imagePath, this.createdOn});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              // color: Colors.white,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8 -
                  MediaQuery.of(context).padding.top,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2 / 2),
              child: InteractiveViewer(
                child: Hero(
                  tag: "imageCached",
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    placeholder: (context, url) => SpinKitThreeBounce(
                      color: Colors.blue[300],
                      size: 15,
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                // color: Colors.white,
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                      backgroundColor: Colors.black,
                      context: context,
                      builder: (context) => Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: Text(
                                "Created on:   $createdOn",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "SF Pro Display",
                                    fontSize: 22),
                              ),
                            ),
                          )),
                  child: Center(
                      child: Icon(
                    Icons.info,
                    size: 30,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
            AppBarForPhotoViewer(imageName: imageName),
          ],
        ),
      ),
    );
  }
}
