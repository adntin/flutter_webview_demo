import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String? title; // 远程访问时, 建议设置此值, 否则需要等onload事件之后才会触发

  const WebViewPage({super.key, required this.url, this.title});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  late String _title;
  late bool remoteUrl; // 是否远程访问
  int remoteProgress = 0; // 远程进度条(0~100)(onload)
  dynamic error;

  @override
  void initState() {
    super.initState();

    RegExp reg = RegExp(r"(http|https):\/\/([\w.]+\/?)\S*");
    remoteUrl = reg.hasMatch(widget.url);
    _title = widget.title ?? '';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print(
                'onProgress: ${DateTime.now().millisecondsSinceEpoch} remoteProgress: $progress');
            if (remoteUrl) {
              setState(() {
                remoteProgress = progress;
              });
            }
          },
          onPageStarted: (String url) async {
            print('onPageStarted: ${DateTime.now().millisecondsSinceEpoch}');
          },
          onPageFinished: (String url) async {
            // 触发时机: flutter.onPageFinished ≈ js.onload
            print('onPageFinished: ${DateTime.now().millisecondsSinceEpoch}');
            _setTitle();
          },
          onWebResourceError: (WebResourceError e) {
            // 远程加载出错  1. 域名错误  2. 弱网超时
            print('onWebResourceError: ${widget.url} ${e.description}');
            setState(() {
              error = e;
            });
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   print(
          //       'onNavigationRequest: ${DateTime.now().millisecondsSinceEpoch}');
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..addJavaScriptChannel(
        'LDSToaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..addJavaScriptChannel(
        'LDSWebView',
        onMessageReceived: (JavaScriptMessage message) {
          late String url;
          String? t;
          if (message.message.contains('{')) {
            Map map = jsonDecode(message.message);
            url = map["url"];
            t = map['title'];
          } else {
            url = message.message;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return WebViewPage(
                url: url,
                title: t,
              );
            }),
          );
        },
      );
    if (remoteUrl) {
      controller.loadRequest(Uri.parse(widget.url)).catchError((e) {
        // 不知道什么时候执行
        print('loadRequest catchError: ${widget.url} ${e.message}');
      });
    } else {
      controller.loadFlutterAsset('assets/www/${widget.url}').catchError((e) {
        // 本地加载出错  1. 路径错误
        print('loadFlutterAsset catchError: ${widget.url} ${e.message}');
        setState(() {
          error = e;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _buildBody(),
    );
  }

  _setTitle() async {
    if (_title.isEmpty) {
      String? t = await controller.getTitle(); // 本地加载资源, 有时为空
      t ??= await controller
          .runJavaScriptReturningResult('window.document.title') as String;
      if (t.isNotEmpty) {
        setState(() {
          _title = t!;
        });
      }
    }
  }

  _buildError() {
    String message = 'Unknown';
    if (error is WebResourceError) {
      message = error.description;
    } else if (error is PlatformException) {
      message = error.message ?? error.details;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.url),
          Text(message.toString()),
        ],
      ),
    );
  }

  _buildBody() {
    if (error != null) {
      return _buildError();
    }
    if (remoteUrl && remoteProgress < 90) {
      return LinearProgressIndicator(value: remoteProgress / 100);
    }
    return WebViewWidget(controller: controller);
  }
}
