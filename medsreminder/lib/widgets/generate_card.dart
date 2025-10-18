import 'package:flutter/material.dart';
import 'package:medsreminder/datatypes/providertype.dart';
import 'package:provider/provider.dart';

Widget generateCard({required BuildContext outerContext, required int index}) {
  final med = Provider.of<MedsListProvider>(
    outerContext,
    listen: false,
  ).meds[index];
  final bool taken = med['taken'] ?? false;
  bool light = true;

  return StatefulBuilder(
    builder: (context, setStateSB) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: ListTile(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Delete ${med['title']}?"),
                content: Text("Are you sure you want to remove this?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      setStateSB(
                        () => Provider.of<MedsListProvider>(
                          context,
                          listen: false,
                        ).removeMeds(index: index),
                      );
                      Navigator.pop(context);
                    },
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          leading: med['type'] == "Once A Day"
              ? Checkbox(
                  activeColor: Colors.cyan,
                  value: taken,
                  onChanged: (value) {
                    setStateSB(() {
                      Provider.of<MedsListProvider>(
                        context,
                        listen: false,
                      ).meds[index]['taken'] = value ?? false;
                    });
                  },
                )
              : null,
          title: Text(
            med['title'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: taken
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: med['type'] == "Once A Day"
              ? null
              : Text(
                  med['time'] ?? '',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    decoration: taken
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
          trailing: Switch(
            value: light,
            activeThumbColor: Colors.lightBlueAccent,
            onChanged: (bool value) {
              setStateSB(() {
                light = value;
              });
            },
          ),
        ),
      );
    },
  );
}
