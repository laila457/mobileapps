import 'package:flutter/material.dart';

class BookPenitipanController {
  // This is a static method that handles the booking creation
  static Future<bool> saveBooking({
    required String ownerName,
    required String phoneNumber,
    required int petCount,
    required String petType,
    required String notes,
    required DateTime bookingDate,
    required String bookingTime,
    // Add the missing parameters
    String? package,
    bool? isDeliveryService,
    String? location,
  }) async {
    try {
      // In a real app, here you would call your API or database service
      // For now, we'll just simulate a successful booking
      
      // Log the booking details for debugging
      print('Booking saved:');
      print('Owner: $ownerName');
      print('Phone: $phoneNumber');
      print('Pet Type: $petType');
      print('Pet Count: $petCount');
      print('Date: ${bookingDate.toString()}');
      print('Time: $bookingTime');
      print('Notes: $notes');
      print('Package: $package');
      print('Delivery Service: $isDeliveryService');
      print('Location: $location');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return true to indicate success
      return true;
    } catch (e) {
      // Log the error
      print('Error saving booking: $e');
      // Return false to indicate failure
      return false;
    }
  }
}