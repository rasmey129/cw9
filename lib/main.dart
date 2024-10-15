import 'package:flutter/material.dart';
import 'database_helper.dart';

// Here we are using a global variable. You can use
// something like get_it in a production app.
final dbHelper = DatabaseHelper();
final TextEditingController _idController = TextEditingController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter ID',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _queryById,
              child: const Text('Query by ID'),
            ),
            const SizedBox(height: 10),
            
          ],
        ),
      ),
    );
  }

  // Existing methods
  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  // Query a specific record by ID
  void _queryById() async {
    int id = int.parse(_idController.text); 
    final row = await dbHelper.queryById(id);
    if (row != null) {
      debugPrint('Record found: $row');
    } else {
      debugPrint('No record found with ID: $id');
    }
  }
}