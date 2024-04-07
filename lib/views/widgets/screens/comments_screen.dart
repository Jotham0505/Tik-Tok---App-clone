import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/controllers/comment_controller.dart';

class commentScreen extends StatelessWidget {
  final String id;
  commentScreen({super.key, required this.id, });
  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);
    return Scaffold(
       body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                   () {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder:(context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage('profile photo'),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'username',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              Text(
                                'Comment description',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '10 likes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white
                                ),
                              )
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () {
                              
                            },
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              ),
              Divider(), // Divides the page 
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red
                      )
                    )
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    commentController.postComment(_commentController.text);
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
       )
    );
  }
}