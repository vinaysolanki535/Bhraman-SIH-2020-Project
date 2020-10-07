

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoList extends StatefulWidget {

  final VideoPlayerController videoPlayerController;
  final Widget placeHolderWidget;
  final bool looping;

  VideoList({
    @override
    this.videoPlayerController,
    this.looping,
    this.placeHolderWidget,
    Key key,
  }):super(key:key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {

  ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chewieController=ChewieController(

        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 3/2,
        allowedScreenSleep: false,
        autoInitialize: true,
        placeholder: widget.placeHolderWidget,
        looping: widget.looping,
        errorBuilder: (context,errorMessage)
        {
          return Text(errorMessage,style: TextStyle(color: Colors.white),);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller:  chewieController,
    );
  }

  @override
  void dispose()
  {
    super.dispose();
    widget.videoPlayerController.dispose();
    chewieController.dispose();
  }


}
