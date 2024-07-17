import 'package:deteksibuah/views/api_baseurl.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewvidio extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewvidio> {
  String baseUrl = ApiEndpoints.baseUrl;
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebView Example'),
        actions: <Widget>[
          NavigationControls(_controllerFuture),
        ],
      ),
      body: WebView(
        initialUrl: '$baseUrl/realtime',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          setState(() {
            _controller = webViewController;
          });
        },
      ),
    );
  }

  Future<WebViewController?> get _controllerFuture async {
    return _controller;
  }
}

class NavigationControls extends StatelessWidget {
  final Future<WebViewController?> _webViewControllerFuture;

  const NavigationControls(this._webViewControllerFuture);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController?>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController?> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: !webViewReady || controller == null
                  ? null
                  : () => _navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: !webViewReady || controller == null
                  ? null
                  : () => _navigate(context, controller, goBack: false),
            ),
            IconButton(
              icon: Icon(Icons.replay),
              onPressed: !webViewReady || controller == null
                  ? null
                  : () => controller.reload(),
            ),
          ],
        );
      },
    );
  }

  void _navigate(BuildContext context, WebViewController controller,
      {required bool goBack}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      );
    }
  }
}
