class Professional {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String description;

  Professional({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.description,
  });

  // Optional: For Firebase JSON conversion
  factory Professional.fromMap(String id, Map<String, dynamic> data) {
    return Professional(
      id: id,
      name: data['name'],
      specialty: data['specialty'],
      rating: (data['rating'] as num).toDouble(),
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'description': description,
    };
  }
}
