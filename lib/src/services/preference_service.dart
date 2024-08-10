import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/preferences.dart';

class PreferenceService {
  final List<Preferences> _items = [
    Preferences.card("Music", const Color(0xFFEF8C62), const Color(0xFFEF6262)),
    Preferences.card("Art", const Color(0xFFD95335), const Color(0xFFD93535)),
    Preferences.card(
        "Society", const Color(0xFFF9C407), const Color(0xFFD9550C)),
    Preferences.card(
        "Technology", const Color(0xFFD9550C), const Color(0xFFD93535)),
    Preferences.card(
        "Sports", const Color(0xFF009C51), const Color(0xFF009C80)),
    Preferences.card(
        "True Crime", const Color(0xFF005A9C), const Color(0xFF00249C)),
    Preferences.card(
        "Business", const Color(0xFFE14C1D), const Color(0xFFE1721D)),
    Preferences.card(
        "Spirituality", const Color(0xFFEF8C62), const Color(0xFFEF6262)),
    Preferences.card(
        "Relationship", const Color(0xFFD95335), const Color(0xFFD93535)),
    Preferences.card(
        "Science", const Color(0xFF792166), const Color(0xFF722179)),
    Preferences.card(
        "Comedy", const Color(0xFF7B0054), const Color(0xFF7B003B)),
    Preferences.card("News", const Color(0xFF307FE2), const Color(0xFF306DE2)),
  ];

  List<Preferences> get items => _items;

  void toggleSelectedByIndex(int index) {
    _items[index].isSelected = !_items[index].isSelected;
  }

  List<Preferences> getSelected() {
    return _items.where((obj) => obj.isSelected).toList();
  }

  Future<void> getAll() async {
    await Future.delayed(Durations.extralong4);

  }

  Future<void> personalize() async {
    await Future.delayed(const Duration(seconds: 8));
  }
}
