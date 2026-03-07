import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/models/user_model.dart';
import 'package:flutter/material.dart';

class Host extends AmptiveUser {
  Host(
      {required super.id,
      required super.username,
      required super.email,
      required super.profilePicture,
      required super.name,
      super.isSelected});

  factory Host.empty() => Host(
      id: null, username: null, email: null, profilePicture: null, name: null);
}

class ObjectWithNotifier<T> {
  ObjectWithNotifier({required this.obj});
  late T obj;
  ValueNotifier<bool> notifier = ValueNotifier<bool>(false);
}

class ATCohost<V> extends AmptiveUser {
  ATCohost({
    required super.id,
    required super.username,
    required super.email,
    required super.profilePicture,
    required super.name,
    super.isSelected,
    V? intialNotifierValue,
  }) : notifier = ValueNotifier<V?>(intialNotifierValue);

  factory ATCohost.empty() => ATCohost<V>(
      id: null, username: null, email: null, profilePicture: null, name: null);

  final ValueNotifier<V?> notifier;

  void updateNotifier(V newValue) => notifier.value = newValue;

  void dispose() => notifier.dispose();
}

class ATHashtag<V> {
  ATHashtag({
    required this.title,
    required this.id,
    this.subtitle = ATStrings.HASHTAG,
    V? intialNotifierValue,
  }) : notifier = ValueNotifier<V?>(intialNotifierValue);

  factory ATHashtag.empty() =>
      ATHashtag<V>(id: null, subtitle: null, title: null);

  final String? title, subtitle;
  final int? id;

  final ValueNotifier<V?> notifier;

  void updateNotifier(V newValue) => notifier.value = newValue;

  void dispose() => notifier.dispose();
}
