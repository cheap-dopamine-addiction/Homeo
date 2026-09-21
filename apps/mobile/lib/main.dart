import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/app/app.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DateFormat needs locale data; Material's delegates load it too, this
  // just guarantees it is ready before the first frame.
  await initializeDateFormatting();
  // Sentry / Firebase init goes here once those slices land.
  runApp(const ProviderScope(child: HomeoApp()));
}
