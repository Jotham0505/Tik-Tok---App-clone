import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/controllers/video_controller.dart';
import 'package:tiktok/views/widgets/circle_animation.dart';
import 'package:tiktok/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(
                    profilePhoto,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }



  buildMusicAlbum(String profilePhoto){
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Colors.white]
              ),
              borderRadius: BorderRadius.circular(25)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
          return PageView.builder(
            itemCount: videoController.videoList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data =  videoController.videoList[index];
              return Stack(
                children: [
                  VideoPlayerItem(
                  videoUrl: data.videoUrl,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      data.username,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data.caption,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.music_note,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          data.songname,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfile(data.profilePhoto),
                                  Column(
                                    children: [
                                      InkWell(
                                        child: Icon(
                                          Icons.favorite,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        data.likes.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                       InkWell(
                                        child: Icon(
                                          Icons.comment,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        data.commentCount.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                       InkWell(
                                        child: Icon(
                                          Icons.reply,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                  CircleAnimation(child: buildMusicAlbum(data.profilePhoto),),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          );
        }
      ),
    );
  }
}