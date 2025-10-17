import 'package:flutter/material.dart';
import 'package:medsreminder/datatypes/providertype.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'time_picker.dart';

Future<void> addMedication(BuildContext outerContext) async {
  // choice fields
  const List<String> choiceList = <String>['Time Schedule', 'Once A Day'];

  final TextEditingController nameController = TextEditingController();
  TimeOfDay? selectedTime;

  String selectedChoice = 'Time Schedule';

  await showDialog(
    context: outerContext,
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
                //
                // =================== Medication Name Field
                //
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Medication Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                //
                // ======================= The Dropdown for selecting meds type
                //
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: selectedChoice,
                          items: choiceList
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            setStateSB(() {
                              selectedChoice = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),
                //
                // ================================================================== Time Picker
                // ================= Only show up if selectedChoice == "Time Schedule"
                //
                selectedChoice == "Time Schedule"
                    ? GestureDetector(
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
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
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
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          // =================================================================
          // ======================= The button responsible for inserting data
          // =================================================================
          ElevatedButton(
            onPressed: () async {
              // Start checking conditions
              if ((nameController.text.isNotEmpty &&
                      selectedTime != null &&
                      selectedChoice == "Time Schedule") ||
                  (nameController.text.isNotEmpty &&
                      selectedChoice == "Once A Day")) {
                Provider.of<MedsListProvider>(context, listen: false).addMeds(
                  name: nameController.text,
                  selectedTime: selectedTime != null
                      ? selectedTime!.format(context)
                      : TimeOfDay(hour: 8, minute: 0).format(context),
                  reminderType: selectedChoice,
                );

                ScaffoldMessenger.of(outerContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${nameController.text} added for ${selectedTime != null ? selectedTime!.format(context) : "Once a Day"}',
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              } else {
                await Flushbar(
                  message: 'Please enter name and pick a time.',
                  messageSize: 20,
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.black,
                ).show(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );
}
