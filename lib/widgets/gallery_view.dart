import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:picme/main.dart';
import '../widgets/gallery_view_gridlayout.dart';

class GalleyView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _provider = useProvider(picsDataProvider);
    return StreamBuilder(
        stream: _provider.getStreamImages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text("Upload something to display images!"),
            );
          return GalleryViewGridLayout(snapshot.data);
        });
  }
}
