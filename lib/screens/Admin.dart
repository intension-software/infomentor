import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/UserForm.dart';
import 'package:infomentor/backend/userController.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Admin extends StatefulWidget {


  Admin({
    Key? key,
  }) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return 
        
          ElevatedButton(onPressed: () {
            createCapitol(
                CapitolsData(
        badge: 'assets/badges/badgeSocial.svg',
        badgeActive: 'assets/badges/badgeSocialActive.svg',
        badgeDis: 'assets/badges/badgeSocialDis.svg',
        color: 'pink',
        name: 'Socialne siete',
        points: 5,
        tests: [
            TestsData(
                introduction: 'Konšpiračné teórie sú často založené na hoaxoch a dezinformáciách, ale tento jav je oveľa komplikovanejší. Nejde o izolované nepravdivé informácie, ale o zložitú spleť pravdivých a nepravdivých informácií. Keď raz niekto uverí konšpiračnej teórii, je veľmi náročné jeho/ju presvedčiť o opaku. Preto je dôležité vedieť rozpoznať konšpiračné stratégie a byť voči nim odolný.',
                name: 'Konšpiračné teórie',
                points: 5,
                questions: [
                    QuestionsData(
                        answers: [
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 0
                            ),
                            CorrectData(
                                correct: 3,
                                index: 1
                            ),
                            CorrectData(
                                correct: 0,
                                index: 2
                            ),
                            CorrectData(
                                correct: 4,
                                index: 3
                            ),
                            CorrectData(
                                correct: 1,
                                index: 4
                            ),
                        ],
                        definition: '',
                        explanation: [
                            
                        ],
                        images: [],
                        division: [],
                        matchmaking: [
                            'Nedôveryhodná platforma na uverejňovanie a šírenie správ, ktoré obsahujú konšpiračné teórie',
                            'Ide o jav, pri ktorom je človek všeobecne skeptický voči autoritám a nedôveruje systému či oficiálnym verziám udalostí',
                            'Tajné sprisahanie skupiny mocných ľudí, ktoré reálne existuje/existovalo. ',
                            'Nedostatočne podložená domnienka o existencii tajnej sprisahaneckej skupiny so zlými úmyslami ',
                            'Osoba, ktorá verejne a profesionálne šíri konšpiračné teórie'
                        ],
                        matches: [
                            'Konšpirácia',
                            'Konšpiračná teória',
                            'Konšpiračné médium',
                            'Konšpiračný teoretik',
                            'Konšpiračné myslenie'
                        ],
                        question: 'Spojte pojem so správnou definíciou',
                        subQuestion: '',
                        title: 'Definície pojmov',
                    ),
                    QuestionsData(
                        answers: [
                            'Konšpiračné teórie sú vždy nepravdivé.',
                            'Každý hoax alebo dezinformácia je súčasťou nejakej väčšej konšpiračnej teórie. ',
                            'Konšpiračné teórie sú založené na domnienke, že nič nie je náhoda a všetko je spolu prepojené',
                            'Konšpiračné teórie sú komplexnejšie ako hoaxy a často svojmu publiku poskytujú ucelený logický systém. ',
                            'Konšpiračné teórie sú vždy podložené dôveryhodnými dôkazmi, preto máme problém s ich vyvracaním.'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 2
                            ),
                            CorrectData(
                                correct: 3,
                                index: 3
                            ),
                        ],
                        definition: '',
                        explanation: [
                            ' Zatiaľ čo hoaxy a dezinformácie sú nepravdivé, konšpiračná teória môže byť pravdivá. Aj keď väčšina konšpiračných teórií sú nepravdivé (napr. že Zem je plochá), občas sa ukáže, že niektoré teórie sú podložené. Problém je, že konšpiračné teórie sú zväčša podložené neoverenými „dôkazmi“ z nedôveryhodných zdrojov.  Konšpiračné teórie sú často založené na hoaxoch a dezinformáciách, ale to neznamená, že každá dezinformácia musí byť súčasťou nejakej konšpiračnej teórie.'
                        ],
                        images: [],
                        division: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Označ všetky pravdivé tvrdenia o konšpiračných teóriách:',
                        subQuestion: '',
                        title: 'Vlastnosti konšpiračných teórií',
                    ),
                    QuestionsData(
                        answers: [
                            'Čierno biele delenie sveta – zjednodušenie reality na dobro verzus zlo',
                            'Odkazovanie na falošné autority – vyjadrenia údajných „expertov“, nedôveryhodné zdroje',
                            'Apel na intuíciu – vyzývanie čitateľov, nech sa „zobudia“ a použijú „zdravý rozum“',
                            'Vyberanie čerešní („cherry-picking“) – zameranie sa na zopár náhodných faktov, ktoré sú skôr výnimky z pravidla',
                            'Hľadanie obetného baránka – vždy je nejaká skupina ľudí, ktorí sú údajne zodpovední za všetko zlo'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            ),
                            CorrectData(
                                correct: 1,
                                index: 1
                            ),
                            CorrectData(
                                correct: 2,
                                index: 2
                            ),
                            CorrectData(
                                correct: 3,
                                index: 3
                            ),
                            CorrectData(
                                correct: 4,
                                index: 4
                            ),
                        ],
                        definition: '',
                        explanation: [
                            'Všetky tieto argumentačné fauly patria medzi najčastejšie manipulatívne stratégie konšpirátorov. Všetky stratégie majú spoločné to, že sa snažia apelovať na emócie čitateľa, vyvolať strach a hnev.'
                        ],
                        images: [],
                        division: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Ktoré z nasledujúcich argumentačných stratégií a naratívov sú často využívané konšpiračnými teoretikmi:',
                        subQuestion: '',
                        title: 'Stratégie konšpirátorov',
                    ),
                    QuestionsData(
                        answers: [
                            'Ide o nepodloženú konšpiračnú teóriu',
                            'Ide o konšpiračnú teóriu, ktorá nie je potvrdená, ale je podložená presvedčivými dôkazmi',
                            'Ide o konšpiráciu, ktorá sa naozaj odohrala'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            ),
                        ],
                        definition: 'Globálne elity plánujú urobiť tzv. Veľký Reset – zvrhnú nepohodlných politikov a nastolia celosvetovú totalitu. Začalo to tak, že tieto elity zorchestrovali pandémiu Covid-19. To im dalo zámienku „resetovať“ ekonomické a politické zriadenie a podmaniť si dianie vo svete pod svoju kontrolu. Za týmto cieľom využívajú aj rôzne technologické inovácie – 5G siete, mikročipy, umelú inteligenciu. Dohodli sa na tom na stretnutí World Economic Forum v lete 2020 a odvtedy postupne vykonávajú tento plán.',
                        explanation: [
                            ' Ide o typický príklad komplexnej konšpiračnej teórie, ktorá vznikla počas pandémie Covid-19. Konšpiračne zmýšľajúci ľudia hľadali nejaké tajné vysvetlenie tejto udalosti, za ktorú by boli zodpovedné „zlé“ globálne elity. Následne boli misinterpretované a prekrútené slová zo samitu Svetového ekonomického fóra 2020 o „Veľkom resete“. Tento pojem mal popisovať plán ekonomických reforiem, avšak konšpirátori z toho vytvorili plán na „zotročenie ľudstva“.'
                        ],
                        images: [],
                        division: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Prečítaj si nasledujúci úryvok textu a urči, či ide o nepodloženú konšpiračnú teóriu:',
                        subQuestion: '',
                        title: 'Over konšpiračnú teóriu 1 – Veľký Reset',
                    ),
                    QuestionsData(
                        answers: [
                            'Ide o nepodloženú konšpiračnú teóriu',
                            'Ide o konšpiračnú teóriu, ktorá nie je potvrdená, ale je podložená presvedčivými dôkazmi',
                            'Ide o konšpiráciu, ktorá sa naozaj odohrala'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 2
                            ),
                        ],
                        definition: 'Vedeli ste, že americká CIA v minulosti robila tajný projekt, v ktorom robila nehumánne experimenty na nevinných ľuďoch? Tento projekt sa nazýval MK-Ultra. Zahŕňal napríklad aj využívanie drogy LSD s cieľom kontrolovať mysle ľudí. Taktiež dávali ľuďom elektrošoky a pokúšali sa ich hypnotizovať. Toto všetko, prosím pekne, robili v USA počas Studenej vojny! Cieľom bolo zneužiť tieto praktiky na špiónoch a vojakoch zo Sovietskeho zväzu.',
                        explanation: [
                            'Napriek tomu, že tieto udalosti znejú neuveriteľne, táto konšpirácia je skutočná. Experimenty sa reálne odohrávali počas studenej vojny v USA. Projekt MK-Ultra bol oficiálne schválený v roku 1953 a oficiálne zastavený v roku 1973. Následne v 1975 vytvoril prezident Ford komisiu, ktorá oficiálne odhalila MK-Ultra, avšak niektoré podrobnosti projektu zostávajú utajené.'
                        ],
                        images: [],
                        division: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Prečítaj si nasledujúci úryvok textu a urči, či ide o nepodloženú konšpiračnú teóriu:',
                        subQuestion: '',
                        title: 'Over konšpiračnú teóriu 2 – MK-Ultra',
                    ),
                ]
            ),
        ],
        weeklyChallenge: 0,
    )
            );
          
          }, child: Text('create'));
      
  }

  Future<void> createCapitol(CapitolsData capitolsData) async {
  try {
    // Create a reference to the 'capitols' collection in Firestore
    CollectionReference capitolsCollection = FirebaseFirestore.instance.collection('capitols');

    // Convert the given CapitolsData into a format that can be saved to Firestore
    Map<String, dynamic> capitolMap = {
      'name': capitolsData.name,
      'color': capitolsData.color,
      'badge': capitolsData.badge,
      'badgeActive': capitolsData.badgeActive,
      'badgeDis': capitolsData.badgeDis,
      'points': capitolsData.points,
      'weeklyChallenge': capitolsData.weeklyChallenge,
      'tests': capitolsData.tests.map((test) => {
        'name': test.name,
        'points': test.points,
        'questions': test.questions.map((question) => {
          'answers': question.answers,
          'answersImage': question.answersImage,
          'matchmaking': question.matchmaking,
          'matches': question.matches,
          'definition': question.definition,
          'explanation': question.explanation,
          'images': question.images,
          'question': question.question,
          'subQuestion': question.subQuestion,
          'title': question.title,
          'correct': question.correct?.map((correct) => {
              'correct': correct.correct,
              'index': correct.index
          }).toList(),
        }).toList(),
      }).toList(),
    };

    // Add the capitol data to Firestore
    await capitolsCollection.doc('6').set(capitolMap);
    print('Capitol created successfully with ID: 6');

  } catch (e) {
    print('Error creating capitol: $e');
    throw Exception('Failed to create capitol');
  }
}

  
}