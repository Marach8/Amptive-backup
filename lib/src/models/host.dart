import 'package:amptive/src/models/user_model.dart';
import 'package:flutter/material.dart';

class Host extends AmptiveUser {
  Host(
      {required super.id,
      required super.username,
      required super.email,
      required super.profilePicture, required super.name});
}


class ObjectWithNotifier<T> {
  late T obj;
  ValueNotifier<bool> notifier = ValueNotifier(false);

  ObjectWithNotifier({required this.obj});
}