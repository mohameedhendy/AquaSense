import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity/connectivity.dart';

class WebViewContainer extends StatefulWidget {
  final String iframeUrl;

  WebViewContainer({required this.iframeUrl});

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late WebViewController _webViewController;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();

    // Check for internet connectivity when the widget is first loaded
    _checkInternetConnectivity();

    // Listen for changes in internet connectivity
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnectivity();
    });
  }

  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = connectivityResult != ConnectivityResult.none;
    });

    // If internet is restored, reset the WebView
    if (hasInternet) {
      _webViewController.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasInternet) {
      // If there is no internet, display an error message
      return _buildErrorWidget('No internet connection. Please check your connection.');
    }

    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(70, 76, 79, 0.2),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: WebView(
        initialUrl: widget.iframeUrl,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        onPageFinished: (String url) {
          _adjustViewportSettings();
        },
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(70, 76, 79, 0.2),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 50,
            ),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 14, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _adjustViewportSettings() {
    if (hasInternet) {
      _webViewController.evaluateJavascript('''
      var viewport = document.querySelector("meta[name=viewport]");
      if (viewport) {
        viewport.parentNode.removeChild(viewport);
      }
      var newViewport = document.createElement('meta');
      newViewport.name = "viewport";
      newViewport.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no";
      document.getElementsByTagName('head')[0].appendChild(newViewport);
    ''');
    }
  }

}
