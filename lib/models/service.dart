class Service {
  final String id;
  final String name;
  final String description;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap(String userEmail) {
    return {
      'id': id,
      'userEmail': userEmail,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
