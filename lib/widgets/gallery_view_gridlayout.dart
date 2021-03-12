import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:picme/widgets/photo_viewer.dart';

class GalleryViewGridLayout extends StatelessWidget {
  final QuerySnapshot snapshot;
  GalleryViewGridLayout(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
      itemBuilder: (context, index) {
        precacheImage(NetworkImage(snapshot.docs[index]["ImageUrl"]), context);
        return GestureDetector(
            onTap: () {
              Timestamp time = snapshot.docs[index]["TimeStamp"];
              var _convertedDate = DateFormat.yMMMd().format(time.toDate());
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PhotoViewer(
                      imageName: snapshot.docs[index]["ImageName"],
                      imagePath: snapshot.docs[index]["ImageUrl"],
                      createdOn: _convertedDate)));
            },
            child: Container(
              width: 100,
              height: 100,
              // color: Colors.black38,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: 100,
                      height: 100 / 0.4,
                      child: Hero(
                        tag: "imageCached",
                        child: CachedNetworkImage(
                          imageUrl: snapshot.docs[index]["ImageUrl"],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SpinKitThreeBounce(
                            color: Colors.blue[300],
                            size: 15,
                          ),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
      },
      itemCount: snapshot.docs.length,
      physics: BouncingScrollPhysics(),
    );
  }
}
