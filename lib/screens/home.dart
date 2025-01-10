import 'package:boomerang/classes/fcm.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(onPressed: () {
            showForegroundNotification({'fio': "Жмышенко Валерий Альбертович"});
          }, child: Text("Start"))
        ],
      ),
    );
  }
}
