import 'package:flutter/material.dart';
import 'package:flutter_webview_demo/me_page.dart';
import 'package:flutter_webview_demo/web_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter WebView Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Flutter page'),
            ElevatedButton(
              child: const Text("Open Flutter Me Page"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const MePage();
                  }),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Open Flutter WebView Page /AddDevice"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const WebViewPage(
                      url: "addDevice.html",
                      // title: "Add Device",
                    );
                  }),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Open https://www.baidu.com/"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const WebViewPage(
                      url: "https://www.baidu.com/",
                      title: "百度一下",
                    );
                  }),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Open Flutter WebView Page /abc"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const WebViewPage(
                      url: "abc.html",
                      // title: "Add Device",
                    );
                  }),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Open https://www.baidu111.com/"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const WebViewPage(
                      url: "https://www.baidu111.com/",
                      title: "百度一下",
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
