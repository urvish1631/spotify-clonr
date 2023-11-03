import 'package:flutter/material.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditionScreen extends StatefulWidget {
  final bool fromTerms;
  const TermsConditionScreen({Key? key, required this.fromTerms})
      : super(key: key);

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  String termsUrl = "https://admin.sadapp.net/terms-and-conditions";
  String privacyUrl = "https://admin.sadapp.net/privacy-policy";
  String url = "";
  WebViewController controller = WebViewController();

  @override
  void initState() {
    url = widget.fromTerms ? termsUrl : privacyUrl;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(blackColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: controller,
    ).authContainerScaffold(
      context: context,
      isLeadingEnable: true,
      isTitleEnable: true,
      title: widget.fromTerms
          ? Localization.of().termsCondition
          : Localization.of().privacyPolicy,
    );
  }
}
