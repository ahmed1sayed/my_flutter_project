import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media/models/user.dart';
import 'package:media/pages/home.dart';
import 'package:media/widgets/progress.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController textSearch=TextEditingController();
  clearSearch(){
    textSearch.clear();

  }

   Future<QuerySnapshot>?searchResult;
  handleSearch(value) {
    Future<QuerySnapshot>users=
    userRef.where('username',isGreaterThanOrEqualTo: value).get();
    setState(() {
      searchResult=users;
    });
  }
  AppBar buildSearchedField(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          controller: textSearch,
          onFieldSubmitted: (value){
            handleSearch(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'search for a user',
            prefixIcon: const Icon(Icons.account_box),
            suffixIcon: IconButton(icon: const Icon(Icons.clear),
            onPressed: (){
              clearSearch();
            },
            )
          ),
        ),
      ),
    );
  }
  Container buildNoContent(){
    final Orientation orientation=MediaQuery.of(context).orientation;
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset('assets/images/search.svg',

              height: orientation==Orientation.portrait?300:200,
            ),
            const Text('Fiend users',style: TextStyle(color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,fontSize: 50),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
  buildResultSearch(){
    return FutureBuilder<QuerySnapshot>(
        future: searchResult,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return CirculerProgress();
          }
         List<userResult>searchdata=[];
          for (var doc in snapshot.requireData.docs) {
            User user=User.fromDocument(doc);

            searchdata.add( userResult(   user: user,));
          }
          return ListView(
            children: searchdata
            ,
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar:  buildSearchedField(),
    body:searchResult!=null?buildResultSearch(): buildNoContent(),
    );
  }

}
// ignore: camel_case_types
class userResult extends StatelessWidget {
 final User user;

  const userResult({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: (){},
        child: ListTile(title: Text(user.username,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          subtitle: Text(user.displayName,style: const TextStyle(color: Colors.grey, ),) ,
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),

          ),
        ),
      ),
      const Divider()
    ],);
  }
}

