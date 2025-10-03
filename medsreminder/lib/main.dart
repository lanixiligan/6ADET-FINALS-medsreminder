import 'package:flutter/material.dart';

void main() {
  runApp(MedsReminderApp());
}

class MedsReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MedsReminderScreen(),
    );
  }
}

class MedsReminderScreen extends StatefulWidget {
  @override
  _MedsReminderScreenState createState() => _MedsReminderScreenState();
}

class _MedsReminderScreenState extends State<MedsReminderScreen> {
  List<Map<String, dynamic>> meds = [];

 void _addMedication() async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Add Medication"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Medication Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Time (e.g. 8:00 PM)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  timeController.text.isNotEmpty) {
                setState(() {
                  meds.add({
                    'title': nameController.text,
                    'time': timeController.text,
                    'enabled': true,
                  });
                });
              }
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );
}


  

@override
Widget build(BuildContext context) {
  meds.sort((a, b) => a['time'].compareTo(b['time']));

  return Scaffold(
    appBar: AppBar(
      title: Text("MediTrack"),
      backgroundColor: Colors.cyan,
    ),
  body: meds.isEmpty
    ? Center(child: Text("No medications added"))
    : ListView.builder(
        itemCount: meds.length,
        itemBuilder: (context, index) {
          final med = meds[index];
          final bool taken = med['taken'] ?? false;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Checkbox(
                value: taken,
                onChanged: (value) {
                  setState(() {
                    meds[index]['taken'] = value ?? false;
                  });
                },
              ),
              title: Text(
                med['title'],
                style: TextStyle(
                  decoration:
                      taken ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                med['time'] ?? '',
                style: TextStyle(
                  decoration:
                      taken ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
          );
        },
      ),

    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.info_outline)),
          FloatingActionButton(
            onPressed: _addMedication,
            backgroundColor: Colors.cyan,
            child: Icon(Icons.add),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
    ),
  );
}
}

