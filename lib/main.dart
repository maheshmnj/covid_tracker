import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart' show APP_TITLE;
import 'models/search_model.dart';
import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchModel>(create: (_) => SearchModel()),
      ],
      child: MaterialApp(
        title: '$APP_TITLE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(title: '$APP_TITLE'),
      ),
    );
  }
}
