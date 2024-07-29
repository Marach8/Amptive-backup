import 'package:amptive/src/app.dart';
import 'package:amptive/src/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setup();
  runApp(
    MultiBlocProvider(
      providers: providers(),
      child: const AmptiveApp(),
    ),
  );
}
