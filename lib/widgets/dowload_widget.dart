import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key key,
    @required this.downloadFile,
    @required this.imageName,
  }) : super(key: key);

  final dynamic downloadFile;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        downloadFile.addToDeviceStorage(imageName).then((value) {
          if (value == true) {
            print(value);
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Center(
                        child: Text(
                      "Image Downloaded!",
                      style:
                          TextStyle(fontSize: 17, fontFamily: "SF Pro Display"),
                    )),
                  );
                });
          }
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: 50,
        child: Icon(
          Icons.cloud_download,
          color: Colors.white,
        ),
      ),
    );
  }
}
