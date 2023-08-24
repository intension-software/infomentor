import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CapitolDragWidget extends StatefulWidget {
  final UserData? currentUserData;


  CapitolDragWidget({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _CapitolDragWidgetState createState() => _CapitolDragWidgetState();
}

class _CapitolDragWidgetState extends State<CapitolDragWidget> {
  List<int> numbers = [0, 1, 2, 3, 4, 5, 6];
  int? expandedTileIndex;
  ClassData? currentClassData ;

  fetchCurrentClass() async {
    try {
        ClassData classData = await fetchClass(widget.currentUserData!.schoolClass!);
    if (classData != null) {
        // Fetch the user data using the fetchUser function
        if (mounted) {
          setState(() {
            currentClassData = classData;
            numbers = classData.capitolOrder;
          });
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentClass();
  }

  @override
  void dispose() {
    // Cancel timers or stop animations...

    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final result = await reorderListOverlay(context, numbers, currentClassData!);
                  if (result != null) {
                    setState(() {
                      numbers = result;
                    });
                  }
                },
                child: Icon(Icons.edit),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,  // Important to prevent infinite height.
              physics: NeverScrollableScrollPhysics(),  // This makes sure that this list does not interfere with the outer scroll view.
              itemCount: numbers.length,
              itemBuilder: (ctx, index) {
                bool isExpanded = index == expandedTileIndex;

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[index % Colors.primaries.length],
                        child: Text(numbers[index].toString()),
                      ),
                      title: Text('Tile ${numbers[index]}'),
                      trailing: IconButton(
                        icon: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            if (isExpanded) {
                              expandedTileIndex = null;
                            } else {
                              expandedTileIndex = index;
                            }
                          });
                        },
                      ),
                    ),
                    if (isExpanded)
                      ...List.generate(4, (subIndex) => ListTile(
                            title: Text('SubTile ${numbers[index]}-$subIndex'),
                            trailing: Icon(Icons.check),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                            dense: true,
                            tileColor: Colors.grey[100],
                          )),
                  ],
                );
              },
            ),
          ],
        ),
      );
  }
 Future<List<int>?> reorderListOverlay(BuildContext context, List<int> numbers, ClassData currentClass) async {
  List<int> reorderedNumbers = List.from(numbers); // Create a deep copy

  return await showDialog<List<int>>(
    context: context,
    builder: (ctx) => StatefulBuilder( // Using StatefulBuilder for local state management
      builder: (context, setState) => Dialog(
        child: Container(
          width: 300,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = reorderedNumbers.removeAt(oldIndex);
                    reorderedNumbers.insert(newIndex, item);
                    setState(() {}); // Just calling setState to rebuild
                  },
                  children: reorderedNumbers.map((number) {
                    return ListTile(
                      key: ValueKey(number),
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[number % Colors.primaries.length],
                        child: Text(number.toString()),
                      ),
                      title: Text('Tile $number'),
                      trailing: Icon(Icons.reorder),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context, reorderedNumbers);
                  await updateClassToFirestore(reorderedNumbers);
                  fetchCurrentClass(); 
                },
                child: Text('Done'),
              )
            ],
          ),
        ),
      ),
    ),
  );
}


  Future<void> updateClassToFirestore(List<int> capitolOrder) async {
  try {
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(widget.currentUserData!.schoolClass);

    // Add the material data to Firestore and get the DocumentReference of the new document
    await classRef.update({
      'capitolOrder': capitolOrder
    });

    } catch (e) {
      print('Error adding material to class: $e');
      throw Exception('Failed to add capitolOrder');
    }
  }
}

// ReorderListOverlay remains unchanged.




