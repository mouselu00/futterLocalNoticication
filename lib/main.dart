import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterLocalNotificationsPlugin fltrNotification;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _initalNotification() {
    // 初始化Android的設定（通知的 ICON.png/xml ，需要在 android>app>src>main>res>drawable 中）
    const androidInitilize = AndroidInitializationSettings("notification_icon");
    // 初始化IOS的設定
    const isoInitilize = IOSInitializationSettings();
    // 設置初始化
    const initizationSetting =
        InitializationSettings(androidInitilize, isoInitilize);
    // Flutter 通知插件
    fltrNotification = FlutterLocalNotificationsPlugin();
    // 設置 Flutter 通知插件的初始化設定
    fltrNotification.initialize(initizationSetting,
        onSelectNotification: _notificationSelected);
  }

  Future _notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future _showNotify() async {
    // Android 的通知詳細(頻道，頻道名稱，頻道說明)
    const androidDetial = AndroidNotificationDetails('ch01', '頻道名稱', '頻道說明');
    // IOS 的通知詳細
    const iosDetial = IOSNotificationDetails();
    // 產出通知的設定
    const generalNotification = NotificationDetails(androidDetial, iosDetial);

    // 顯示通知
    await fltrNotification.show(2, '通知標題', '通知內容..測試', generalNotification,
        payload: '這是即時通知');
  }

  Future _showScheduledNotify() async {
    // Android 的通知詳細(頻道，頻道名稱，頻道說明)
    const androidDetial = AndroidNotificationDetails('ch01', '頻道名稱', '頻道說明');
    // IOS 的通知詳細
    const iosDetial = IOSNotificationDetails();
    // 產出通知的設定
    const generalNotification = NotificationDetails(androidDetial, iosDetial);

    // 設定顯示通知時程
    var scheduledTime = DateTime.now().add(Duration(seconds: 10));
    await fltrNotification.schedule(
        3, '通知標題', '通知內容..測試', scheduledTime, generalNotification,
        payload: '這是時程通知');
  }

  @override
  void initState() {
    _initalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              onPressed: _showNotify,
              child: Text("即時通知"),
            ),
            RaisedButton(
              onPressed: _showScheduledNotify,
              child: Text("10秒後通知"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
