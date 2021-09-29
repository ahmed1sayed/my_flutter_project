import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media/models/user.dart';
import 'package:media/pages/home.dart';
import 'package:media/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Post extends StatefulWidget {
  late String postId;
  late String ownerid;
  late String username;
  late String location;
  late String description;
  late Map likes;
late String mediaUrl;
 


  Post({Key? key,required this.postId, required this.ownerid,  required this.username, required this.location, 
    required this.description, required this.likes, required this.mediaUrl}) : super(key: key);
factory Post.fromDocoment(DocumentSnapshot doc){
  return Post(
      postId:doc['postid'],
      ownerid:doc['ownerid'],
      mediaUrl:doc['mediaUrl'],
      username:doc['username'],
      location:doc['location'],
      description:doc['description'],
      likes:doc['like'], 
     

  );
}
 int getLikeCount(likes){
  if(likes==null){
    return 0;

  }int count=0;
  likes.forEach((k,val){
    if(val==true){
      count+=1;
    }
  });
  return count;

 }
  @override
  // ignore: no_logic_in_create_state
  _PostState createState() => _PostState(
      postId: this.postId,
    ownerid: this.ownerid,
    username :this.username,
    location :this.location,
    description : this.description,
    likes :this.likes,
    mediaUrl: this.mediaUrl
      ,likeCount:  getLikeCount(this.likes)
  );
}

class _PostState extends State<Post> {
  final String currentuserId = currentUser!.id;
  late String postId;
  late String ownerid;
  late String username;
  late String location;
  late String description;
  late Map likes;
  late String mediaUrl;
  late int likeCount;
  bool isLiked = false;
bool showHeart=false;
  _PostState(
      { required this.postId, required this.ownerid, required this.username, required this.location,
        required this.description, required this.likes, required this.mediaUrl, required this.likeCount});

  buildPostHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: userRef.doc(ownerid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CirculerProgress();
        }
        User user = User.fromDocument(snapshot.requireData);
        return Column(children: [
          ListTile(leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
            title: Text(user.username, style: TextStyle(color: Colors.black),),
            subtitle: Text(location),
            trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: () {
              print('delete==');
            },),
          ),
          Container(
            child: Text(description),
          )

        ],);
      },

    );
  }

  buildPostemage() {
    return Stack(
      alignment: Alignment.center,
      children: [GestureDetector(
        onTap: () {},
        child: CachedNetworkImage(
          imageUrl: mediaUrl,
          fit: BoxFit.cover,
          height: 300,
          width: MediaQuery
              .of(context)
              .size
              .width,

        ),
      ),
      showHeart?
      Animator(
        duration: Duration(microseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween(begin: 0.9,end: 1.4),
        cycles: 0,
        builder: (BuildContext context, AnimatorState<dynamic> animatorState, Widget? child) =>Transform.scale(scale: animatorState.value,
        child:  Icon(Icons.favorite,size: 150,color: Colors.red,),
        ) ,)

      :Text(''),]
    );
  }

  handleLikePost() {
    isLiked = likes[currentuserId] == true;
    if (isLiked) {
      postRef.doc(ownerid).collection('userPost').doc(postId).update(
          {'likes.$currentuserId': false});
      setState(() {
        isLiked = false;
        likeCount -= 1;
        likes[currentuserId] = false;
      });
    } else if (!isLiked) {
      postRef.doc(ownerid).collection('userPost').doc(postId).update(
          {'likes.$currentuserId': true});
      setState(() {
        isLiked = true;
        likeCount += 1;
        likes[currentuserId] = true;
        showHeart=true;
      });
      Timer(const Duration(milliseconds: 400), (){
        setState(() {
          showHeart=false;
        });
        });
    }
  }

  buildPostFooter() {
    return Column(children: [Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          child: Text("$likeCount Likes", style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),),
        )
      ],
    ),
      const Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: GestureDetector(
            onTap: () {
              handleLikePost();
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border, size: 28,
                    color: Colors.pink,),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5), child: Text('Like'),),

              ],
            ),
          )),
          Expanded(child: GestureDetector(
            child: Row(
              children: const [
                Icon(Icons.comment, size: 28, color: Colors.black,),
                Padding(
                  padding: EdgeInsets.only(left: 5), child: Text('Comment'),),

              ],
            ),
          )), Expanded(child: GestureDetector(
            child: Row(
              children: const [
                Icon(Icons.share, size: 28, color: Colors.black,),
                Padding(
                  padding: EdgeInsets.only(left: 5), child: Text('Share'),),

              ],
            ),
          )),
        ],
      )
    ],);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildPostHeader(),
        buildPostemage(),
        buildPostFooter(),

      ],);
  }
}



