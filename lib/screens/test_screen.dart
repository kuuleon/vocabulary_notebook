import 'package:flutter/material.dart';
import 'package:vocabulary_notebook/main.dart';

import '../db/database.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOW_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final isIncludedMemorizedWords;

  TestScreen({required this.isIncludedMemorizedWords});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _numberOfQuestion = 0;
  String _txtQuestion = "test"; //todo
  String _txtAnswer = "test answer"; //todo
  bool _isMemorized = false;

  bool _isQuestionCardVisble = false;
  bool _isAnswerCardVisible = false;
  bool _isCheckBoxVisble = false;
  bool _isFabVisble = false;

  int _index = 0; //今何問目

  late Word _currentWord;

  List<Word> _testDataList = [];
  TestStatus _testStatus = TestStatus.BEFORE_START;

  @override
  void initState() {
    super.initState();
    _getTestData();
  }

  void _getTestData() async {
    if (widget.isIncludedMemorizedWords) {
      _testDataList = await database.allWords;
    } else {
      _testDataList = await database.allWordsExcludedMemorized;
    }
    _testDataList.shuffle();
    _testStatus = TestStatus.BEFORE_START;
    _index = 0;
    setState(() {
      _isQuestionCardVisble = false;
      _isAnswerCardVisible = false;
      _isCheckBoxVisble = false;
      _isFabVisble = true;
      _numberOfQuestion = _testDataList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isInclude = widget.isIncludedMemorizedWords;
    return Scaffold(
        appBar: AppBar(
          title: Text("確認テスト"),
          centerTitle: true,
        ),
        floatingActionButton: (_isFabVisble && _testDataList.isNotEmpty)
            ? FloatingActionButton(
                onPressed: () => goNextStatus(),
                tooltip: "次に進む", //todo
                child: const Icon(Icons.skip_next),
              )
            : null,
        body: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            _numberOfQuestionsPart(),
            const SizedBox(
              height: 40.0,
            ),
            _questionCardPart(),
            const SizedBox(
              height: 20.0,
            ),
            _answerCardPart(),
            const SizedBox(
              height: 20.0,
            ),
            _isMemorizedCheckPart(),
          ],
        ));
  }

  //todo 残り問題数表示部分
  Widget _numberOfQuestionsPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("残り問題数", style: TextStyle(fontSize: 14.0)),
        const SizedBox(width: 30.0),
        Text(_numberOfQuestion.toString(),
            style: const TextStyle(fontSize: 30.0))
      ],
    );
  }

  //問題カード表示部分
  Widget _questionCardPart() {
    if (_isQuestionCardVisble) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/image_flash_question.png"),
          Text(
            _txtQuestion,
            style: TextStyle(fontSize: 40.0, color: Colors.brown[800]),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  // 答えカード表示部分
  Widget _answerCardPart() {
    if (_isAnswerCardVisible) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/image_flash_answer.png"),
          Text(
            _txtAnswer,
            style: const TextStyle(fontSize: 40.0),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  //暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    if (_isCheckBoxVisble) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: CheckboxListTile(
            title: const Text(
              "暗記済み",
              style: TextStyle(fontSize: 18.0),
            ),
            value: _isMemorized,
            onChanged: (value) {
              setState(() {
                _isMemorized = value!;
              });
            }),
      );
    } else {
      return Container();
    }
  }

  goNextStatus() async {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        _showQuestion();
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOW_ANSWER;
        _showAnswer();
        break;
      case TestStatus.SHOW_ANSWER:
        await _updateMemorizedFlag();
        if (_numberOfQuestion <= 0) {
          _testStatus = TestStatus.FINISHED;
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }

  void _showQuestion() {
    _currentWord = _testDataList[_index];
    setState(() {
      _isQuestionCardVisble = true;
      _isAnswerCardVisible = false;
      _isCheckBoxVisble = false;
      _isFabVisble = true;
      _txtQuestion = _currentWord.strQuestion;
    });
    _numberOfQuestion -= 1;
    _index += 1;
  }

  void _showAnswer() {
    setState(() {
      _isQuestionCardVisble = true;
      _isAnswerCardVisible = true;
      _isCheckBoxVisble = true;
      _isFabVisble = true;
      _txtAnswer = _currentWord.strAnswer;
      _isMemorized = _currentWord.isMemorized;
    });
  }

  Future<void> _updateMemorizedFlag() async {
    var updateWord = Word(
        strQuestion: _currentWord.strQuestion,
        strAnswer: _currentWord.strQuestion,
        isMemorized: _isMemorized);
    await database.updateWord(updateWord);
    print(updateWord.toString());
  }
}
