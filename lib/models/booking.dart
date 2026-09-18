class Booking {
  final String id;
  final String serviceName;
  final String location;
  final String date;
  final String time;
  final String status;
  final String userId; // Unique user ID or phone number
  final String? notes;

  Booking({
    required this.id,
    required this.serviceName,
    required this.location,
    required this.date,
    required this.time,
    required this.status,
    required this.userId,
    this.notes,
  });

  // Convert from Map (SQLite)
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      serviceName: map['serviceName'],
      location: map['location'],
      date: map['date'],
      time: map['time'],
      status: map['status'],
      userId: map['userId'],
      notes: map['notes'],
    );
  }

  // Convert to Map (for SQLite insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'location': location,
      'date': date,
      'time': time,
      'status': status,
      'userId': userId,
      'notes': notes,
    };
  }

  // Method to return a copy of the booking with updated status
  Booking copyWith({String? status}) {
    return Booking(
      id: this.id,
      serviceName: this.serviceName,
      location: this.location,
      date: this.date,
      time: this.time,
      status: status ?? this.status,
      userId: this.userId,
      notes: this.notes,
    );
  }
}
