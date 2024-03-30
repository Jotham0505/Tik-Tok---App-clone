import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/controllers/upload_video_controller.dart';
import 'package:tiktok/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';



class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

late VideoPlayerController controller;
TextEditingController _songController = TextEditingController();
TextEditingController _captionController = TextEditingController();

UploadVideoController uploadVideoController = Get.put(UploadVideoController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,
              child: VideoPlayer(controller),
            ),
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-20,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: TextInputField(
                      controller: _songController,
                      labelText: "Song Name",
                      icon: Icons.music_note,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-20,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: TextInputField(
                      controller: _captionController,
                      labelText: "caption",
                      icon: Icons.closed_caption,
                    ),
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: (){
                      uploadVideoController.uploadVideo(
                        _songController.text,
                        _captionController.text,
                        widget.videoPath,
                      );
                    },
                    child: Text(
                      'Share !',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}