import 'package:flutter/material.dart';
import 'package:medsreminder/datatypes/providertype.dart';
import 'package:provider/provider.dart';
import 'time_picker.dart';
//import './localdata/global_data.dart' as globals;

Future<void> addMedication(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  TimeOfDay? selectedTime;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    final picked = await showCupertinoTimePicker(
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
              if (nameController.text.isNotEmpty && selectedTime != null) {
                Provider.of<MedsListProvider>(
                  context,
                  listen: false,
                ).addMeds(nameController.text, selectedTime!.format(context));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${nameController.text} added for ${selectedTime!.format(context)}',
                    ),
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
