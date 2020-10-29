# 本地通知

## 安裝插件
1. 安裝`flutter_local_notification'插件
```
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^1.4.4+2 
```
2. 執行 `flutter pub get` 下載並且安裝

## 設定`AndroidManifest.xml'
1. 在`<application>`相同階層中添加一下代碼，主要是允許相關需要的權限
```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<application ...></application>
```
2. 在`<activity>`相同階層中添加一下代碼
```
<activity ...></activity>

<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
  <intent-filter>
  <action android:name="android.intent.action.BOOT_COMPLETED"/>
  <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
  <action android:name="android.intent.action.QUICKBOOT_POWERON" />
  <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
  </intent-filter>
</receiver>
```
# 添加圖片資源
1. 選擇`png/xml`格式的icon，用於通知顯示所呈現的圖標
2. 將圖片添加到`android>app>src>main>res>drawable`中，並且命名為"notification_icon"（根據自己的喜好）

## 撰寫代碼
1. 初始化通知設定函數，在頁面`initState()`時候呼叫
```
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
```

2. 執行顯示通知的函數，當要觸發通知顯示是調用
```
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

Future _notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
}
```

3. 按鈕觸發
```
RaisedButton(
  onPressed: _showNotify,
  child: Text("即時通知"),
),
RaisedButton(
  onPressed: _showScheduledNotify,
  child: Text("10秒後通知"),
)
```

## 參考來源
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Youtube:Flutter Local Notifications, Instant and Scheduled Offline Notifications in Flutter](https://www.youtube.com/watch?v=U38FJ40cEAE)
- [Blog:Flutter Local Notification, Realtime And Scheduled Push Notification For Offline Devices](https://desiprogrammer.com/blogs/flutter-local-push-notifications)



