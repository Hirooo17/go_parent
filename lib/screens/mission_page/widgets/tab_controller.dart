import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_parent/services/database/local/helpers/missions_helper.dart';
import 'package:go_parent/services/database/local/models/missions_model.dart';
import 'package:go_parent/screens/mission_page/widgets/mission_list.dart';

class TabControllerWidget extends StatefulWidget {

  @override
  _TabControllerWidgetState createState() => _TabControllerWidgetState();
}

class _TabControllerWidgetState extends State<TabControllerWidget> {
  @override
  void initState() {
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.teal,
          title: const Text('Go Missions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Missions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [

            MissionList(),

          ],
        ),
      ),
    );
  }
}
