class DogBreed {
  final String name;
  final String lifeSpan;
  final String temperament;
  final String bredFor;
  final String imageUrl;

  DogBreed({
    required this.name,
    required this.lifeSpan,
    required this.temperament,
    required this.bredFor,
    required this.imageUrl,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      name: json['breeds'] != null && json['breeds'].isNotEmpty
          ? json['breeds'][0]['name'] ?? 'Unknown Breed'
          : 'Unknown Breed',
      lifeSpan: json['breeds'] != null && json['breeds'].isNotEmpty
          ? json['breeds'][0]['life_span'] ?? 'Unknown'
          : 'Unknown',
      temperament: json['breeds'] != null && json['breeds'].isNotEmpty
          ? json['breeds'][0]['temperament'] ?? 'Unknown'
          : 'Unknown',
      bredFor: json['breeds'] != null && json['breeds'].isNotEmpty
          ? json['breeds'][0]['bred_for'] ?? 'Unknown'
          : 'Unknown',
      imageUrl: json['url'] ?? '',  
    );
  }
}
