import 'package:flutter/material.dart';
import 'package:flutterofflinecash/Homescreen.dart';
import 'package:flutterofflinecash/Statemanagement/Provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostModelAdapter()); // Register the adapter
  await Hive.openBox('postsBox'); // Open Hive box
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostProvider()..fetchPosts()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PostScreen(),
      ),
    );
  }
}
