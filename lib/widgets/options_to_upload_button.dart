import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:picme/main.dart';

class OptionsToUpload extends HookWidget {
  final double width;
  final double height;
  final String option;
  OptionsToUpload({this.width, this.height, this.option});

  @override
  Widget build(BuildContext context) {
    final imageUploadProvider = useProvider(picsDataProvider);
    return InkWell(
        onTap: () {
          Navigator.of(context).pop();
          imageUploadProvider.uploadImages(option);
        },
        child: Container(
            height: 80,
            width: width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  option == "Camera" ? Icons.camera : Icons.photo,
                  size: 30,
                ),
                Text(option)
              ],
            )));
  }
}
