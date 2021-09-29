import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media/models/user.dart';
import 'package:media/pages/home.dart';
import 'package:media/widgets/progress.dart';
class EditProfile extends StatefulWidget {
  late String currentUserId;

  EditProfile({Key? key,required this.currentUserId}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _validBio=true;
  bool _validDisplayName=true;


  TextEditingController controllerDisplayName=TextEditingController();
  TextEditingController controllerBio=TextEditingController();

  User ?user;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();


  }
  getUser()async{
    setState(() {
      isLoading=true;
    });
    DocumentSnapshot doc=await userRef.doc(widget.currentUserId).get();
    user=User.fromDocument(doc);
    controllerDisplayName.text=user!.displayName;
    controllerBio.text=user!.bio;

    setState(() {
      // controllerDisplayName.clear();
      // controllerBio.clear();
   isLoading=false;
 });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [IconButton(onPressed: ( ){
          Navigator.pop(context);
        }, icon: const Icon(Icons.done))],
        title: const Text('Edit Profile'),
      ), body: isLoading?CirculerProgress():
      ListView(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),

                child: CircleAvatar(
                  radius: 50,
                backgroundImage: CachedNetworkImageProvider(user!.photoUrl),

                ),
              ),
              TextFieldDisplayName(),
              TextFieldBio(),
Padding(padding: const EdgeInsets.all(10),
// ignore: deprecated_member_use
child: RaisedButton(
  onPressed: (){ updateProfileDate();},
  child: Text('Update Profile',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
),
),
              Padding(padding: const EdgeInsets.all(10),
                // ignore: deprecated_member_use
                child: FlatButton.icon(
                  icon: const Icon(Icons.cancel,color: Colors.red,),
                  onPressed: (){_logoutAccount();},
label: const Text('logout',style: TextStyle(color: Colors.red,fontSize: 20),),                ),
              ),

            ],
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  TextFieldDisplayName() {
    return Container(
      padding: const EdgeInsets.all(20),

      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding:EdgeInsets.only(top: 10),
          child: Text('Display Name',style: TextStyle(color: Colors.grey),),

          ),
          TextField(

            controller: controllerDisplayName,
            decoration:  InputDecoration(
              hintText: 'update Display Name',

              errorText:
                _validDisplayName ? null : ' Display Name too short'
              ,

            ),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  TextFieldBio() {
    return Container(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding:EdgeInsets.only(top: 10),
            child: Text('Bio',style: TextStyle(color: Colors.grey),),

          ),
          TextField(

          controller: controllerBio,
            decoration:  InputDecoration(
                hintText: 'update Bio',
              errorText: _validBio?null:'Bio too long',
            ),
          )
        ],
      ),
    );
  }
  updateProfileDate(){
        setState(() {
          controllerDisplayName.text.trim().length < 3 ||
              controllerDisplayName.text.isEmpty
              ? _validDisplayName = false
              : true;
          controllerBio.text.trim().length > 100 ||
              controllerBio.text.isEmpty
              ? _validBio = false
              : true;
          if(_validBio&&_validDisplayName){
            userRef.doc(widget.currentUserId).update({
              "displayname":controllerDisplayName.text,
              "bio":controllerBio.text,
            });
          }
        });
  }

  void _logoutAccount()async {
    await googleSignIn.signOut();
    Navigator.push(context,MaterialPageRoute(builder: (context){return const Home();}));
  }
}
