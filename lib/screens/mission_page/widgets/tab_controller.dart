import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TabControllerWidget extends StatelessWidget {
  final List<Map<String, dynamic>> missions;
  final List<XFile?> images;
  final Function(int) onImagePicked;
  final Function(int) onComplete;

  TabControllerWidget({
    required this.missions,
    required this.images,
    required this.onImagePicked,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: missions.length,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.teal,
          title: const Text('Go Missions'),
          bottom: TabBar(
            tabs: missions.map((mission) => Tab(text: mission['title'])).toList(),
          ),
        ),
        body: TabBarView(
          children: missions.map((mission) {
            int index = missions.indexOf(mission);
            return MissionTab(
              mission: mission,
              image: images[index],
              onImagePicked: () => onImagePicked(index),
              onComplete: () => onComplete(index),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MissionTab extends StatelessWidget {
  final Map<String, dynamic> mission;
  final XFile? image;
  final VoidCallback onImagePicked;
  final VoidCallback onComplete;

  MissionTab({
    required this.mission,
    required this.image,
    required this.onImagePicked,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                mission['isCompleted'] && image != null
                    ? Icons.verified
                    : Icons.circle_outlined,
                color: mission['isCompleted'] && image != null
                    ? Colors.green
                    : Colors.grey,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mission['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mission['content'],
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: !mission['isCompleted'] ? onComplete : null,
                icon: const Icon(Icons.done),
                label: Text(
                  mission['isCompleted'] ? 'Completed' : 'Complete',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onImagePicked,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Submit Photo'),
              ),
            ],
          ),
          if (image != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(image!.path),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
