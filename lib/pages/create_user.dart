
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media/widgets/header.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
 final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  final  _scaffoldkey=GlobalKey<ScaffoldState>();

  String? username;
  submitData(){
   final form= formkey.currentState!;
   if(form.validate()) {
     form.save();
   }
   SnackBar snackbar=const SnackBar(content: Text('Wellcome to chat'));
   // ignore: deprecated_member_use
   _scaffoldkey.currentState!.showSnackBar(snackbar);
   Timer(const Duration(seconds: 2),
       (){Navigator.pop(context );});
    Navigator.pop(context,username);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
      appBar: header(context,titleText: 'Create User',removeBackBotton: true),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
          child:   Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Center(child: Text('Create Username',style: TextStyle(
                  fontSize: 25
                ),)),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Form(
                  autovalidateMode: AutovalidateMode.always, key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                    onSaved: (val){username=val;}
                        ,validator: (val){
                      if(val!.trim().length<3||val.isEmpty){
                        return 'username too short';

                      }else if(val.trim().length>12){
                        return "username too long";
                      }else{
                        return null;
                      }
                      }
                        ,decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          hintText: "must be at 3 charactrs"
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: MaterialButton(

                          minWidth: 300,
                            color: Theme.of(context).primaryColor,
                            child: const Text("submit"),
                            onPressed:(){
                          submitData();
                        }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),]
      ),
    );
  }

}
