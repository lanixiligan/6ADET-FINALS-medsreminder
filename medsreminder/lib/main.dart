import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MedsReminderApp());
}

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

class MedsReminderScreen extends StatefulWidget {
  @override
  _MedsReminderScreenState createState() => _MedsReminderScreenState();
}

class _MedsReminderScreenState extends State<MedsReminderScreen> {
  List<Map<String, dynamic>> meds = [];

  // Shows a Cupertino-style time picker as a modal popup and returns the selected TimeOfDay.
  Future<TimeOfDay?> _showCupertinoTimePicker({
    required BuildContext ctx,
    TimeOfDay? initialTime,
  }) async {
    DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialTime?.hour ?? now.hour,
      initialTime?.minute ?? now.minute,
    );

    DateTime chosen = initialDateTime;

    final result = await showCupertinoModalPopup<DateTime>(
      context: ctx,
      builder: (_) {
        return Container(
          height: 260,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(ctx),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // top action bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text('Done', style: TextStyle(color: Colors.cyan)),
                        onPressed: () => Navigator.of(ctx).pop(chosen),
                      ),
                    ],
                  ),
                ),
                // the picker
                SizedBox(
                  height: 180,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: initialDateTime,
                    use24hFormat: false,
                    onDateTimeChanged: (DateTime newDate) {
                      chosen = newDate;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null) return null;
    return TimeOfDay(hour: result.hour, minute: result.minute);
  }

  Future<void> _addMedication() async {
    final TextEditingController nameController = TextEditingController();
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Add Medication",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setStateSB) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Medication Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      // Use the dedicated Cupertino modal popup (works reliably)
                      final picked = await _showCupertinoTimePicker(
                        ctx: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setStateSB(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTime == null
                                ? "Select Time"
                                : selectedTime!.format(context),
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.access_time, color: Colors.cyan),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedTime != null) {
                  setState(() {
                    meds.add({
                      'title': nameController.text,
                      'time': selectedTime!.format(context),
                      'taken': false,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${nameController.text} added for ${selectedTime!.format(context)}'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  // quick feedback if missing fields
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter name and pick a time.'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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
        centerTitle: true,
        elevation: 2,
      ),
      body: meds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medication_liquid_outlined,
                      size: 80, color: Colors.grey.shade400),
                  SizedBox(height: 15),
                  Text(
                    "No medications added yet",
                    style:
                        TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: meds.length,
              itemBuilder: (context, index) {
                final med = meds[index];
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
                          content:
                              Text("Are you sure you want to remove this?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() => meds.removeAt(index));
                                Navigator.pop(context);
                              },
                              child: Text("Delete",
                                  style: TextStyle(color: Colors.red)),
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
                          meds[index]['taken'] = value ?? false;
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
        onPressed: _addMedication,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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