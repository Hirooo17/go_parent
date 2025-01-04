import 'package:flutter/material.dart';
import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MissionList extends StatelessWidget {
  final MissionHelper missionHelper;

  MissionList(this.missionHelper);

  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Mission ${index + 1}'),
          subtitle: Text('Mission ${index + 1} description'),
          trailing: Icon(Icons.check_circle),
        );
      },
    );


  }
}
