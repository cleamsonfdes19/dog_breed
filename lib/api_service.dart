import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_breed.dart';

class ApiService {
  static const String apiUrl =
      'https://api.thedogapi.com/v1/images/search?size=med&mime_types=jpg&format=json&has_breeds=true&order=RANDOM&limit=10';
  static const String apiKey =
      'live_GhXL2pki6pFpAKEfE69Ddrr8AJBlF6kog2F0BNYBbYSloX9FXmcolr1mXK5Ni8QN';

  
  Future<List<DogBreed>> fetchAllDogBreeds(int page) async {
    final response = await http.get(
      Uri.parse('$apiUrl&page=$page'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      
      return data.map((item) => DogBreed.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch dog breeds');
    }
  }

  
  Future<List<DogBreed>> fetchDogBreedsWithValidImages(int page) async {
    final response = await http.get(
      Uri.parse('$apiUrl&page=$page'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      
      List<DogBreed> validBreeds = [];
      for (var item in data) {
        DogBreed breed = DogBreed.fromJson(item);
        if (await _isImageLoadable(breed.imageUrl)) {
          validBreeds.add(breed);
        }
      }

      return validBreeds;
    } else {
      throw Exception('Failed to fetch dog breeds');
    }
  }

  
  Future<bool> _isImageLoadable(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200; 
    } catch (e) {
      print('Error checking image validity: $e');
      return false;
    }
  }
}
