import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class ContactUsUI extends StatefulWidget {
  const ContactUsUI({super.key, this.cookieManager});

  final PlatformWebViewCookieManager? cookieManager;

  @override
  State<ContactUsUI> createState() => _ContactUsUIState();
}

class _ContactUsUIState extends State<ContactUsUI> {
  late final PlatformWebViewController _controller;
  double _progress = 0;
  @override
  void initState() {
    super.initState();

    _controller = PlatformWebViewController(
      AndroidWebViewControllerCreationParams(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(KColor.scaffold)
      ..setPlatformNavigationDelegate(
        PlatformNavigationDelegate(
          const PlatformNavigationDelegateCreationParams(),
        )
          ..setOnProgress((int progress) {
            setState(() {
              _progress = progress / 100;
            });
          })
          ..setOnPageStarted((String url) {
            debugPrint('Page started loading: $url');
          })
          ..setOnPageFinished((String url) {
            debugPrint('Page finished loading: $url');
          })
          ..setOnHttpError((HttpResponseError error) {
            debugPrint(
              'HTTP error occured on page: ${error.response?.statusCode}',
            );
          })
          ..setOnWebResourceError((WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
  url: ${error.url}
          ''');
          })
          ..setOnNavigationRequest((NavigationRequest request) {
            if (request.url.contains('pub.dev')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          })
          ..setOnUrlChange((UrlChange change) {
            debugPrint('url change to ${change.url}');
          })
          ..setOnHttpAuthRequest((HttpAuthRequest request) {
            debugPrint('Auth Request $request');
          }),
      )
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: 'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      ))
      ..setOnPlatformPermissionRequest(
        (PlatformWebViewPermissionRequest request) {
          debugPrint(
            'requesting permissions for ${request.types.map((WebViewPermissionResourceType type) => type.name)}',
          );
          request.grant();
        },
      )
      ..loadRequest(
        LoadRequestParams(
          uri: Uri.parse(
              "https://tawk.to/chat/679878b03a8427326075abad/1iilpesls"),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label("Chat with us").regular,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: _progress != 1
              ? LinearProgressIndicator(
                  value: _progress,
                )
              : SizedBox(),
        ),
      ),
      body: SafeArea(
        child: PlatformWebViewWidget(
          PlatformWebViewWidgetCreationParams(controller: _controller),
        ).build(context),
      ),
    );
  }
}
