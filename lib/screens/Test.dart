import 'package:infomentor/fetch.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int? _answer;
  int score = 0;
  int q = 0;
  List<String>? answers;
  List<String>? answersImage;
  int? correct;
  String? definition;
  String? image;
  String? question;
  String? subQuestion;
  String? title;
  int? documentCount;

  @override
  void initState() {
    super.initState();
    fetchTests("0", q.toString()).then((FetchResult result) {
      if (result.documentData != null) {
        setState(() {
          answers = result.documentData!.answers;
          answersImage = result.documentData!.answersImage;
          correct = result.documentData!.correct;
          definition = result.documentData!.definition;
          image = result.documentData!.image;
          question = result.documentData!.question;
          subQuestion = result.documentData!.subQuestion;
          title = result.documentData!.title;
          documentCount = result.documentCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(title ?? ''),
          image == '' ? Container() : Image.asset(
            image ?? '',
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 32, 8, 32),
            child: Text(definition ?? ''),
          ),
          Text(question ?? ''),
          Text(subQuestion ?? ''),
          Expanded(
            child: ListView.builder(
              itemCount: (answersImage?.length ?? 0) + (answers?.length ?? 0),
              itemBuilder: (BuildContext context, index) {
                if (index < (answersImage?.length ?? 0)) {
                  String? item = answersImage?[index];
                  return Container(
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: _answer == index
                          ? Border.all(color: Color(0xff4b4fb3))
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: _answer == index
                          ? Color(0xffdddef4)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          item ?? '',
                          fit: BoxFit.cover,
                        ),
                        ListTile(
                          title: Text('Obrázok ${index + 1}'),
                          leading: Radio(
                            value: index,
                            groupValue: _answer,
                            fillColor:
                                MaterialStatePropertyAll<Color>(Color(0xff4b4fb3)),
                            onChanged: (int? value) {
                              setState(() {
                                _answer = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  String? item = answers?[(index - (answersImage?.length ?? 0))];

                  return Container(
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: _answer == index
                          ? Border.all(color: Color(0xff4b4fb3))
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: _answer == index
                          ? Color(0xffdddef4)
                          : Colors.white,
                    ),
                    child: ListTile(
                      title: Text(item ?? ''),
                      leading: Radio(
                        value: index,
                        groupValue: _answer,
                        fillColor:
                            MaterialStatePropertyAll<Color>(Color(0xff4b4fb3)),
                        onChanged: (int? value) {
                          setState(() {
                            _answer = value;
                          });
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          reButton(context, 'HOTOVO', 0xff3cad9a, 0xffffffff, 0xffffffff, () {
            if (q + 1 < (documentCount ?? 0) && _answer != null) {
              setState(() {
                q++;
                if (_answer == correct) score++;
                print(score);
                _answer = null;
              });
              fetchTests("0", q.toString()).then((FetchResult result) {
                if (result.documentData != null) {
                  setState(() {
                    answers = result.documentData!.answers;
                    answersImage = result.documentData!.answersImage;
                    correct = result.documentData!.correct;
                    definition = result.documentData!.definition;
                    image = result.documentData!.image;
                    question = result.documentData!.question;
                    subQuestion = result.documentData!.subQuestion;
                    title = result.documentData!.title;
                    documentCount = result.documentCount;
                  });
                }
              });
            }
          })
        ],
      ),
    );
  }
}
