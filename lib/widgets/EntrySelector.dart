import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nihongogoin5/persistency/DeutscheLernenDatabaseLessons.dart';

class EntrySelector extends StatefulWidget {
  List<LessonEntry> _entries = [];

  EntrySelector(entries) {
    _entries = entries;
  }

  @override
  _EntrySelectorState createState() => _EntrySelectorState();
}

class _EntrySelectorState extends State<EntrySelector> {
  var HtmlCode = '<h1> h1 Heading Tag</h1>' +
      '<h2> h2 Heading Tag </h2>' +
      '<p> Sample Paragraph Tag </p>' +
      '<img src="https://flutter-examples.com/wp-content/uploads/2019/04/install_thumb.png" alt="Image" width="250" height="150" border="3">';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Selecciona el tema"),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: widget._entries.length * 2,
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider(thickness: 2);
                  /*2*/
                  final index = i ~/ 2;
                  return ListTile(
                    title: Text(widget._entries[index].title),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text(widget._entries[index].title),
                                ),
                                body: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage("assets/background.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: InAppWebView(
                                      initialData: InAppWebViewInitialData(
                                          data: widget._entries[index].html),
                                      initialOptions: InAppWebViewGroupOptions(
                                        crossPlatform: InAppWebViewOptions(
                                            preferredContentMode:
                                                UserPreferredContentMode.MOBILE,
                                            supportZoom: true),
                                      ),
                                    )
                                    /*WebViewPlus(
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated: (controller) {
                                      controller.loadString(widget._entries[index].html);
                                    },
                                  )*/

                                    )))),
                  );
                })));
  }
}
