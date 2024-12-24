import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:requests_with_riverpod/models/kind.dart';

class PickedColorNotifier extends StateNotifier<Color> {
  PickedColorNotifier() : super(Colors.brown);

  void changePickedColor(Color newColor) {
    state = newColor;
  }

  void backToInitial() {
    state = Colors.brown;
  }
}

final pickedColorProvider = StateNotifierProvider<PickedColorNotifier, Color>(
  (ref) => PickedColorNotifier(),
);

class SelectedKindNotifier extends StateNotifier<Kind?> {
  SelectedKindNotifier() : super(null);

  void changeSelectedKind(Kind kind) {
    state = kind;
  }

  void backToInitial() {
    state = null;
  }
}

final selectedKindProvider = StateNotifierProvider<SelectedKindNotifier, Kind?>(
    (ref) => SelectedKindNotifier());

class EnteredAgeNotifier extends StateNotifier<int> {
  EnteredAgeNotifier() : super(0);

  void changeEnteredAge(int age) {
    state = age;
  }

  void backToInitial() {
    state = 0;
  }
}

final enteredAgeProvider = StateNotifierProvider<EnteredAgeNotifier, int>(
    (ref) => EnteredAgeNotifier());

class EnteredDescriptionNotifier extends StateNotifier<String> {
  EnteredDescriptionNotifier() : super('');

  void changeEnteredDescription(String description) {
    state = description;
  }

  void backToInitial() {
    state = '';
  }
}

final enteredDescriptionProvider =
    StateNotifierProvider<EnteredDescriptionNotifier, String>(
        (ref) => EnteredDescriptionNotifier());
