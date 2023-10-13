import 'dart:convert';

import 'package:flutter/material.dart';

import 'my_widget.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Dropdown and Textbox Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Dropdown and Textbox Demo'),
        ),
        body: DynamicForm(),
      ),
    );
  }
}

class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  List<DropdownAndTextbox> formItems = [];
  Map<int, String> collectedData = {};
  Map<int, String> finalMap = {};
  int unique_id = 1;
  String data = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    try {
      String apiUrl =
          'https://admin.phoneshop.pk/public/api/seller/getAllSpecificationsKeys';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FkbWluLnBob25lc2hvcC5way9hcGkvc3RvcmUtbG9naW4iLCJpYXQiOjE2OTM5MDc2ODQsImV4cCI6MTcyNTQ2NTI4NCwibmJmIjoxNjkzOTA3Njg0LCJqdGkiOiJkd3JrYXZ5ZTBYT1l1WjNNIiwic3ViIjoiNTUiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Toh-GRJCwtCR3wBt387oVvWW5JacAfsLKNwplpuqtCY',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = jsonDecode(response.body);

        // Extract the list of specifications keys
        List<dynamic> specificationsKeys = decodedData['specifications_keys'];

        // Convert the list into the desired Map<int, String>
        for (var specKey in specificationsKeys) {
          finalMap[specKey['id'] as int] = specKey['key'] as String;
        }
      }
    }
    catch (e){
      print (e.toString());

    }
  }

  void _removeItem(int widget_id){
    setState((){
      DropdownAndTextbox element = formItems.firstWhere((element) => element.id == widget_id);
      formItems.remove(element);
      }
    );
  }
  void _addItem(int spec_id, String spec_value) {
    setState(() {
      DropdownAndTextbox spec_box = DropdownAndTextbox(
        items: finalMap,
        id: unique_id,
        key: ValueKey(unique_id),
        SpecKeyID: spec_id,
        SpecValue: spec_value,
        onDelete: (widget_id){
          _removeItem(widget_id);
        },
      );
      unique_id++;

      formItems.add(spec_box);
    });
  }

  void _collectData(){
    for (var i = 0; i < formItems.length; i++){
      print("${formItems[i].SpecKeyID}:${formItems[i].SpecValue}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: formItems.length,
            itemBuilder: (context, index) { return formItems[index]; },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(//file changed online
            child: Text('Add Dropdown and Text. I have changed a file'),
            onPressed: () {_addItem(0, '');} ,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Collect Data'),
            onPressed: _collectData,
          ),
        ),
      ],
    );
  }
}
