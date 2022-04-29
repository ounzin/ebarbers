// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

//
import '../../assets/strings.dart' as strings;
import '../../assets/colors.dart' as colors;

class DefaultPlayer extends StatefulWidget {
  String? title;
  String? url;
  String? description;

  DefaultPlayer(
      {Key? key,
      required this.url,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  _DefaultPlayerState createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.url!,
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary_color,
        title: new Text(
          widget.title!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 3.w),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
              VisibilityDetector(
                key: ObjectKey(flickManager),
                onVisibilityChanged: (visibility) {
                  if (visibility.visibleFraction == 0 && mounted) {
                    flickManager.flickControlManager?.autoPause();
                  } else if (visibility.visibleFraction == 1) {
                    flickManager.flickControlManager?.autoResume();
                  }
                },
                child: Container(
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      controls: FlickPortraitControls(),
                    ),
                    preferredDeviceOrientationFullscreen: [
                      DeviceOrientation.landscapeLeft
                    ],
                    flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      videoFit: BoxFit.contain,
                      controls: FlickLandscapeControls(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
              new Text(
                "Dans cette vidéo :",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
              new Text(widget.description!),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.5.h, 0, 1.5.h),
              ),
            ],
          )),
    );
  }
}
