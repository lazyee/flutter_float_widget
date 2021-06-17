import 'package:flutter/material.dart';
import 'package:flutter_float_widget/float_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Package Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FloatWidgetDemo(),
    );
  }
}

class FloatWidgetDemo extends StatefulWidget {
  FloatWidgetDemo({Key? key}) : super(key: key);

  @override
  _FloatWidgetDemoState createState() => _FloatWidgetDemoState();
}

class _FloatWidgetDemoState extends State<FloatWidgetDemo> {
  Widget _getFloatView() {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              color: Color(0x60000000),
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(25)),
      child: Icon(Icons.ac_unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("悬浮贴边控件"),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Container(
            width: 250,
            height: 250,
            child: FloatWidget(
                postion: FloatWidgetPostion.bottomRight,
                child: Container(
                  color: Colors.green,
                ),
                floatChild: _getFloatView()),
          )),
    );
  }
}
