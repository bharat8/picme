import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:picme/main.dart';

class PhotoUploadButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final uploadToServer = useProvider(picsDataProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
      child: InkWell(
        onTap: () => uploadToServer.uploadPhotoToServer(
            context, MediaQuery.of(context).size.width),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[900], width: 2)),
          child: Text(
            "Upload Photos",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blue[900],
                fontSize: 22,
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
