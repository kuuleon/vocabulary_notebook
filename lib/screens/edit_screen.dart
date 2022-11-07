import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vocabulary_notebook/db/database.dart';
import 'package:vocabulary_notebook/main.dart';
import 'package:vocabulary_notebook/screens/%20word_list_screen.dart';

enum EditStatus { ADD, EDIT }

class EditScreen extends StatefulWidget {
  final Word? word;
  final EditStatus status;

  EditScreen({required this.status, this.word});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  String _titleText = "";

  bool _isQuestionEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _isQuestionEnabled = true;
      _titleText = "新しい単語の追加";
      questionController.text = "";
      answerController.text = "";
    } else {
      _isQuestionEnabled = false;
      _titleText = "登録した単語の修正";
      questionController.text = widget.word!.strQuestion;
      answerController.text = widget.word!.strAnswer;
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backToWordListScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => _onWordRegisterd(),
              icon: Icon(Icons.done_all),
              tooltip: "登録",
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              const Center(
                child: Text(
                  "問題と答えを入力して「登録」ボタンを押してください",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              //問題入力部分
              _questionInputPart(),
              //答え入力部分
              const SizedBox(
                height: 30.0,
              ),
              _answerInputPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            "問題",
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            enabled: _isQuestionEnabled,
            controller: questionController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30.0),
          )
        ],
      ),
    );
  }

  _answerInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            "答え",
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: answerController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30.0),
          )
        ],
      ),
    );
  }

  Future<bool> _backToWordListScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => WordListScreen())));
    return Future.value(false);
  }

  _onWordRegisterd() {
    if (widget.status == EditStatus.ADD) {
      _insertWord();
    } else {
      _updateWord();
    }
  }

  _insertWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Fluttertoast.showToast(
          msg: "登録には問題と答えの両方必要です",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("登録"),
              content: const Text("登録していいですか"),
              actions: [
                TextButton(
                    child: const Text("はい"),
                    onPressed: (() async {
                      var word = Word(
                        strQuestion: questionController.text,
                        strAnswer: answerController.text,
                        isMemorized: false,
                      );

                      try {
                        await database.addWord(word);
                        questionController.clear();
                        answerController.clear();
                        // 登録完了メッセージ
                        Fluttertoast.showToast(
                            msg: "登録が完了しました",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                      } on SqliteException catch (e) {
                        Fluttertoast.showToast(
                            msg: "この問題は既に登録されています",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                      } finally {
                        Navigator.pop(context);
                      }
                    })),
                TextButton(
                    child: const Text("いいえ"),
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }

  void _updateWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Fluttertoast.showToast(
          msg: "登録には問題と答えの両方必要です",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("${questionController.text}の変更"),
              content: const Text("変更してもいいですか"),
              actions: [
                TextButton(
                    child: Text("はい"),
                    onPressed: () async {
                      var word = Word(
                        strQuestion: questionController.text,
                        strAnswer: answerController.text,
                        isMemorized: false,
                      );

                      try {
                        await database.updateWord(word);
                        _backToWordListScreen();
                        Fluttertoast.showToast(
                            msg: "修正が完了しました",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                      } on SqliteException catch (e) {
                        Fluttertoast.showToast(
                            msg: "何らかの問題が発生して登録できませんでした : $e",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                      } finally {
                        Navigator.pop(context);
                      }
                    }),
                TextButton(
                  child: const Text("いいえ"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
