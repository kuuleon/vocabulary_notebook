import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vocabulary_notebook/main.dart';

import '../db/database.dart';
import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _wordList = [];

  @override
  void initState() {
    super.initState();
    _getAllWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("単語一覧"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => _sortWords(),
              icon: Icon(Icons.sort),
              tooltip: "暗記済みの単語を下になるようにソート",
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNewWord(),
          child: Icon(Icons.add),
          tooltip: "新しい単語の登録",
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _wordListWidget(),
        ) //TODO
        );
  }

  _addNewWord() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EditScreen(
                  status: EditStatus.ADD,
                )));
  }

  void _getAllWords() async {
    _wordList = await database.allWords;
    setState(() {});
  }

  Widget _wordListWidget() {
    return ListView.builder(
        itemCount: _wordList.length,
        itemBuilder: (context, int position) => _wordItem(position));
  }

  Widget _wordItem(int position) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.blueGrey.shade500,
      child: ListTile(
        title: Text("${_wordList[position].strQuestion}"),
        subtitle: Text(
          "${_wordList[position].strAnswer}",
          style: const TextStyle(fontFamily: "Mont"),
        ),
        trailing: (_wordList[position].isMemorized != null &&
                _wordList[position].isMemorized)
            ? const Icon(Icons.check_circle)
            : null,
        onTap: () => _editWord(_wordList[position]),
        onLongPress: () => _deleteWord(_wordList[position]),
      ),
    );
  }

  _deleteWord(Word selectedWord) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text(selectedWord.strQuestion),
              content: const Text("削除してもいいですか"),
              actions: [
                TextButton(
                    onPressed: () async {
                      await database.deleteWord(selectedWord);
                      Fluttertoast.showToast(
                          msg: "削除が完了しました", toastLength: Toast.LENGTH_LONG);
                      _getAllWords();
                      Navigator.pop(context);
                    },
                    child: const Text("はい")),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("いいえ"))
              ],
            ));
  }

  _editWord(Word selectedWord) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EditScreen(
                  status: EditStatus.EDIT,
                  word: selectedWord,
                )));
  }

  _sortWords() async {
    _wordList = await database.allWordsSorted;
    setState(() {});
  }
}
