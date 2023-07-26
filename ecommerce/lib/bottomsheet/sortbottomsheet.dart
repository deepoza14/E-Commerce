import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SortBottomSheetWidget extends StatefulWidget {
  final int selectedRowIndex; // Add selectedRowIndex as a parameter
  final Function(int) onRowTapped; // Add onRowTapped as a parameter

  const SortBottomSheetWidget({
    Key? key,
    required this.selectedRowIndex,
    required this.onRowTapped,
  }) : super(key: key);

  @override
  SortBottomSheetWidgetState createState() => SortBottomSheetWidgetState();
}

class SortBottomSheetWidgetState extends State<SortBottomSheetWidget> {
  int selectedRowIndex = -1;

  void onRowTapped(int index) {
    setState(() {
      selectedRowIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10, top: 20),
        child: Column(
          children: [
            buildRow(FontAwesomeIcons.circleCheck, "Top 5", 0),
            buildRow(FontAwesomeIcons.circleCheck, "Top Asc", 1),
            buildRow(FontAwesomeIcons.circleCheck, "Top Desc", 2),
            buildRow(FontAwesomeIcons.circleCheck, "Electronics", 3),
            buildRow(FontAwesomeIcons.circleCheck, "Jewelery", 4),
            buildRow(FontAwesomeIcons.circleCheck, "Men's Clothing", 5),
            buildRow(FontAwesomeIcons.circleCheck, "Women's Clothing", 6),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColorTheme.primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                minimumSize: const Size(100, 50),
              ),
              onPressed: () {
                widget.onRowTapped(
                    -1); // Reset selected sorting option to default (-1)
              },
              child: Text(
                "CLEAR",
                style: TextStyle(
                  color: MyColorTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(IconData iconData, String text, int index) {
    final isSelected =
        index == widget.selectedRowIndex; // Access selectedRowIndex from widget
    return GestureDetector(
      onTap: () => widget.onRowTapped(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FaIcon(iconData, color: isSelected ? Colors.red : null),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: TextStyle(color: isSelected ? Colors.red : null),
            ),
          ],
        ),
      ),
    );
  }

  void showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => build(context),
    );
  }
}
