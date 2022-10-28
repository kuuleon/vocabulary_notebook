import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: Image.asset("assets/images/image_title.png")),
          _titleText(),
          // TODO 横線
          // TODO 確認テストをするボタン
          // TODO ラジオボタン
          // TODO 単語一覧を見るボタン
          Text(
            "created by Shintaro",
            style: TextStyle(fontFamily: "Mont"),
          )
        ],
      )),
    );
  }

  _titleText() {
    return Column(
      children: [
        Text(
          "私だけの単語帳",
          style: TextStyle(fontSize: 40.0),
        ),
        Text(
          "My Own Frashcard",
          style: TextStyle(fontSize: 24.0, fontFamily: "Mont"),
        ),
      ],
    );
  }
}
