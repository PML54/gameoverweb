import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gamephlplusclass.dart';

import 'package:http/http.dart' as http;

class SqlPhl extends StatefulWidget {
  const SqlPhl({Key? key}) : super(key: key);

  @override
  State<SqlPhl> createState() => _SqlPhlState();
}

class _SqlPhlState extends State<SqlPhl> {
  bool SendSqlState = false;
  bool myBool = false;
  bool feuOrange = true;
  bool readPmlCheckState = false;
  int readPmlCheckError = -1;
  String sqlCommand = "";
  String   thisTable="";
  List<PmlCheck> myTables = []; //  only one Games
  String listAnswSql = "";
  bool getGameUserState = false;
  int getGameUserError = -1;

  bool getMemeUserState = false;
  int getMemeUserError = -1;
  List<Memes> myGuMeme = [];
  bool getGamebyUidState = false;
  int getGamebyUidError = 0;

  bool createMemeState = false;
  int createMemeError = -1;
  int totalSeconds = 0;
  TextEditingController legendeController = TextEditingController();

  String memeLegende = "";
  bool timeOut = false;

  int cestCeluiLa = 0;
  bool getGamebyCodeState = false;
  int getGamebyCodeError = 0;
  bool changeStatusGameUserState = false;
  bool changeStateGameUserState = false;

  Color colorCounter = Colors.green;

  @override
  void dispose() {
    legendeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(actions: <Widget>[
        Expanded(
          child: Row(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: const Text('Exit'),
                  onPressed: () {
                    // createMeme();

                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
        //https://docs.google.com/spreadsheets/d/1IMVfNFiEGc2K8tBjlZBk9ZuuEll44hldB7184YISXBs/edit?usp=sharing
        Expanded(
          child: Row(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: const Text('Copy/Paste'),
                  onPressed: () {
                    {
                      copyClipBoard(listAnswSql);


                  }}),
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[
          getget(),
          getRetour(),
          getListView(),
        ]),
      ),
    ));
  }

  Future sendSQL() async {
    setState(() {
      SendSqlState = false;
    });

    Uri url = Uri.parse(pathPHP + "manSQL.php");

    var data = {
      "MYSQL": sqlCommand,
    };

    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      listAnswSql = response.body;

      // listAnswSql= jsonDecode(response.body) as List;

      //listAnswSql=  jsonDecode(response.body ) ;

      setState(() {
        SendSqlState = true;
      });
    }
  }

  Expanded getget() {
    setState(() {
      legendeController.text = sqlCommand;
      legendeController.selection = TextSelection.fromPosition(
          TextPosition(offset: legendeController.text.length));
    });
    return Expanded(
        child: (Column(
      children: [
        TextField(
          controller: legendeController,
          keyboardType: TextInputType.multiline,
          maxLines: 2,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "SQL",
          ),
          onChanged: (text) {
            setState(() {
              memeLegende = text;
              legendeController.text = memeLegende;
              legendeController.selection = TextSelection.fromPosition(
                  TextPosition(offset: legendeController.text.length));

              sqlCommand = memeLegende;
            });
          },
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                textStyle: const TextStyle(
                    fontSize: 14,
                    backgroundColor: Colors.blue,
                    fontWeight: FontWeight.bold)),
            child: Text('SELECT '),
            onPressed: () {
              setState(() {
        sqlCommand = "SELECT ";
                //  cestCeluiLa++;
              });
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                textStyle: const TextStyle(
                    fontSize: 14,
                    backgroundColor: Colors.blue,
                    fontWeight: FontWeight.bold)),
            child: Text('FROM '),
            onPressed: () {
              setState(() {
                sqlCommand = sqlCommand  + " FROM " + thisTable +";";
              });
            }),

        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                textStyle: const TextStyle(
                    fontSize: 19,
                    backgroundColor: Colors.red,
                    fontWeight: FontWeight.bold)),
            child: Text('LANCER SQL'),
            onPressed: () {
              setState(() {
                sendSQL();
                //  cestCeluiLa++;
              });
            }),
      ],
    )));
  }

  Expanded getListView() {
    var listView = ListView.builder(
        itemCount: myTables.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                    child:
                    Row(
                      children: [
                        Text(  myTables[index].pmltable   +
                            " ->"  ,
                              style: TextStyle(fontSize: 10, color: Colors.blue),),

                    Text(myTables[index].pmlfield  ,style: TextStyle(fontSize:12, color: Colors.red),),
                      ],
                    ),


                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  cestCeluiLa = index;

                  if (SendSqlState ==  true)
                  {
                  sqlCommand ="";
                  SendSqlState = false;
                  } else {
                  sqlCommand = sqlCommand + myTables[index].pmlfield+ ' ,';
                  thisTable=myTables[index].pmltable;
                  }

                });
              });
        });
    return (Expanded(child: listView));
  }

  Widget getRetour() {
    if (!SendSqlState) {
      return (Text("..."));
    }
    return (Expanded(child:

    SingleChildScrollView(
        child: Text(listAnswSql))));
  }

  Future readPmlCheck() async {
    readPmlCheckState = false;
    readPmlCheckError = -1;
    Uri url = Uri.parse(pathPHP + "readPMLCHECK.php");
    var data = {
      "UID": "RIE",
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      readPmlCheckError = 1001;
    }
    if (response.statusCode == 200 && (getMemeUserError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myTables = datamysql.map((xJson) => PmlCheck.fromJson(xJson)).toList();
        readPmlCheckState = true;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    readPmlCheck();
  }

    copyClipBoard(String copire) {
    //  Clipboard.setData(ClipboardData(text: "your text"));
    FlutterClipboard.copy(copire).then((value) => print('copied'));
    }
}
