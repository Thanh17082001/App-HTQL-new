
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPageNetwork extends StatefulWidget {
  final Map<String,dynamic> file;

  const PDFViewerPageNetwork({
    super.key,
    required this.file,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPageNetwork> {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // ignore: no_leading_underscores_for_local_identifiers
   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 131, 123),
          title: Text(widget.file['fileName']),
        ),
        body: SfPdfViewer.network(
        widget.file['fileUrl'],
        key: _pdfViewerKey,
      ),
        
        );
  }
}


