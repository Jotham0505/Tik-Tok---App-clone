
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController{


  /*_compressVideo(String videoPath)async{
    final compressedVideo = await VideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }*/

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    File videoFile = File(videoPath);
    UploadTask uploadTask = ref.putFile(videoFile);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async{
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async{
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
     UploadTask uploadTask = ref.putFile( await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath) async {
   // try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("video $len", videoPath); 

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)["name"],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songname: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)["profilePhoto"],
      );

     await firestore.collection('videos').add(video.toJson());
      Get.back();

    //} catch (e) {
      //Get.snackbar(
        //'Error uploading the video',
        //e.toString(),
      //);
    //}
  }

}
