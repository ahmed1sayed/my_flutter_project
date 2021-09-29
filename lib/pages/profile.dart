import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media/models/user.dart';
import 'package:media/pages/edit_profile.dart';
import 'package:media/pages/home.dart';
import 'package:media/widgets/header.dart';
import 'package:media/widgets/post.dart';
import 'package:media/widgets/post_tile.dart';
import 'package:media/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
 late String profileId;

   Profile({Key? key,required this.profileId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final String currentUserId=currentUser!.id;
  String postView='grid';
  bool isLoading=false;
  int postCount=0;
  List<Post>posts=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePost();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,titleText: 'profile'),
      // ignore: avoid_unnecessary_containers
      body:
        ListView(
          children: [
            BuildProfHeader(),

            const Divider(height: 2.0,),
          BuildToggleVew(),
            const Divider(height: 2.0,),
            BuildPostProfile(),


          ],
        )

    );
  }
getProfilePost()async{
    setState(() {
      isLoading=true;

    });
  QuerySnapshot snapshot =await postRef.doc(widget.profileId).collection('userPost').orderBy('timestamp',descending: true).get();
    setState(() {
      isLoading=false;
      postCount=snapshot.docs.length;
       posts=snapshot.docs.map((doc) =>Post.fromDocoment(doc)).toList();

    });
  }
  // ignore: non_constant_identifier_names
  BuildProfHeader() {
    return FutureBuilder<DocumentSnapshot>(
        future: userRef.doc(widget.profileId).get(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return CirculerProgress();
          }
          User user=User.fromDocument(snapshot.requireData);
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                      radius: 40,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            BuildCount('1',postCount.toString()),
                            BuildCount('1','followers'),
                            BuildCount('1','following'),
                          ],
                        ),
                        BuildButton(),
                      ],
                    ))
                  ],
                ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                alignment: Alignment.bottomLeft,
                child: Text(" "+user.displayName,style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 18),),
              ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomLeft,
                  child: Text(" "+user.username,style: const TextStyle(color:Colors.grey,fontWeight:FontWeight.bold,fontSize: 18),),
                )
              ],
            ),
          );
        }
    );
  }

  // ignore: non_constant_identifier_names
  BuildCount(String s, String t) {
    return Column(
      children: [
      Text(s,style: const TextStyle( fontSize: 20,fontWeight: FontWeight.bold),)  ,
        Text(t,style: const TextStyle(color: Colors.grey,fontSize: 16,),)

      ],
    );
  }

  // ignore: non_constant_identifier_names
  BuildButton() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: (){
          editProfileBotton();
        },
        child: Container(
          width: 250,
           height: 30,
          alignment: Alignment.center,
          child: const Text('Edit Profile',style: TextStyle(color: Colors.white),),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor,
        ),
        ),
      ),
    );
  }

  void editProfileBotton() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return EditProfile(currentUserId: currentUserId);
    }));
  }

  // ignore: non_constant_identifier_names
  BuildToggleVew() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(onPressed: ( ){
          setBuildTogglePost('grid');
        }, icon:Icon(Icons.grid_on,color:postView=='grid'?  Theme.of(context).primaryColor:Colors.grey,)),
        IconButton(onPressed: ( ){
          setBuildTogglePost('list');

        }, icon:Icon(Icons.list,color: postView=='list'? Theme.of(context).primaryColor:Colors.grey,)),

      ],);
  }

  void setBuildTogglePost(String viwe) {
    setState(() {
      postView=viwe;
    });
  }

  BuildPostProfile() {
    if(isLoading){
      return CirculerProgress();
    }else if(postView=='grid'){  List<GridTile>gridtile=[];
    for (var post in posts) {
      gridtile.add(GridTile(child: PostTile(post: post,)));
    }
    return  GridView.count(

        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,


      shrinkWrap: true,
      padding: EdgeInsets.zero,

      physics: const ClampingScrollPhysics(),

      children:gridtile,
    );
    }else if(postView=='list'){
      return Column(children:
        posts
      ,);
    }

  }
}
