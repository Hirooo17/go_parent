// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


void click(){

  setState(() {
    
  });
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
          title: Center(child: Text('Go Parent')),
          actions: [
            Padding(padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: click,
              child: Center(
                child: Text('Login'),
              ),
            ),),
            
          ],
      ),
      // navigatioon bar
      bottomNavigationBar: BottomAppBar(child: 
            FloatingActionButton(
              onPressed: (){}),
              shadowColor: Colors.black,
              ),
     
    );
  }



}