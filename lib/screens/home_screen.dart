import 'package:flutter/material.dart';
import '../widgets/dog_breeds_table.dart';
import '../widgets/dog_breeds_carousel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showTableView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Breeds'),
        actions: [
          IconButton(
            icon: Icon(_showTableView ? Icons.view_carousel : Icons.table_chart),
            onPressed: () {
              setState(() {
                _showTableView = !_showTableView;
              });
            },
          ),
        ],
      ),
      body: _showTableView ? DogBreedsTable() : DogBreedsCarousel(),
    );
  }
}
