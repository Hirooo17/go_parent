import 'package:flutter/material.dart';

class TabControllerWidget extends StatelessWidget {
  const TabControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.teal,
          title: const Text('Go Missions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mission1'),
              Tab(text: 'Missions2'),
              Tab(text: 'Missions3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Text('All Missions'),
            Text('Completed Missions'),
            Text('Incomplete Missions'),
          ],
        ),
      ),
    );
  }
}
