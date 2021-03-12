import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:picme/main.dart';
import 'dowload_widget.dart';

class AppBarForPhotoViewer extends HookWidget {
  const AppBarForPhotoViewer({
    Key key,
    @required this.imageName,
  }) : super(key: key);

  final String imageName;

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(picsDataProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      color: Colors.black54,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: 50,
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              imageName,
              style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 22,
                  color: Colors.white),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          DownloadButton(downloadFile: provider, imageName: imageName),
          GestureDetector(
            onTap: () async {
              await showDialog<int>(
                context: context,
                builder: (context) => AlertDialog(
                  actionsPadding: EdgeInsets.all(10),
                  content: Text(
                    "Do you want to delete?",
                    style:
                        TextStyle(fontFamily: "SF Pro Display", fontSize: 20),
                  ),
                  actions: [
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop(1);
                        provider.deletePhotoFromServer(imageName);
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontFamily: "SF Pro Display", fontSize: 20),
                          )),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontFamily: "SF Pro Display", fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ).then((value) {
                if (value == 1) Navigator.of(context).pop();
              });
            },
            child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: 50,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
