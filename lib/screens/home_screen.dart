import 'package:flutter/material.dart';
import 'package:vocabulary_notebook/parts/button_with_icon.dart';

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
          const Divider(
            height: 30.0,
            indent: 10.0,
            endIndent: 10.0,
            color: Colors.white,
            thickness: 1.0,
          ),
          // 確認テストをするボタン
          ButtonWithIcon(
            onPressed: () => print("確認テスト"), //TODO
            icon: const Icon(Icons.play_arrow),
            label: "確認テストをする",
            color: Colors.brown,
          ),
          // TODO ラジオボタン
          _radioButtons(),
          // TODO 単語一覧を見るボタン
          ButtonWithIcon(
              onPressed: () => print("単語一覧"),
              icon: const Icon(Icons.list),
              label: "単語一覧を見る",
              color: Colors.grey),
          const Text(
            "created by Shintaro",
            style: TextStyle(fontFamily: "Mont"),
          )
        ],
      )),
    );
  }

  _titleText() {
    return Column(
      children: const [
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

  Widget _radioButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        children: const [
          RadioListTile(
              title: Text(
                "暗記済みの単語を除外する",
                style: TextStyle(fontSize: 16.0),
              ),
              value: null,
              groupValue: null,
              onChanged: null),
          RadioListTile(
              title: Text(
                "暗記済みの単語を含む",
                style: TextStyle(fontSize: 16.0),
              ),
              value: null,
              groupValue: null,
              onChanged: null)
        ],
      ),
    );
  }
}
