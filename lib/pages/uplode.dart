// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media/models/user.dart';
import 'package:media/pages/home.dart';
import 'package:media/widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart'as im;



class Uplode extends StatefulWidget {
   late User currentUser;



    Uplode({Key? key,required this.currentUser}) : super(key: key);

  @override
  _UplodeState createState() => _UplodeState();
}

class _UplodeState extends State<Uplode> {
  String currentAddress='My Adress';
  late Position currentpossition;
  String postId=const Uuid().v4();
  TextEditingController textPost=TextEditingController();

  TextEditingController textGeolocator=TextEditingController();
  bool isUploading=false;
   File? file;//image from camera and gallery
  handleCamira() async {
    Navigator.pop(context);
   // ignore: deprecated_member_use
   final file=  await ImagePicker().getImage(source: ImageSource.camera,
    maxHeight: 675,maxWidth: 960)
     ;
    setState(() {
      this.file=File(file!.path);
    });
  }
  handleGallery()async{
    Navigator.pop(context);
    // ignore: deprecated_member_use
    final file=  await ImagePicker().getImage(source: ImageSource.gallery,
        maxHeight: 675,maxWidth: 960)
    ;
    setState(() {
      this.file=File(file!.path);
    }); }
    compressedImage()async{
    final tempOir=await getTemporaryDirectory();
    final path=tempOir.path;
    //todo solve file Problem!!============.
    im.Image? imageFile=im.decodeImage(file!.readAsBytesSync())as im.Image;
    final compressImageFile=File('$path/img_$postId.jpg')..writeAsBytesSync(im.encodeJpg(imageFile,quality: 85));
    setState(() {
      file=compressImageFile;
    });
    }
    uploadeImage(imageFile)async{
    UploadTask uploadTask= storageRef.child('post_$postId.jpg').putFile(imageFile);
    TaskSnapshot storageSnap=await uploadTask.catchError(( e){
      // ignore: avoid_print
      print('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+e);
    }) ;
    String downloadeUrl=await storageSnap.ref.getDownloadURL();
    return downloadeUrl;
    }
    createPostFireStore({required String mediaUrl,required String location,required String description})async{
 postRef.doc(widget.currentUser.id).collection("userPost").doc(postId).set({
  "postid":postId,
  "ownerid":widget.currentUser.id,
'username':widget.currentUser.username,
  "mediaUrl":mediaUrl,
  "timestamp":timestamp,
  "location":location,
  "like":[] ,
  "description":description,




});
 DocumentSnapshot doc = await  postRef.doc(widget.currentUser.id).collection("userPost").doc(postId).get();
 // ignore: avoid_print
 print("dddddddddddddddddddddddddddddddddd"+doc.id);
    }
  choseImage(parentcontext){
    return showDialog(context: parentcontext, builder: ( context){
      return SimpleDialog(
        children: [
          SimpleDialogOption(
            child: const Text('Photo with camira'),
            onPressed: (){
              handleCamira();
            },
          ),
          SimpleDialogOption(
            child: const Text('Photo with camira'),
            onPressed: (){
              handleGallery();
            },
          ), SimpleDialogOption(
            child: const Text('Cancel'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      );
    });

  }
  buildSplachScreen(){
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/upload.svg',height: 260,),
          const Padding(padding: EdgeInsets.only(top: 20)),
          // ignore: deprecated_member_use
          RaisedButton(color: Colors.orange,
            child: const Text('uplode image',style: TextStyle(color: Colors.white,fontSize: 20),),
              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: ( ){
            choseImage(context);
              }
          )
        ],
      ),
    );
  }

  handleSubmit()async{
    setState(() {
      isUploading=true;
    });
    await compressedImage();
    String mediaUrl=await uploadeImage(file);
    createPostFireStore(
        mediaUrl: mediaUrl,
        location: textGeolocator.text,
        description: textPost.text
    );

    textGeolocator.clear();
    textPost.clear();
    setState(() {
      isUploading=false;
      postId=const Uuid().v4();
    });

  }
  buildForm(){
    return Scaffold(
      appBar: AppBar(
        actions: [
          // ignore: deprecated_member_use
          FlatButton(onPressed: ()async{
           await handleSubmit();},
          child: const Text('Post',style: TextStyle(
            color: Colors.white,fontSize: 20
          ),),)
        ],
        title: const Text('Uolode post',style:TextStyle(
            color: Colors.white
        ),),
        leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){
          Navigator.pop(context);

        },),
      ),
      body: ListView(
        children: [
          isUploading?LinearProgress():const Text(''),
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width*0.8,
          child: Center(
            child: AspectRatio(aspectRatio: 16/9,
            child: file!=null?Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(file!),
                )
              ),
            ):Container(),),
          ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ListTile(
          leading: CircleAvatar(
            // ignore: unnecessary_null_comparison
            backgroundImage:widget.currentUser!=null? CachedNetworkImageProvider(widget.currentUser.photoUrl):null,
          ),
          title: TextField(
            controller: textPost,
            decoration:const InputDecoration(
              hintText: 'Write here post',
              border: InputBorder.none
            ),
          ),
        ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            leading: const Icon(Icons.pin_drop,color: Colors.orange,size: 35,),
            title: TextField(
              controller: textGeolocator,
              decoration:const InputDecoration(
                  hintText: 'Whare was this taken',
                  border: InputBorder.none
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
Container(
  width: 100,
  padding: const EdgeInsets.all(60),

  // ignore: deprecated_member_use
  child:   RaisedButton.icon(color: Theme.of(context).primaryColor,onPressed: (){_getUserLocation();}, shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30)

  ),label: const Text('Use current location',style: TextStyle(color: Colors.white),),icon: const Icon(Icons.my_location,
  color: Colors.white,),
  ),
)
        ],
      ),
    );
  }
  Future<Position>_getUserLocation()async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      Fluttertoast.showToast(msg: 'please keep your location on');
    }
    permission   = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied) {
      permission=await Geolocator.requestPermission();
   if(permission==LocationPermission.denied){
      Fluttertoast.showToast(msg: 'Location Permission is denied');
   }
    }  if(permission==LocationPermission.deniedForever){
      Fluttertoast.showToast(msg: 'Location Permission is deniedForever');

    }
    Position position=await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try{
      List<Placemark>placemarks=await placemarkFromCoordinates(position.latitude,position.longitude);
      Placemark place=placemarks[0];
      setState(() {
        currentpossition=position;
        currentAddress="${place.locality} ${place.postalCode} ${place.country}";
        textGeolocator.text=currentAddress;
    // ignore: avoid_print
    print('========+++++++++++++ '+currentAddress+' ========+++++++++++++');
      });
    // ignore: avoid_print
    }catch(e){print(e);}  return currentpossition;
  }



  @override
  Widget build(BuildContext context) {
    return file==null? buildSplachScreen():buildForm();
  }
}
