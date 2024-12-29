// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';

// class MissionList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TaskData>(
//       builder: (context, taskData, child) {
//         return ListView.builder(
//           itemBuilder: (context, index) {
//             final task = taskData.tasks[index];
//             return TaskTile(
//               taskTitle: task.name,
//               isChecked: task.isDone,
//               checkboxCallback: (checkboxState) {
//                 taskData.updateTask(task);
//               },
//               longPressCallback: () {
//                 taskData.deleteTask(task);
//               },
//             );
//           },
//           itemCount: taskData.taskCount,
//         );
//       },
//     );
//   }
// }
