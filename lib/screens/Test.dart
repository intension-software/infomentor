import 'package:flutter/material.dart';
import 'package:infomentor/fetch.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:async';

class Test extends StatefulWidget {
  final String testId;
  final Function overlay;

  const Test({Key? key, required this.testId, required this.overlay})
      : super(key: key);

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
  bool _disposed = false;

  Future<void> fetchQuestionData(int index) async {
    try {
      FetchResult result = await fetchTests(widget.testId, index);

      if (_disposed) return; // Check if the widget has been disposed

      setState(() {
        answers = result.documentData?.answers;
        answersImage = result.documentData?.answersImage;
        correct = result.documentData?.correct;
        definition = result.documentData?.definition;
        image = result.documentData?.image;
        question = result.documentData?.question;
        subQuestion = result.documentData?.subQuestion;
        title = result.documentData?.title;
        documentCount = result.documentCount;
      });
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuestionData(q);
  }

  @override
  void didUpdateWidget(Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.testId != oldWidget.testId) {
      // Test ID has changed, reset the state and fetch new data
      setState(() {
        q = 0;
        score = 0;
        _answer = null;
      });
      fetchQuestionData(q);
    }
  }

  void onNextButtonPressed() {
    if (q + 1 < (documentCount ?? 0) && _answer != null) {
      setState(() {
        if (_answer == correct) score++;
        print(score);
        _answer = null;
        q++;
      });
      fetchQuestionData(q);
    } else if (q + 1 >= (documentCount ?? 0) && _answer != null) {
      if (_answer == correct) score++;
      widget.overlay();
      _answer = null;

      setState(() {
        q = 0;
        score = 0;
      });

      fetchQuestionData(q);
    }
  }

  @override
  void dispose() {
    _disposed = true; // Set the disposed flag to true
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(title ?? ''),
          if (image != null && image!.isNotEmpty && image != "")
            image!.isEmpty
                ? Container() // Placeholder for empty image field
                : Image.asset(
                    image!,
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
                if (answersImage != null && index < answersImage!.length) {
                  String? item = answersImage?[index];
                  return Container(
                    margin: EdgeInsets.all(8),
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
                        if (item != null && item.isNotEmpty)
                          Image.asset(
                            item,
                            fit: BoxFit.cover,
                          ),
                        ListTile(
                          title: Text('Obrázok ${index + 1}'),
                          leading: Radio(
                            value: index,
                            groupValue: _answer,
                            fillColor:
                                MaterialStateProperty.all<Color>(Color(0xff4b4fb3)),
                            onChanged: (int? value) {
                              setState(() {
                                _answer = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (answers != null &&
                    index - (answersImage?.length ?? 0) < answers!.length) {
                  String? item =
                      answers?[(index - (answersImage?.length ?? 0))];
                  return Container(
                    margin: EdgeInsets.all(8),
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
                            MaterialStateProperty.all<Color>(Color(0xff4b4fb3)),
                        onChanged: (int? value) {
                          setState(() {
                            _answer = value;
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  return Container(); // Placeholder for empty answer fields
                }
              },
            ),
          ),
          reButton(
            context,
            'HOTOVO',
            0xff3cad9a,
            0xffffffff,
            0xffffffff,
            onNextButtonPressed,
          ),
        ],
      ),
    );
  }
}
