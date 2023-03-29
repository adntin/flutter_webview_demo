import 'package:flutter/material.dart';
import 'package:flutter_webview_demo/language_page.dart';
import 'package:flutter_webview_demo/web_view_page.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Me"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("This is Flutter page"),
            ElevatedButton(
              child: const Text("Open Flutter Language Page"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LanguagePage();
                  }),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Open Flutter WebView Page /About"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const WebViewPage(
                      url: "about.html",
                      // title: "About",
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
