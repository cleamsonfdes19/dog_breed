import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/dog_breed.dart';

class DogBreedsCarousel extends StatefulWidget {
  @override
  _DogBreedsCarouselState createState() => _DogBreedsCarouselState();
}

class _DogBreedsCarouselState extends State<DogBreedsCarousel> {
  List<DogBreed> _dogBreeds = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  
  void _fetchData() async {
    try {
      List<DogBreed> breeds = [];
      int page = 0;

      
      while (breeds.length < 8) {
        final fetchedBreeds = await ApiService().fetchDogBreedsWithValidImages(page);
        if (fetchedBreeds.isEmpty) break; 
        breeds.addAll(fetchedBreeds);
        page++;
      }

      setState(() {
        _dogBreeds = breeds; 
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  
  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 300, 
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  
  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 300, 
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return _dogBreeds.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dog Breeds",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4), 
                    Text(
                      "Every day is a dog day", 
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _scrollLeft,
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    IconButton(
                      onPressed: _scrollRight,
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),

              
              SizedBox(height: 20),
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _dogBreeds.map((breed) {
                    return Container(
                      width: screenWidth * 0.4, 
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Card(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                breed.imageUrl,
                                height: 200, 
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Text Section
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    breed.name,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Life Span: ${breed.lifeSpan}",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Temperament: ${breed.temperament}",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Bred For: ${breed.bredFor}",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
  }
}
