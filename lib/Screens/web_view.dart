import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebViewScreen extends StatefulWidget {



  final String url;
  WebViewScreen(this.url);
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        
        body: WebView(
          initialUrl: widget.url,
          gestureNavigationEnabled: true,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );

  }
}
