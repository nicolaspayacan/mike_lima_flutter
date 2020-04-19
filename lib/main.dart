import 'package:flutter/material.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/pages/mike_lima_home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mike Lima',
      theme: ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.amberAccent
      ),
      home: MikeLimaHomePage(),
    );
  }
}
