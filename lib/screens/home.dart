import 'package:boomerang/classes/fcm.dart';
import 'package:boomerang/classes/foreground_service_helper.dart';
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
          ElevatedButton(
              onPressed: () {
                showForegroundNotification(
                  {
                    "fio": "Иванов Иван Иванович",
                    "message":
                        "Хочу играть на Гитаре, нет возможности ее приобрести. Помогите плиз",
                    "timerSeconds": "60",
                    "price": "100",
                    "avatarUrl":
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZwLSGn1si2nIBHPkLh8BhfCYQtwvcE0q0Sg&s"
                  },
                );
              },
              child: Text("Start"))
        ],
      ),
    );
  }
}
