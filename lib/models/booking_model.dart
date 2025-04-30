class BookingModel {
  int? id;
  final String ownerName;
  final String phoneNumber;
  final int petCount;
  final String petType;
  final String notes;
  final String bookingDate;
  final String bookingTime;
  String? createdAt;

  BookingModel({
    this.id,
    required this.ownerName,
    required this.phoneNumber,
    required this.petCount,
    required this.petType,
    required this.notes,
    required this.bookingDate,
    required this.bookingTime,
    this.createdAt,
  });

  // Convert model to map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_name': ownerName,
      'phone_number': phoneNumber,
      'pet_count': petCount,
      'pet_type': petType,
      'notes': notes,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'created_at': createdAt,
    };
  }

  // Create model from map (from database)
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      ownerName: map['owner_name'],
      phoneNumber: map['phone_number'],
      petCount: map['pet_count'],
      petType: map['pet_type'],
      notes: map['notes'],
      bookingDate: map['booking_date'],
      bookingTime: map['booking_time'],
      createdAt: map['created_at'],
    );
  }

  // For API integration - convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'owner_name': ownerName,
      'phone_number': phoneNumber,
      'pet_count': petCount,
      'pet_type': petType,
      'notes': notes,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
    };
  }

  // Create model from JSON response
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      ownerName: json['owner_name'],
      phoneNumber: json['phone_number'],
      petCount: json['pet_count'],
      petType: json['pet_type'],
      notes: json['notes'],
      bookingDate: json['booking_date'],
      bookingTime: json['booking_time'],
      createdAt: json['created_at'],
    );
  }
}