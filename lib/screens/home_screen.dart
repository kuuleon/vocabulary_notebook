import 'package:flutter/material.dart';
import 'package:vocabulary_notebook/parts/button_with_icon.dart';

import ' word_list_screen.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isIncludedMemorizedWords = false;

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
          const SizedBox(height: 20.0),
          ButtonWithIcon(
            onPressed: () => startTestScreen(context),
            icon: const Icon(Icons.play_arrow),
            label: "確認テストをする",
            color: Colors.brown,
          ),
          const SizedBox(height: 10.0),
          // ラジオボタン
          // const SizedBox(height: 20.0),
          // _radioButtons(),
          // 切り替えトグル
          const SizedBox(height: 20.0),
          _swich(),
          // 単語一覧を見るボタン
          const SizedBox(height: 20.0),
          ButtonWithIcon(
              onPressed: () => _startWordListScreen(context),
              icon: const Icon(Icons.list),
              label: "単語一覧を見る",
              color: Colors.grey),
          const SizedBox(height: 60.0),
          const Text(
            "created by Shintaro",
            style: TextStyle(fontFamily: "Mont"),
          ),
          const SizedBox(height: 16.0),
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
        children: [
          RadioListTile(
              title: const Text(
                "暗記済みの単語を除外する",
                style: TextStyle(fontSize: 16.0),
              ),
              value: false,
              groupValue: isIncludedMemorizedWords,
              onChanged: (value) => _onRadioSelected(value)),
          RadioListTile(
              title: const Text(
                "暗記済みの単語を含む",
                style: TextStyle(fontSize: 16.0),
              ),
              value: true,
              groupValue: isIncludedMemorizedWords,
              onChanged: (value) => _onRadioSelected(value))
        ],
      ),
    );
  }

  Widget _swich() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SwitchListTile(
        title: const Text("暗記済みの単語を含む"),
        value: isIncludedMemorizedWords,
        onChanged: (value) {
          setState(() {
            isIncludedMemorizedWords = value;
          });
        },
        secondary: const Icon(Icons.sort),
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      isIncludedMemorizedWords = value;
      print("$valueが選ばれたデー");
    });
  }

  _startWordListScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WordListScreen()));
  }

  startTestScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestScreen(
                  isIncludedMemorizedWords: isIncludedMemorizedWords,
                )));
  }
}
