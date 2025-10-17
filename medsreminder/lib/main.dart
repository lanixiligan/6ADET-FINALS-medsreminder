import 'package:flutter/material.dart';
import 'package:medsreminder/datatypes/providertype.dart';
import 'widgets/time_picker.dart';
import 'widgets/add_medication.dart';
//import './localdata/global_data.dart' as globals;
import 'package:provider/provider.dart';

// main app booter
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MedsListProvider(),
      child: MedsReminderApp(),
    ),
  );
}

// main stateless widget code
class MedsReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: MedsReminderScreen(),
    );
  }
}

// stateful widget code
class MedsReminderScreen extends StatefulWidget {
  @override
  _MedsReminderScreenState createState() => _MedsReminderScreenState();
}

class _MedsReminderScreenState extends State<MedsReminderScreen> {
  @override
  Widget build(BuildContext context) {
    //globals.medsdata.meds.sort((a, b) => a['time'].compareTo(b['time']));

    return Scaffold(
      appBar: AppBar(
        title: Text("MediTrack"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        elevation: 2,
      ),
      body: Provider.of<MedsListProvider>(context, listen: true).meds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_liquid_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No medications added yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          // Iteration Builder ==========================================================================================
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: Provider.of<MedsListProvider>(
                context,
                listen: false,
              ).meds.length,
              itemBuilder: (context, index) {
                final med = Provider.of<MedsListProvider>(
                  context,
                  listen: false,
                ).meds[index];
                final bool taken = med['taken'] ?? false;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Delete ${med['title']}?"),
                          content: Text(
                            "Are you sure you want to remove this?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(
                                  () => Provider.of<MedsListProvider>(
                                    context,
                                  ).meds.removeAt(index),
                                );
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    leading: Checkbox(
                      activeColor: Colors.cyan,
                      value: taken,
                      onChanged: (value) {
                        setState(() {
                          Provider.of<MedsListProvider>(
                            context,
                            listen: false,
                          ).meds[index]['taken'] = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      med['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: taken
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      med['time'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        decoration: taken
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Icon(
                      Icons.medical_information,
                      color: taken ? Colors.grey : Colors.cyan,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => addMedication(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // =============================================================================================
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.cyan),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("MediTrack v1.0"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.cyan),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
