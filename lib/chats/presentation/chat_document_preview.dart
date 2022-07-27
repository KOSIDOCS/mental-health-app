import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ChatDocumentPreview extends StatelessWidget {
  final String documentUrl;
  const ChatDocumentPreview({Key? key, required this.documentUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            PDF().cachedFromUrl(
              documentUrl,
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            ),
            BackButton(),
          ],
        ),
      ),
    );
  }
}
