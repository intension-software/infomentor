import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/UserForm.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Admin extends StatefulWidget {
  final UserData? currentUserData;


  Admin({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
    controller: _pageController,
    onPageChanged: _onPageChanged,
      children: [
        Column(
          children: [
            Container(
            width: 900,
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: AppColors.getColor('mono').darkGrey,
                ),
                onPressed: () => 
                  _onNavigationItemSelected(1),
              ),
          ),
          UserForm(currentUserData: widget.currentUserData,)
          ],
        ),
        Column(
          children: [
            Container(
            width: 900,
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.getColor('mono').darkGrey,
                ),
                onPressed: () => 
                  _onNavigationItemSelected(0),
              ),
          ),
          ElevatedButton(onPressed: () {
            createCapitol(
              CapitolsData(
        badge: 'assets/badges/badgeArg.svg',
        badgeActive: 'assets/badges/badgeArgActive.svg',
        badgeDis: 'assets/badges/badgeArgDis.svg',
        color: 'blue',
        name: 'Argumentácia',
        points: 44,
        tests: [
            TestsData(
                introduction: 'Analýza a tvrdenie nie je to isté... xxx Chem tu mať nejaké holistické prepojenie tvrdenia a analýzy',
                name: 'Analýza a Tvrdenie',
                points: 7,
                questions: [
                    QuestionsData(
                        answers: [
                            'Pravda',
                            'Nepravda'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Tvrdenie má byť čo najjednoduchšie zhrnutie pointy argumentu, ktoré sa prezentuje hneď v jeho úvode. Dôkazy a vysvetlenia prichádzajú až v neskorčích častiach argumentu.',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie je myšlienkové zhrnutie záveru celého argumentu.',
                        subQuestion: '',
                        title: 'Zadanie: Rozhodnite či sú dané tvrdenia o argumentačných tvrdeniach pravdivé alebo nepravdivé.',
                    ),
                    QuestionsData(
                        answers: [
                            'Pravda',
                            'Nepravda'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Tvrdenie má byť čo najjednoduchšie zhrnutie pointy argumentu, ktoré sa prezentuje hneď v jeho úvode. Dôkazy a vysvetlenia prichádzajú až v neskorčích častiach argumentu.',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie by malo obsahovať zložité a odborné termíny, aby pôsobilo viac presvedčivo.',
                        subQuestion: '',
                        title: 'Zadanie: Rozhodnite či sú dané tvrdenia o argumentačných tvrdeniach pravdivé alebo nepravdivé.',
                    ),
                    QuestionsData(
                        answers: [
                            'Pravda',
                            'Nepravda'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Tvrdenie má byť čo najjednoduchšie zhrnutie pointy argumentu, ktoré sa prezentuje hneď v jeho úvode. Dôkazy a vysvetlenia prichádzajú až v neskorčích častiach argumentu.',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie je prezentované hneď v úvode argumentu.',
                        subQuestion: '',
                        title: 'Zadanie: Rozhodnite či sú dané tvrdenia o argumentačných tvrdeniach pravdivé alebo nepravdivé.',
                    ),
                    QuestionsData(
                        answers: [
                            'Pravda',
                            'Nepravda'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Tvrdenie má byť čo najjednoduchšie zhrnutie pointy argumentu, ktoré sa prezentuje hneď v jeho úvode. Dôkazy a vysvetlenia prichádzajú až v neskorčích častiach argumentu.',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie je najdôležitejšia časť argumentu, má preto viacero aspektov a zameriava sa na viacero vecí naraz.',
                        subQuestion: '',
                        title: 'Zadanie: Rozhodnite či sú dané tvrdenia o argumentačných tvrdeniach pravdivé alebo nepravdivé.',
                    ),
                    QuestionsData(
                        answers: [
                            'Pravda',
                            'Nepravda'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Tvrdenie má byť čo najjednoduchšie zhrnutie pointy argumentu, ktoré sa prezentuje hneď v jeho úvode. Dôkazy a vysvetlenia prichádzajú až v neskorčích častiach argumentu.',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie by malo obsahovať všetky dôkazy a podrobnosti podporujúce argument.',
                        subQuestion: '',
                        title: 'Zadanie: Rozhodnite či sú dané tvrdenia o argumentačných tvrdeniach pravdivé alebo nepravdivé.',
                    ),
                    QuestionsData(
                        answers: [
                            'Pravda',
                            'Nepravda'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Tvrdenie má byť čo najjednoduchšie zhrnutie pointy argumentu, ktoré sa prezentuje hneď v jeho úvode. Dôkazy a vysvetlenia prichádzajú až v neskorčích častiach argumentu.',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie by malo byť jednoduché a čo možno najstručnejšie.',
                        subQuestion: '',
                        title: 'Zadanie: Rozhodnite či sú dané tvrdenia o argumentačných tvrdeniach pravdivé alebo nepravdivé.',
                    ),
                    QuestionsData(
                        answers: [
                            'Štúdia z Annals of Internal Medicine z 2014 porovnávala americké domácnosti ktoré vlastnili zbrane s tými, ktoré nevlastnili. Ukázalo sa, že prítomnosť zbrane v domácnosti zdvojnásobila šancu zomrieť na zastrelenie a strojnásobila nebezpečenstvo samovraždy.',
                            'Ľudia by boli v domácnosti bezpečnejší, lebo by mohli zastreliť hocikoho, kto im vadí. Dokázali by si dokonale obrániť svoj dom, keďže zbraň je silnejšia ako slová a efektívnejšia ako polícia.',
                            'Pocit bezpečia a moci, ktorý ľuďom dávajú zbrane, je klamlivý.  V skutočnosti ľudia vlastniaci zbrane čelia väčšiemu nebezpečenstvu. Príčinou je napríklad neopatrnosť a neschopnosť narábať so zbraňami, čo sa prejavuje pri nezaistených zbraniach v domácnosti alebo že sa zbrane dostanú do rúk detí.  To znamená, že pre bežných občanov je nebezpečné vlastniť zbraň. Ak by sme zakázali vlastnenie zbraní, ľudia by si vyberali iné, efektívnejšie spôsoby, ako ochrániť svoje domácnosti.',
                            'Keď si ľudia kúpia zbraň, znamená to, že im záleží na bezpečí. Z toho vyplýva, že pravdepodobne urobia aj iné opatrenia, aby boli vo väčšom bezpečí. Napríklad si kúpia kvalitné zámky na dvere, dajú mreže na okná alebo nainštalujú kamery. Vďaka týmto opatreniam im nikto nebude môcť vykradnúť dom. Ak si spolu so zbraňou kúpia alarm proti zlodejom, bude ich domácnosť úplne bezpečná.'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Toto nie je vysvetlenie, ale pravdepodobne len iná časť argumentu',
                            'Toto vysvetlenie je príliš krátke a nepostačujúce keďže nevieme prečo si autor myslí, že sú zbrane efektívnejšie ako polícia.',
                            'Toto vysvetlenie má jasný príčinno-následkový reťazec.',
                            'argument nesúvisí s témou, takže je irelevantný. Alarmy a kamery si môžu ľudia kúpiť, aj keď nevlastnia zbrane.'
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: '',
                        subQuestion: '',
                        title: 'Téma znie: Držba strelných zbraní pre osobné účely by mala byť zakázaná.  A vaše tvrdenie je: "Zákaz strelných zbraní povedie k vyššej bezpečnosti v domácnostiach." Vyber najsilnejšie vysvetlenie k tvrdeniu.',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: "Časti debatného argumentu",
                points: 6,
                questions: [
                    QuestionsData(
                        answers: [
                            'Tvrdenie',
                            'Vysvetlenie',
                            'Dôkaz'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 0
                            )
                        ],
                        definition: 'Závery výskumu z University of Missouri z roku 2010 potvrdzujú, že základné školy, kde sú zavedené školské uniformy, zaznamenávajú nižší počet incidentov spojených s problémovým správaním svojich žiakov a žiačok ako školy, kde uniformná politika zavedená nie je.',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: "",
                        subQuestion: '',
                        title: 'V tejto úlohe je rozpísaný argument o tom, že by mali byť povinné školské uniformy. Ale jednotlivé časti argumentu sú rozhádzané. Priraď k častiam argumentu ich správne názvy.',
                    ),
                    QuestionsData(
                        answers: [
                            'Tvrdenie',
                            'Vysvetlenie',
                            'Dôkaz'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: 'Nosenie uniformy ovplyvňuje to, ako sa človek vníma a ako sa správa. Rôzne typy uniforiem sú spojené s rôznymi očakávaniami a typmi úloh, ktoré ich nositelia zohrávajú. Pohľad na školskú uniformu prirodzene vyvoláva myšlienku na školské prostredie a vzdelávanie, preto sa v momente jej nasadenia žiak alebo žiačka začína mentálne pripravovať na pobyt v škole a myšlienky na iné prostredie či aktivity ustupujú. Zároveň nosenie školskej uniformy stavia svojho nositeľa do úlohy študenta, ktorá sa spája so zvedavosťou, hľadaním odpovedí na otázky, či nadobúdaním vedomostí. Túto úlohu sa žiaci a žiačky celkom podvedome snažia napĺňať, preto počas vyučovania menej vyrušujú a viac sa sústredia na predmet výučby.',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: "",
                        subQuestion: '',
                        title: 'V tejto úlohe je rozpísaný argument o tom, že by mali byť povinné školské uniformy. Ale jednotlivé časti argumentu sú rozhádzané. Priraď k častiam argumentu ich správne názvy.',
                    ),
                    QuestionsData(
                        answers: [
                            'Tvrdenie',
                            'Vysvetlenie',
                            'Dôkaz'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: 'Žiaci a žiačky základných škôl by mali povinne nosiť školské uniformy, pretože to zlepšuje ich správanie v škole a zvyšuje sústredenie sa na vyučovanie.',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: '',
                        subQuestion: '',
                        title: 'V tejto úlohe je rozpísaný argument o tom, že by mali byť povinné školské uniformy. Ale jednotlivé časti argumentu sú rozhádzané. Priraď k častiam argumentu ich správne názvy.',
                    ),
                    QuestionsData(
                        answers: [
                            'a) V argumente chýba vysvetlenie',
                            'b) V argumente chýba dôkaz',
                            'c) V argumente nič nechýba'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: 'Aktivisti a aktivistky protestujú pred továrňou na spracovanie kuracieho mäsa. Aktivistka na pódiu má megafón a prednáša nasledujúci argument o tom, že konzumácia mäsa je nemorálna. Jesť mäso je nemorálne, lebo kvôli tomu spôsobujeme veľké utrpenie zvieratám. Pozrime sa napríklad na to, ako sa bežne zaobchádza s kurčatami. Každoročne je zavraždených približne 70 miliárd kurčiat. Medzi bežné praktiky sa považuje napríklad odsekávanie zobákov alebo odopieranie prístupu k jedlu, aby znášali viac vajec. Kvôli genetickým úpravám a šľachteniam pre maximalizáciu objemu mäsa až 30% kurčiat nevie poriadne chodiť. A prečo? Len pre naše potešenie. Takéto vedomé a nepotrebné spôsobovanie utrpenia inej cítiacej bytosti je nemorálne. Táto továreň na mäso by mala byť okamžite zatvorená.',
                        explanation: [
                            'Rečníčka poukázala na mnoho nemorálnych praktík, ktoré sa využívajú pri klietkovom chove zvierat. Avšak nikdy nebolo vysvetlené, prečo je takýto prístup tak často používaný. Taktiež nebolo vysvetlené, ako tomu predídeme tým, keď prestaneme jesť mäso.a',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: '',
                        subQuestion: '',
                        title: 'Prečítaj si argument a urči, ktorá časť mu chýba.',
                    ),
                    QuestionsData(
                        answers: [
                            'a) V argumente chýba vysvetlenie',
                            'b) V argumente chýba dôkaz',
                            'c) V argumente nič nechýba'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: ' Nachádzame sa na politologickej konferencii s názvom „Ako zlepšiť demokraciu?“. Prebieha panelová diskusia, kde akademici a akademičky riešia, či by mala byť volebná účasť povinná. Ozve sa akademička, ktorá prednesie nasledujúci argument: Povinná volebná účasť zaručuje, že politici lepšie zastupujú vôľu ľudu. Momentálne po celom svete klesá účasť na voľbách. Ľudia sú apatickí a často sa vôbec nezaujímajú o politiku. To je problematické, lebo čím ďalej tým menšia časť spoločnosti rozhoduje o politickom zložení vlády, ktorá má zastupovať všetkých občanov. To je však takmer nemožné, pokiaľ väčšina občanov ani nevyjadrí svoje preferencie pri volebnej urne. Tým pádom vznikajú nereprezentatívne vlády, ktoré nereflektujú názory občanov. Takže buď zavedieme povinné voľby, alebo sa môžeme rozlúčiť s demokraciou. Keby sa zaviedla povinnosť voliť, tak by výrazne stúpla volebná účasť. A keďže občania by vedeli, že musia ísť voliť, tak by si predtým naštudovali, komu hodia svoj hlas. Po voľbách by vznikla naozaj reprezentatívna vláda s omnoho vyššou legitimitou, lebo by naozaj zastupovala celý ľud. Mať reprezentatívnu vládu je veľmi dôležité, lebo potom je väčšina občanov spokojná. Politici totiž pri vládnutí zohľadňujú záujmy všetkých občanov a snažia sa vyhovieť väčšine. Tým stúpa dôvera v demokraciu.',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: '',
                        subQuestion: '',
                        title: 'Prečítaj si argument a urči, ktorá časť mu chýba.',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: 'Čo je argument (úvod do argumentu)',
                points: 9,
                questions: [
                    QuestionsData(
                        answers: [
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
                        ],
                        definition: '',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [
                            'Tento argument je zväčša krátky a nepodložený dôkazmi. Dokážeme ich robiť intuitívne napríklad pri komunikácii s kamarátmi či rodinou, keď sa ostatných snažíme presvedčiť o správnosti našich záverov.',
                            'Takýto argument je zvyčajne zložený zo súboru premís (teda predpokladov), z ktorých vychádza nejaký záver. Používame ho napríklad pri výrokovej logike.',
                            'Tento typ argumentu musí byť logicky konzistentný, poriadne vysvetlený a podložený dôkazmi. Skladá sa z tvrdenia vysvetlenia a dôkazu. Využívame ho napríklad v debate alebo pri akademických esejách.'
                        ],
                        matches: [
                            'KAŽDODENNÝ ARGUMENT',
                            'FILOZOFICKÝ ARGUMENT',
                            'DEBATNÝ ARGUMENT'
                        ],
                        question: 'Argument je uzavretý myšlienkový celok, ktorým sa snažíme niekoho presvedčiť o správnosti našich záverov.',
                        subQuestion: '',
                        title: 'Argument vyzerá inak v bežnom živote, inak vo filozofii a inak v akademickej debate. Priraďte definície ku pojmom. (design: matchmaking)',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Argument je uzavretý myšlienkový celok, ktorým sa snažíme niekoho presvedčiť o správnosti našich záverov.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Argumenty musíme súdiť  podľa ich kvality a presvedčivosti. Argumenty, ktoré sú vysvetlené do hĺbky, podložené dôkazmi a neobsahujú logické chyby, sú viac valídne ako krátke, povrchné a nepodložené tvrdenia.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Argumenty sú o osobných názoroch, takže všetky argumenty sú rovnako valídne.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Argumenty musia byť štruktúrované a logicky konzistentné.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Argument sa skladá zo štyroch častí – tvrdenie, vysvetlenie a dôkaz. Ak má „argument“ jednu vetu, ide len o tvrdenie. Tvrdením oznámime svoj názor, ale nevysvetlíme ho, tým pádom to nemôžeme považovať za plnohodnotný argumen',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Niekedy stačí na argument jedna veta.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Silný argument je relevantný k téme, o ktorej sa diskutuje.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Nie je dobré, ak je argument rozvláčny, lebo sa stáva, že jeho pointa zanikne. Taktiež by sa nemali časti vysvetlenia opakovať.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Čím rozsiahlejší je argument, tým je silnejší.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            ' Cieľom argumentu je presvedčiť publikum o správnosti vašich názorov. Takže záverom argumentu by mala byť obhajoba istej názorovej pozície.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Argument nemusí mať žiaden záver.',
                        subQuestion: '',
                        title: 'Vyberte, ktoré z týchto tvrdení o debatnom argumente sú pravdivé?',
                    ),
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
                                correct: 0,
                                index: 1
                            ),
                            CorrectData(
                                correct: 1,
                                index: 2
                            ),
                        ],
                        definition: '',
                        explanation: [
                            'Táto odpoveď nie je správna',
                        ],
                        images: [],
                        matchmaking: [
                            'Ide o jednoduché zhrnutie hlavnej myšlienky argumentu. Býva spravidla formulované ako zrozumiteľná a stručná veta, vďaka ktorej si poslucháč už na začiatku argumentu vie predstaviť, kam bude argument smerovať a čo sa bude snažiť dokázať.',
                            'Je to zvyčajne najrozsiahlejšia časť argumentu a to práve preto, že podrobne vysvetľuje jeho logiku. Popisuje príčinnonásledkový reťazec javov, ktoré vedú k záveru. Úlohou tejto časti argumentu je rozvíjať tvrdenie, aby bol argument presvedčivejší. Tvorí sa tak, že si po každom výroku otázku zodpovieme otázku „Prečo?“ (aspoň päťkrát).',
                            'Táto časť argumentu znázorňuje, ako naše zatiaľ iba teoretické vysvetlenie funguje aj v realite. Jeho účelom je podporiť uveriteľnosť záverov, ktoré sme sa snažili vysvetliť v predchádzajúcej časti argumentu. Väčšinou ide o najrôznorodejšie typy dát, popis opakujúceho sa vzorca správania, či analógie (obdobné javy).'
                        ],
                        matches: [
                            'Vysvetlenie',
                            'Dôkaz',
                            'Tvrdenie'
                        ],
                        question: 'Argument nemusí mať žiaden záver.',
                        subQuestion: '',
                        title: 'Vyber pojem, o ktorom definícia hovorí.?',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: 'Dôkaz',
                points: 5,
                questions: [
                    QuestionsData(
                        answers: [
                            'Čím konkrétnejší dôkaz (napr. číselná štatistika, vedecké skúmanie atď.), tým silnejší argument.',
                            'Silným dôkazom často býva príklad osobnej skúsenosti.',
                            'Dôkaz je časť argumentu, ktorá slúži na to, aby ukázala ako argument funguje v praxi. ',
                            'Zvyčajne má dôkaz jednu vetu a zhŕňa cieľ argumentu.',
                            'Všetky články, ktoré nájdeme na internete môžeme použiť ako dôkaz.'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            ),
                            CorrectData(
                                correct: 2,
                                index: 2
                            ),
                        ],
                        definition: '',
                        explanation: [
                            'Osobná skúsenosť nie je dobrým dôkazom v argumente, keďže ju často nevieme zovšeobecniť a tým zosilniť. Internetové články sú oveľa lepšími dôkazmi, ale vždy treba dávať pozor na ich relevanciu a kredibilitu, keďže nie všetky spĺňajú štandardy dôveryhodného zdroja informácií. ',
                        ],
                        images: [],
                        matchmaking: [],
                        matches: [],
                        question: '',
                        subQuestion: '',
                        title: 'Označte všetky pravdivé tvrdenia o argumentačných dôkazoch:',
                    ),
                    QuestionsData(
                        answers: [
                            
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: 'Vysvetlenie: "Pocit bezpečia a moci, ktorý ľuďom dávajú zbrane, je klamlivý.  V skutočnosti ľudia vlastniaci zbrane čelia väčšiemu nebezpečenstvu. Príčinou je napríklad neopatrnosť a neschopnosť narábať so zbraňami, čo sa prejavuje pri nezaistených zbraniach v domácnosti alebo že sa zbrane dostanú do rúk detí.  To znamená, že pre bežných občanov je nebezpečné vlastniť zbraň. Ak by sme zakázali vlastnenie zbraní, ľudia by si vyberali iné, efektívnejšie spôsoby, ako ochrániť svoje domácnosti."',
                        explanation: [
                            ' Osobná skúsenosť nie je zovšeobecniteľná. Mohlo ísť o výnimku',
                        ],
                        images: [],
                        matchmaking: [
                            'Počul/-a som, že jeden rodič omylom postrelil svojho syna do nohy na poľovačke. Syn potom dostal otravu krvi a skoro prišiel o život. Kamarát môjho otca bol práve primárom na oddelení kde ten chalan ležal a vravel, že to vôbec nebol pekný pohľad. Tohoto chalana zbrane skoro stáli život. '
                        ],
                        matches: [
                            'Vhodný',
                            'Nevhodný'
                        ],
                        question: 'Téma: Držba strelných zbraní pre osobné účely by mala byť zakázaná.',
                        subQuestion: 'Tvrdenie: "Zákaz strelných zbraní by viedol k vyššej bezpečnosti v domácnostiach."',
                        title: 'Prečítajte si tému, tvrdenie a vysvetlenie a následne rozhodnite ktoré z dôkazov sú vhodné pre potenciálny argument.',
                    ),
                    QuestionsData(
                        answers: [
                            
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: 'Vysvetlenie: "Pocit bezpečia a moci, ktorý ľuďom dávajú zbrane, je klamlivý.  V skutočnosti ľudia vlastniaci zbrane čelia väčšiemu nebezpečenstvu. Príčinou je napríklad neopatrnosť a neschopnosť narábať so zbraňami, čo sa prejavuje pri nezaistených zbraniach v domácnosti alebo že sa zbrane dostanú do rúk detí.  To znamená, že pre bežných občanov je nebezpečné vlastniť zbraň. Ak by sme zakázali vlastnenie zbraní, ľudia by si vyberali iné, efektívnejšie spôsoby, ako ochrániť svoje domácnosti."',
                        explanation: [
                            'Anketa v tomto prípade nie je reprezentatívna - je málo respondentov a náchádza sa na (vymyslenej) stránke protizbraniam.sk, ktorá pravdepodobne nebude objektívna.',
                        ],
                        images: [],
                        matchmaking: [
                            'Podľa výsledkov ankety na stránke protizbraniam.sk si až 81% ľudí myslí, že zbrane by mali byť zakázané. Navyše až 35% ľudí uviedlo, že má negatívnu osobnú skúsenosť so zbraňami. Do ankety sa zapojilo 670 respondentov, čo je dosť veľký objem ľudí. '
                        ],
                        matches: [
                            'Vhodný',
                            'Nevhodný'
                        ],
                        question: 'Téma: Držba strelných zbraní pre osobné účely by mala byť zakázaná.',
                        subQuestion: 'Tvrdenie: "Zákaz strelných zbraní by viedol k vyššej bezpečnosti v domácnostiach."',
                        title: 'Prečítajte si tému, tvrdenie a vysvetlenie a následne rozhodnite ktoré z dôkazov sú vhodné pre potenciálny argument.',
                    ),
                    QuestionsData(
                        answers: [
                            
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: 'Vysvetlenie: "Pocit bezpečia a moci, ktorý ľuďom dávajú zbrane, je klamlivý.  V skutočnosti ľudia vlastniaci zbrane čelia väčšiemu nebezpečenstvu. Príčinou je napríklad neopatrnosť a neschopnosť narábať so zbraňami, čo sa prejavuje pri nezaistených zbraniach v domácnosti alebo že sa zbrane dostanú do rúk detí.  To znamená, že pre bežných občanov je nebezpečné vlastniť zbraň. Ak by sme zakázali vlastnenie zbraní, ľudia by si vyberali iné, efektívnejšie spôsoby, ako ochrániť svoje domácnosti."',
                        explanation: [
                            'Ide o dôveryhodnú vedeckú štúdiu, ktorá je relevantná pre argument.',
                        ],
                        images: [],
                        matchmaking: [
                            'V USA je držba zbraní legálna. Štúdia z Annals of Internal Medicine z 2014 porovnávala americké domácnosti ktoré vlastnili zbrane s tými, ktoré nevlastnili. Ukázalo sa, že prítomnosť zbrane v domácnosti zdvojnásobila šancu zomrieť na zastrelenie a strojnásobila nebezpečenstvo samovraždy. '
                        ],
                        matches: [
                            'Vhodný',
                            'Nevhodný'
                        ],
                        question: 'Téma: Držba strelných zbraní pre osobné účely by mala byť zakázaná.',
                        subQuestion: 'Tvrdenie: "Zákaz strelných zbraní by viedol k vyššej bezpečnosti v domácnostiach."',
                        title: 'Prečítajte si tému, tvrdenie a vysvetlenie a následne rozhodnite ktoré z dôkazov sú vhodné pre potenciálny argument.',
                    ),
                    QuestionsData(
                        answers: [
                            
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: 'Vysvetlenie: "Pocit bezpečia a moci, ktorý ľuďom dávajú zbrane, je klamlivý.  V skutočnosti ľudia vlastniaci zbrane čelia väčšiemu nebezpečenstvu. Príčinou je napríklad neopatrnosť a neschopnosť narábať so zbraňami, čo sa prejavuje pri nezaistených zbraniach v domácnosti alebo že sa zbrane dostanú do rúk detí.  To znamená, že pre bežných občanov je nebezpečné vlastniť zbraň. Ak by sme zakázali vlastnenie zbraní, ľudia by si vyberali iné, efektívnejšie spôsoby, ako ochrániť svoje domácnosti."',
                        explanation: [
                            'Dôkaz nesúvisí s vysvetlením. Vysvetlenie je o neopatrnom zaobchádzaní so zbraňami, dôkaz je o životnom prostredí.',
                        ],
                        images: [],
                        matchmaking: [
                            'Štúdia od Rachel Deming z roku 2018 poukazuje na zásadnú environmentálnu záťaž, ktorú spôsobujú zbrane. Strelnice sú rizikom pre životné prostredie, lebo pri streľbe sa vypúšťajú nebezpečné látky, napríklad olovo, zinok, meď a niekedy dokonca ortuť. Tieto látky sa usadia v pôde a potom môžu kontaminovať podzemné vody.'
                        ],
                        matches: [
                            'Vhodný',
                            'Nevhodný'
                        ],
                        question: 'Téma: Držba strelných zbraní pre osobné účely by mala byť zakázaná.',
                        subQuestion: 'Tvrdenie: "Zákaz strelných zbraní by viedol k vyššej bezpečnosti v domácnostiach."',
                        title: 'Prečítajte si tému, tvrdenie a vysvetlenie a následne rozhodnite ktoré z dôkazov sú vhodné pre potenciálny argument.',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: '1.1 Silné a slabé argumenty',
                points: 3,
                questions: [
                    QuestionsData(
                        answers: [
                            'silné',
                            'slabé'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Tvrdenie pracuje s predpokladom, že ak budú vysoké školy zadarmo, viac ľudí získa titul. Avšak počet absolventov nesúvisí s cenou školného – aj školy zadarmo môžu mať limity na to, koľko študentov príjmu. Tvrdenie hovorí len o nadbytku kvalifikovaných ľudí, ale nevyjadruje sa k otázke ceny.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie 1:  Nie. Priveľmi jednoducho získané vzdelanie vedie k priveľa kvalifikovaným ľuďom a potom k nezamestnanosti.',
                        subQuestion: ' Nie. Priveľmi jednoducho získané vzdelanie vedie k priveľa kvalifikovaným ľuďom a potom k nezamestnanosti.',
                        title: 'Majú podľa vás tieto tvrdenia potenciál byť dobrými argumentami? 1) Nasledujúce tvrdenia boli vytvorené ako odpovede na na otázku: Mali by byť vysoké školy zadarmo?',
                    ),
                    QuestionsData(
                        answers: [
                            'silné',
                            'slabé'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Tvrdenie sa priamo vyjadruje k položenej otázke a jasne pomenováva nevýhodu vyplývajúcu zo zavedenia opatrenia. Navyše, toto tvrdenie prináša aj dôkaz v podobe štúdii, ktoré robia jeho dopady uveriteľnejšie.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie 2: Nie, pretože rôzne štúdie ukázali, že študenti, ktorí nie sú povinní platiť školné, si školu vážia menej, menej sa jej venujú a dosahujú horšie výsledky.',
                        subQuestion: '',
                        title: 'Majú podľa vás tieto tvrdenia potenciál byť dobrými argumentami? 1) Nasledujúce tvrdenia boli vytvorené ako odpovede na na otázku: Mali by byť vysoké školy zadarmo?',
                    ),
                    QuestionsData(
                        answers: [
                            'silné',
                            'slabé'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Tvrdenie vytvára ucelenú analýzu. Pomenuje problém, vysvetlí, ako tento problém operuje a je zakončené náčrtom dopadov na spoločnosť.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie 3: Áno, lebo školné vie byť pre veľa študentov príliš vysoké. Potom si veľa ľudí nevie dovoliť chodiť na univerzity, hlavne študenti zo sociálne slabších rodín. Toto nie je spravodlivé a len to prehlbuje rozdiely medzi bohatými a chudobnými.',
                        subQuestion: '',
                        title: 'Majú podľa vás tieto tvrdenia potenciál byť dobrými argumentami? 1) Nasledujúce tvrdenia boli vytvorené ako odpovede na na otázku: Mali by byť vysoké školy zadarmo?',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: '1.2  Silné a slabé argumenty',
                points: 3,
                questions: [
                    QuestionsData(
                        answers: [
                            'silné',
                            'slabé'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            ' Tvrdeniu chýba vysvetlenie mechanizmu, prečo minimálna mzda zapríčiňuje prosperitu. Ten vzťah môže byť kľudne opačný (prosperujúce krajiny si môžu dovoliť navýšiť minimálnu mzdu) alebo dokonca náhodný, keďže veľa neprosperujúcich krajín má minimálnu mzdu.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie 1: Áno. Krajiny, kde nie je fixná minimálna mzda, sú často dysfunkčné a plné chudoby. Bohaté a prosperujúce štáty minimálnu mzdu naopak majú. Ak štát chce byť bohatý a prosperujúci, mal by preto zaviesť minimálnu mzdu.',
                        subQuestion: '',
                        title: 'Majú podľa vás tieto tvrdenia potenciál byť dobrými argumentami?   2) Nasledujúce tvrdenia boli vytvorené ako odpovede na na otázku: Mala by byť vo všetkých krajinách zavedená minimálna mzda?',
                    ),
                    QuestionsData(
                        answers: [
                            'silné',
                            'slabé'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Tvrdenie sa priamo vyjadruje k položenej otázke a veľmi jasne pomenúva nevýhodu fixnej minimálnej mzdy. Navyše obsahuje ucelený príčinno-následkový reťazec, teda nám presne vysvetľuje čo sa stane a aké to bude mať následky.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie 2: Nie, minimálna mzda vedie k chudobe tým, že tlačí podniky k tomu, aby prijímali zamestnancov len na polovičný alebo čiastočný úväzok, pretože si nemôžu dovoliť platiť zamestnancov na plný úväzok.',
                        subQuestion: '',
                        title: 'Majú podľa vás tieto tvrdenia potenciál byť dobrými argumentami?  2) Nasledujúce tvrdenia boli vytvorené ako odpovede na na otázku: Mala by byť vo všetkých krajinách zavedená minimálna mzda?',
                    ),
                    QuestionsData(
                        answers: [
                            'silné',
                            'slabé'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Tvrdenie sa nevyjadruje priamo k téme, je len o tom, prečo by mali byť ľudia platení za svoju prácu a ako by to malo byť ich základné ľudské právo. Avšak zavedenie minimálnej mzdy neznamená, že každý človek bude mať prácu a zaručené dôstojné živobytie',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'Tvrdenie 3: Áno, stabilný príjem, aj keď len minimálnej hodnoty, by mal byť základným ľudským právom. Každý človek by mal mať zaručené dôstojné živobytie.',
                        subQuestion: '',
                        title: 'Majú podľa vás tieto tvrdenia potenciál byť dobrými argumentami?  2) Nasledujúce tvrdenia boli vytvorené ako odpovede na na otázku: Mala by byť vo všetkých krajinách zavedená minimálna mzda?',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: 'Závery (výroková logika I.)',
                points: 6,
                questions: [
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'V predpoklade sú spomenuté len súkromné podzemné knižnice. Predpoklad nevylučuje existenciu väčšej podzemnej knižnice, ktorá je vlastnená inak ako súkromne.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad: Jakub Rajčina vo svojej pivnici v Liberci vybudoval najväčšiu súkromnú podzemnú knižnicu v Českej Republike',
                        subQuestion: 'Záver 1: V Českej Republike môže existovať väčšia podzemná knižnica ako tá, ktorú vybudoval Jakub Rajčina.',
                        title: 'Predstavte si, že je predpoklad vo vete pravdivý. Aké závery vieme vyvodiť z tohoto predpokladu?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Predpoklad hovorí len o súkromne vlastnených podzemných knižniciach. Navyše, je tento záver vzájomne výlučný so záverom 1, čo znamená, že ak ste  odpovedali „áno“ pri prvom závere, odpoveď na druhý záver sa dala vydedukovať.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad: Jakub Rajčina vo svojej pivnici v Liberci vybudoval najväčšiu súkromnú podzemnú knižnicu v Českej Republike.',
                        subQuestion: ' Záver 2: Podzemná knižnica Jakuba Rajčinu je najväčšou podzemnou knižnicou v Českej Republike.',
                        title: 'Predstavte si, že je predpoklad vo vete pravdivý. Aké závery vieme vyvodiť z tohoto predpokladu?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            ' Predpoklad hovorí len o podzemných knižniciach a teda nevyulučuje existenciu iných, väčších knižníc (napr. univerzitných). Tento záver nešpecifikuje miesto, takže hovorí o všeobecnom výskyte súkromných knižníc. Keďže náš predpoklad presne špecifikuje miesto, záver, že nikde inde na svete nemôže existovať väčšia súkromná knižnica, je nesprávny',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad: Jakub Rajčina vo svojej pivnici v Liberci vybudoval najväčšiu súkromnú podzemnú knižnicu v Českej Republike.',
                        subQuestion: 'Záver 3: Neexistuje väčšia súkromná knižnica ako má Jakub Rajčina.',
                        title: 'Predstavte si, že je predpoklad vo vete pravdivý. Aké závery vieme vyvodiť z tohoto predpokladu?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            ' Predpoklad nevylučuje možnosť, že predošlé roky, prichádzali do Poľska utečenci z Afganistanu. Predpoklad len vylučuje možnosť, že ich v predošlé roky bolo viac ako v roku 2015.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad: V roku 2015 prijalo Poľsko rekordné množstvo utečencov z Afganistanu',
                        subQuestion: ' Záver 1: V roku 2014 Poľsko neprijalo žiadnych utečencov z Afganistanu.',
                        title: 'Predstavte si, že je predpoklad vo vete pravdivý. Aké závery vieme vyvodiť z tohoto predpokladu?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            ' Predpoklad sa vyjadruje len k faktu, že utečencov prichádzajúcich z Afganistanu bolo najviac v roku 2015, pričom nehovorí, že z celkového počtu utečencov, ktorí v roku 2015 prišli do Poľska, bolo najviac tých z Afganistanu.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad: V roku 2015 prijalo Poľsko rekordné množstvo utečencov z Afganistanu.',
                        subQuestion: 'Záver 2: V roku 2015 bolo najviac utečencov prichádzajúcich do Poľska z Afganistanu',
                        title: 'Predstavte si, že je predpoklad vo vete pravdivý. Aké závery vieme vyvodiť z tohoto predpokladu?',
                    ),
                    QuestionsData(
                        answers: [
                            'Áno',
                            'Nie'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Predpoklad sa nevyjadruje o celkových číslach utečencov naprieč históriou, ale hovorí špecificky o Afganských utečencoch v 2015. Tých síce v 2015 bolo najviac, no to nie je výlučné so záverom, že v predošlých rokoch do Poľska prišlo celkovo viac utečencov.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad: V roku 2015 prijalo Poľsko rekordné množstvo utečencov z Afganistanu.',
                        subQuestion: ' Záver 3: V roku 2015 prišlo do Poľska najviac utečencov v histórii.',
                        title: 'Zadanie: Predstavte si, že je predpoklad vo vete pravdivý. Aké závery vieme vyvodiť z tohoto predpokladu?',
                    ),
                ]
            ),
            TestsData(
                introduction: '',
                name: 'Predpoklady (výroková logika II.)',
                points: 5,
                questions: [
                    QuestionsData(
                        answers: [
                            'Vo väších kávach je viac kofeínu.',
                            'Čím viac kofeínu je v káve, tým je káva lepšia.',
                            'Tvoja káva je menšia ako moja'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Moja káva je lepšia ako tvoja.    Vždy je potrebné zamyslieť sa, ako sa dá dosiahnuť potrebný záver; ako vytvoríme lepšiu kávu. Odpoveď b) je správna, pretože sa priamo vyjadruje k tomu, na základe akej charakteristiky posudzujeme kvalitu kávy – na základe množstva kofeínu. Ostatné dve odpovede hovoria len o velkostiach kávy, ktoré môžu zdanlivo súvisieť s predpokladom č.1, ale nedostanú nás k potrebnému záveru.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad 1: V mojej dvojitej káve je viac kofeínu ako v tvojej.',
                        subQuestion: 'Predpoklad 2: ___________',
                        title: 'Doplň zamlčaný predpoklad do prázdneho miesta tak, aby z oboch predpokladov dokopy vyplynul záver. (inšpiráciu na tento typ úloh sme čerpali v: Martin Schmidt et al. (2018), Ako správne argumentovať, písať a diskutovať.)',
                    ),
                    QuestionsData(
                        answers: [
                            'Bardejov je veľmi šakredé mesto',
                            'Svidník je krajší ako Bardejov',
                            'Bardejov je krajší ako Svidník'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Preto sú Košice krajšie ako Svidník.  Bolo treba porozmýšlať, ako dosiahneme, aby Košice boli krajšie ako Bardejov aj ako Svidník zároveň. Predpoklad a) sa nevyjadruje k Svidníku a teda z neho nedokážeme vyvodiť záver. Predpoklad b) je tiež nesprávny, pretože nám z neho síce vyplýva, že Svidník aj Košice sú obe krajšie ako Bardejov, nevieme určiť, ktoré mesto je krajšie. Predpoklad c) je jediný správny, pretože platí, že ak je Bardejov krajší ako Svidník, a zároveň sú Košice krajšie ako Bardejov, Svidník padá v rebríčku za Košice a záver platí.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad 1: Košice sú krajšia ako Bardejov',
                        subQuestion: 'Predpoklad 2: ________',
                        title: 'Doplň zamlčaný predpoklad do prázdneho miesta tak, aby z oboch predpokladov dokopy vyplynul záver.',
                    ),
                    QuestionsData(
                        answers: [
                            'Žiaden žiak, ktorý je dobrý v matematike nepoužíva ťaháky.',
                            'Žiaci, ktorí nie sú dobrí v matematike používajú ťaháky.',
                            'Jakub, pretože je zlý v matematike, potrebuje používať ťaháky.'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 0,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Preto Filip nepoužíva ťaháky. Je potrebné doplniť predpoklad, v ktorom zovšeobecníme pravidlo natoľko, aby sme mohli povedať, že každý človek z určitej vzorky bude mať rovnakú vlastnosť. V tomto prípade je opisovaná vlastnosť nepoužívanie ťahákou a vzorkou sú všetci žiaci, ktorým ide matematika. Odpoveď a) ako jediná ponúka takéto zovšeobecnenie a preto je správna.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad 1: Filip je dobrý v matematike, ale Jakub nie je.',
                        subQuestion: 'Predpoklad 2: _________',
                        title: 'Doplň zamlčaný predpoklad do prázdneho miesta tak, aby z oboch predpokladov dokopy vyplynul záver.',
                    ),
                    QuestionsData(
                        answers: [
                            'Čím má krajina nižší index ľudského rozvoja, tým je bohatšia',
                            'Bohatstvo krajiny priamoúmerne súvisí s výškou indexu ľudského rozvoja v nej.',
                            'Turecko má nízky index ľudského rozvoja.'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 1,
                                index: 0
                                )
                            ],
                        definition: '',
                        explanation: [
                            'Katar má vyšší index ľudského rozvoja ako Turecko. Bolo sa treba zamyslieť, ako sa dá prepojiť bohatstvo s indexom ľudksého rozvoja. Odpoveď b) je správna, pretože ako jediná správne pomenováva vzťah medzi týmito dvoma veličinami a ako jediná nás dokáže doviesť k potrebnému záveru.',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad 1: Katar je bohatší ako Turecko',
                        subQuestion: 'Predpoklad 2: ___________',
                        title: 'Doplň zamlčaný predpoklad do prázdneho miesta tak, aby z oboch predpokladov dokopy vyplynul záver.',
                    ),
                    QuestionsData(
                        answers: [
                            'Dunčo je susedov pes',
                            'Dunčo nie je náš.',
                            ' Dunčo nie je pes.'
                        ],
                        answersImage: [],
                        correct: [
                            CorrectData(
                                correct: 2,
                                index: 0
                            )
                        ],
                        definition: '',
                        explanation: [
                            'Dunčo v pondelok neštekal. Odpoveď c) je jediná správna, keďže ostatné dve odpovede pracujú s domnienkou, že predpoklad č.1 je limitovaný na „naše“ psy. Avšak, v tomto prepdoklade nie je použitý žiaden výraz, ktorý by nás k takémuto záveru doviedol – neboli použité žiadne slová ako len alebo iba. To, že naše psy štekali celú noc, ešte neznamená, že neštekali žiadne iné. Ak Dunčo v pondelok neštekal a naše psy štekali celú noc, nezamená to, že Dunčo nemôže byť susedov pes, ktorý taktiež štekal celú noc. ',
                        ],
                            images: [],
                        matchmaking: [],
                        matches: [],
                        question: 'v  Predpoklad 1:  Všetky naše psy štekali celú pondelkovú noc.',
                        subQuestion: 'v  Predpoklad 2: ___________',
                        title: 'Doplň zamlčaný predpoklad do prázdneho miesta tak, aby z oboch predpokladov dokopy vyplynul záver.',
                    ),
                ]
            ),
        ],
        weeklyChallenge: 0,
    ),
            );
          }, child: Text('create'))
          ],
        )
      ]
    );
  }
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
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
    await capitolsCollection.doc('1').set(capitolMap);
    print('Capitol created successfully with ID: 1');

  } catch (e) {
    print('Error creating capitol: $e');
    throw Exception('Failed to create capitol');
  }
}

  
}