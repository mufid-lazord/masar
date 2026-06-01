import 'package:flutter/material.dart';

class Service {
  final int id;
  final String name;
  final String category;
  final String description;
  final String address;
  final String phone;
  final double rating;
  final int reviewsCount;
  final double latitude;
  final double longitude;
  final String imageEmoji;
  final IconData icon;
  final Color color;
  final List<String> features;
  final String workingHours;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.phone,
    required this.rating,
    required this.reviewsCount,
    required this.latitude,
    required this.longitude,
    required this.imageEmoji,
    required this.icon,
    required this.color,
    required this.features,
    required this.workingHours,
  });
}
