// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

void main() {
  WebView.platform = WebWebViewPlatform();
  WebView(
    userAgent:
        "Mozilla/5.0 (X11; Linux i686; rv:100.0) Gecko/20100101 Firefox/100.0",
  );
  runApp(const MaterialApp(home: _WebViewExample()));
}

class _WebViewExample extends StatefulWidget {
  const _WebViewExample({Key? key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<_WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Bank of Baroda Hackathon - Team Infotechies',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            _SampleMenu(_controller.future),
          ],
        ),
      ),
      body: WebView(
        initialUrl: 'https://www.videoindexer.ai/',
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

enum _MenuOptions {
  doPostRequest,
}

class _SampleMenu extends StatelessWidget {
  const _SampleMenu(this.controller);

  final Future<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (_MenuOptions value) {
            switch (value) {
              case _MenuOptions.doPostRequest:
                _onDoPostRequest(controller.data!, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<_MenuOptions>>[
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.doPostRequest,
              child: Text('Post Request'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDoPostRequest(
      WebViewController controller, BuildContext context) async {
    final WebViewRequest request = WebViewRequest(
      uri: Uri.parse('https://httpbin.org/post'),
      method: WebViewRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
    await controller.loadRequest(request);
  }
}
