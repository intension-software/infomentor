
import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

enum Answer { one, two, three, four }

class TestData {

 
  
  int correct = 1;

}

 List answers = [
    'text1',
    'text2',
    'text3',
    'text4',
    'text5',
    'text6',
    'text7',
    'text1',
    'text2',
    'text3',
    'text4',
    'text5',
    'text6',
    'text7'
  ];

    String title = 'Test1';



class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int? _answer;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          
          children: [
            Container(
              margin:  EdgeInsets.fromLTRB(8, 32, 8, 32),
              child: Text(title, )
            ),
            Expanded(
              child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (BuildContext context, index) {
                String item = answers[index];

                return Container(
                    margin:  EdgeInsets.fromLTRB(8, 8, 8, 8),
                    width:  double.infinity,
                    height:  50,
                    decoration: BoxDecoration(
                      border: _answer == index ? Border.all(color: Color(0xff4b4fb3)) : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: _answer == index ? Color(0xffdddef4) : Colors.white,
                      
                    ),
                    child: ListTile(
                      title: Text(item),
                      leading: Radio(
                        value: index ,
                        groupValue: _answer,
                        fillColor: MaterialStatePropertyAll<Color>(Color(0xff4b4fb3)),
                        onChanged: (int? value) {
                          setState(() {
                            _answer = value;
                          });
                        },
                      ),
                    )
                  );
              }),
            ),
            reButton(context, 'HOTOVO',  0xff3cad9a, 0xffffffff, 0xffffffff, () {} )
          ]
        ),
    );
  }
}