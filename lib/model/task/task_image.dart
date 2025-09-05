import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class TaskImage extends StatefulWidget {
  final Map<String, dynamic> file;

  const TaskImage({
    super.key,
    required this.file,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<TaskImage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.file['fileName']),
      ),
      body: PinchZoom(
        child: Image.network(widget.file['fileUrl']),
        maxScale: 2.5,
        onZoomStart: () {
          print('Start zooming');
        },
        onZoomEnd: () {
          print('Stop zooming');
        },
      ),
    );
  }
}
