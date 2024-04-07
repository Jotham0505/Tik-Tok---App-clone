
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/models/comment.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {

  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;
  
  String _postId = "";

  updatePostId(String id){
    _postId = id;
    getComment();
  }


  postComment(String commentText) async{

    try {
       if (commentText.isNotEmpty) {
      DocumentSnapshot userdoc = await firestore.collection('users').doc(authController.user.uid).get();
      var allDocs = await firestore.collection('videos').doc(_postId).collection('comments').get();
      int len = allDocs.docs.length;

      Comment comment = Comment(
          username: (userdoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userdoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len');

          await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc('Comment $len')
          .set(
            comment.toJson(),
          );

          DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update(
            {'commentCount': (doc.data()! as dynamic)['commentCount'] + 1});

          

            
      }
    } catch (e) {
      Get.snackbar("error while Commenting", e.toString());
    }
   
    
  }

  getComment() async {
    _comments.bindStream(firestore.collection('videos').doc(_postId).collection('comments').snapshots().map((QuerySnapshot query) {
      List<Comment> retVal = [];
      for(var element in query.docs){
        retVal.add(Comment.fromSnap(element));
      }
      return retVal;
    }));
  }


  likeComment(String id) async{
    var uid =authController.user.uid;
    DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).collection('comments').doc(id).get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    }else{
      await firestore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
