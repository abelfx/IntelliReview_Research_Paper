import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/%20viewmodels/category_bloc.dart';
import 'package:frontend/presentation/Screens/categoryview.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Category App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CategoryViewScreen(),
      ),
    );
  }
}
