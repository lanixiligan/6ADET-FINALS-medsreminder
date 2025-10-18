import 'package:flutter/material.dart';
import 'package:medsreminder/datatypes/providertype.dart';
import 'widgets/add_medication.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'widgets/generate_card.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// main app booter
Future<void> main() async {
  // alarm widgets init
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  // sqlite init
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'medsalarm.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE medsreminders()');
    },
  );

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
        title: Text(
              "MediTrack",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30, // Changed from 24 to 30
              ),
            ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        elevation: 2,
      ),
      body: Provider.of<MedsListProvider>(context, listen: true).meds.isEmpty
          ?
            // show the center widget that indicates there's no alarm to display.
            Center(
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
          // checks the contents of Provider.of<MedsListProvider>(context, listen: boolean)
          : ListView.builder(
              padding: EdgeInsets.all(10),
              // =============
              itemCount: Provider.of<MedsListProvider>(context).meds.length,
              itemBuilder: (context, index) {
                return generateCard(outerContext: context, index: index);
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
