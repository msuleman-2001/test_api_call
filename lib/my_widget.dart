import 'package:flutter/material.dart';

class DropdownAndTextbox extends StatefulWidget {
  final Map<int, String> items;
  final int id;
  final Key? key;
  final Function(int) onDelete;
  int? SpecKeyID = 0;
  String? SpecValue = '';
  DropdownAndTextbox({required this.items, required this.id, this.key, this.SpecKeyID, this.SpecValue, required this.onDelete}); // : super(key: key);

  @override
  _DropdownAndTextboxState createState() => _DropdownAndTextboxState();
}

class _DropdownAndTextboxState extends State<DropdownAndTextbox> {
  int? dropdownValue;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.id.toString()),
        DropdownButton<int>(
          value: dropdownValue,
          hint: Text("Choose an item"),
          onChanged: (int? newValue) {
            setState(() {
              dropdownValue = newValue;
              widget.SpecKeyID = newValue!;
              widget.SpecValue = _textController.text;
            });
          },
          items: widget.items.entries.map<DropdownMenuItem<int>>((MapEntry<int, String> entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),

        TextField(
          controller: _textController,
          onChanged: (text) {
            if (dropdownValue != null) {
              widget.SpecKeyID = dropdownValue!;
              widget.SpecValue = text;
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Text Box',
          ),
        ),
        ElevatedButton(
          onPressed: (){ widget.onDelete(widget.id); },
          child: Text("Delete"),
        ),
        SizedBox(height: 16.0), // To give space between items when adding multiple
      ],
    );
  }
}