import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_size_example/widget/button_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Widget Size & Position';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primaryColor: Colors.blue),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final keyText = GlobalKey();
  Size size;
  Offset position;

  @override
  void initState() {
    super.initState();

    calculateSizeAndPosition();
  }

  void calculateSizeAndPosition() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox box = keyText.currentContext.findRenderObject();

        setState(() {
          position = box.localToGlobal(Offset.zero);
          size = box.size;
        });
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildText(),
              const SizedBox(height: 32),
              ButtonWidget(
                text: 'Calculate',
                onClicked: calculateSizeAndPosition,
              ),
              const SizedBox(height: 32),
              buildResult(),
            ],
          ),
        ),
      );

  Widget buildText() => Text(
        'What is my Widget Size & Position?',
        key: keyText,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );

  Widget buildResult() {
    if (size == null || position == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Width: ${size.width.toInt()}',
          style: TextStyle(fontSize: 32),
        ),
        Text(
          'Height: ${size.height.toInt()}',
          style: TextStyle(fontSize: 32),
        ),
        Text(
          'X: ${position.dx.toInt()}',
          style: TextStyle(fontSize: 32),
        ),
        Text(
          'Y: ${position.dy.toInt()}',
          style: TextStyle(fontSize: 32),
        ),
      ],
    );
  }
}
