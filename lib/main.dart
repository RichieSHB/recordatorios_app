import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';
import 'package:recordatorios_app/presentation/screens/home/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CasesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          colorSchemeSeed: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
