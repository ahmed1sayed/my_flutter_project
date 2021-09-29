
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
  import 'package:media/pages/activity_field.dart';
import 'package:media/pages/profile.dart';
import 'package:media/pages/search.dart';
 import 'package:media/pages/uplode.dart';
import 'package:media/models/user.dart';
import 'create_user.dart';
User ?currentUser;
final Reference storageRef=FirebaseStorage.instance.ref();
final googleSignIn=GoogleSignIn();
 String username ='no user name';
final DateTime timestamp=DateTime.now();
final userRef=FirebaseFirestore.instance.collection('users');
final postRef=FirebaseFirestore.instance.collection('posts');

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   bool isAuth=false;
  PageController pageController=PageController();
  int pageIndex=0;
  onTap(int pageIndex){
    pageController.animateToPage(  pageIndex,
        duration:const Duration(seconds: 2),
      curve: Curves.easeOutCirc
       );
  }
  login(){
    googleSignIn.signIn();
  }
  logout(){
    googleSignIn.signOut();

  }
  // ignore: non_constant_identifier_names
  CreateUserInFirestore()async{
    //===================get current user
    final GoogleSignInAccount? user=googleSignIn.currentUser;
    //===================chick user existing in user table by id
    if (user!=null) {
      DocumentSnapshot doc = await userRef.doc(user.id).get();
      //==================if not existed create page for add username
      if(!doc.exists) {
        username = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => const CreateUser()));
      }
      //=================insert data in table users
      userRef.doc(user.id).set({
        "id": user.id,
        "username":username ,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayname": user.displayName,
        "bio": " ",
        "timestamp": timestamp,
      });
      doc = await userRef.doc(user.id).get();
      currentUser=User.fromDocument(doc);
      // ignore: avoid_print
      print(currentUser!.displayName);
    }

  }
   onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex=pageIndex;
    });
   }
   Widget buildAouth(){
     return Scaffold(

       body: PageView(

         children: [
           // ignore: deprecated_member_use
           RaisedButton(color: Colors.orange,
               child: const Text('logout',style: TextStyle(
             color: Colors.black
           ),),
               onPressed: ( ){logout();
           setState(() {
             isAuth=false;
           });}
           ),
           //  TimeLine(),
           const ActivityField(),
           currentUser!=null? Uplode(currentUser:currentUser!):Container(),
           const Search(),
           currentUser!=null? Profile(profileId: currentUser!.id,):Container(),
         ],
         controller: pageController,

         onPageChanged: onPageChanged,
         physics: const NeverScrollableScrollPhysics(),

       ),
       bottomNavigationBar: CupertinoTabBar(
         activeColor: Theme.of(context).primaryColor,
         onTap: onTap,
         currentIndex: pageIndex,
         items: const [
           BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
           BottomNavigationBarItem(icon: Icon(Icons.notifications_none)),
           BottomNavigationBarItem(icon: Icon(Icons.camera_alt)),
           BottomNavigationBarItem(icon: Icon(Icons.search)),
           BottomNavigationBarItem(icon: Icon(Icons.person)),



         ],
       ),
     );
   }
   Widget buildUnAouth(){
     return Scaffold(

       body: Container(
         color: Theme
             .of(context)
             .primaryColor,
         child: Column(
           children: [
             Container(
               padding: const EdgeInsets.only(top: 50, left: 20, bottom: 30),
               alignment: Alignment.bottomLeft,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: const [
                   SizedBox(height: 15,),

                   Text("log in", style: TextStyle(
                       color: Colors.white,
                       fontSize: 30,
                       fontWeight: FontWeight.bold
                   ),),
                   SizedBox(height: 10,),
                   Text("welcome to appp", style: TextStyle(
                     color: Colors.black, fontSize: 20,
                   ),),
                   SizedBox(height: 15,),

                 ],
               ),

             ),
             Expanded(

                 child: Container(
                   alignment: Alignment.center,
                   decoration: const BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(50.0),
                         topRight: Radius.circular(50.0)),
                   ),

                   child: SingleChildScrollView(
                     child: Column(

                       children: [
                         GestureDetector(
                           onTap: () async{

                            await login();
                             // ignore: avoid_print
                             print("=============================+++++++++++++++===========================================");




                           },
                           child: Container(
                             height: 35,
                             width: 220,
                             margin: const EdgeInsets.only(top: 10),
                             decoration: const BoxDecoration(
                               color: Colors.red,
                               borderRadius: BorderRadius.all(
                                   Radius.circular(15)),
                             ),
                             child: const Center(
                               child: Text('sign in by google', style: TextStyle(
                                   fontSize: 20, color: Colors.white
                               ),),
                             ),
                           ),
                         )
                       ],
                     ),
                   ),
                 ))
           ],
         ),


       ),
     );
   }
   @override
void initState() {
  // TODO: implement initState
  super.initState();
  googleSignIn.onCurrentUserChanged.listen((account)   {
    handleSignIn(account!);
  },onError: (err){
    // ignore: avoid_print
    print("error is $err");
  });
  try{
    googleSignIn.signInSilently(suppressErrors: false).then((account) {

        handleSignIn(account!);

    }).catchError((err){
      // ignore: avoid_print
      print("error on reopen $err");
    });
  }catch(e){
    // ignore: avoid_print
    print('signInSilently error $e');

  }
}

handleSignIn(GoogleSignInAccount account){
     // ignore: unnecessary_null_comparison
     if(account !=null) {
       CreateUserInFirestore();
      setState(() {
        isAuth = true;
      });
    }else{
       setState(() {
         isAuth = false;
       });

     }
  }


  @override
  void dispose() {
    // TODO: implement dispose
  pageController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return isAuth?buildAouth():buildUnAouth();
  }
}
