import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _pickVideo,
          ),
        ],
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height: 400,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1280 / 720,
              child: IjkPlayer(
                controller: controller,
              ),
            ),
            _buildPlayAssetButton(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () async {
          await controller.setNetworkDataSource(
            // 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
            // 'rtmp://172.16.100.245/live1',
            // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
            // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
            // "file:///sdcard/Download/Sample1.mp4",
          );
          print("set data source success");
          controller.play();
        },
      ),
    );
  }

  void _pickVideo() async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.green,
      // the title color and bottom color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 8,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 3,
      // item row count
      textColor: Colors.white,
      // text color
      thumbSize: 160,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: PickType.onlyVideo,
    );

    if (imgList != null && imgList.isNotEmpty) {
      var asset = imgList[0];
      var fileUri = (await asset.file).uri;
      playUri(fileUri.toString());
    }
  }

  void playUri(String uri) async {
    await controller.setNetworkDataSource(uri);
    print("set data source success");
    controller.play();
  }

  _buildPlayAssetButton() {
    return FlatButton(
      child: Text("play sample asset"),
      onPressed: () async {
        await controller.setAssetDataSource("assets/sample1.mp4");
        controller.play();

        Timer.periodic(Duration(seconds: 2), (timer) async {
          var info = await controller.getVideoInfo();
          print("info = $info");

          if (info.progress >= 0.95) {
            timer.cancel();
          }
        });
      },
    );
  }
}
