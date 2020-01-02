import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Image URL coming from prev screen
    Map<String, String> args = ModalRoute.of(context).settings.arguments;
    String url = args['url'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              child: PhotoView(
                imageProvider: NetworkImage(url),
                minScale: PhotoViewComputedScale.contained,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
