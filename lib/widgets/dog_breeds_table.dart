import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/dog_breed.dart';

class DogBreedsTable extends StatefulWidget {
  @override
  _DogBreedsTableState createState() => _DogBreedsTableState();
}

class _DogBreedsTableState extends State<DogBreedsTable> {
  int _currentPage = 0; 
  int _rowsPerPage = 8; 
  int _totalPages = 5; 
  List<DogBreed> _dogBreeds = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  
  void _fetchData() async {
    try {
      
      final breeds = await ApiService().fetchAllDogBreeds(_currentPage);
      setState(() {
        _dogBreeds = breeds;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  
  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
    _fetchData();
  }

  
  Widget _buildPaginationButtons() {
    List<Widget> buttons = [];

    for (int i = 0; i < _totalPages; i++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TextButton(
            onPressed: () => _goToPage(i),
            style: TextButton.styleFrom(
              backgroundColor: _currentPage == i ? Colors.blue : Colors.grey[300],
              minimumSize: Size(40, 30),
            ),
            child: Text(
              (i + 1).toString(),
              style: TextStyle(
                color: _currentPage == i ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
        ),
        ...buttons,
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _currentPage < _totalPages - 1 ? () => _goToPage(_currentPage + 1) : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dog Breeds Table"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'Breed',
                      style: TextStyle(fontWeight: FontWeight.bold), // Set bold style here
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Life Span',
                      style: TextStyle(fontWeight: FontWeight.bold), 
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Temperament',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Bred For',
                      style: TextStyle(fontWeight: FontWeight.bold), 
                    ),
                  ),
                ],
                rows: _dogBreeds
                    .take(_rowsPerPage)
                    .map((breed) => DataRow(cells: [
                          DataCell(Text(breed.name)),
                          DataCell(Text(breed.lifeSpan)),
                          DataCell(Text(breed.temperament)),
                          DataCell(Text(breed.bredFor)),
                        ]))
                    .toList(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(16.0),
            child: _buildPaginationButtons(),
          ),
        ],
      ),
    );
  }
}
