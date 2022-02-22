import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/books.dart';

const favoritesBox = 'favorite_books';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(favoritesBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget getIcon(int index) {
    if (Hive.box<String>(favoritesBox).containsKey(index)) {
      return const Icon(Icons.favorite, color: Colors.red);
    }
    return const Icon(Icons.favorite_border);
  }

  void onFavoritePress(int index) {
    if (Hive.box<String>(favoritesBox).containsKey(index)) {
      Hive.box<String>(favoritesBox).delete(index);
      return;
    }
    Hive.box<String>(favoritesBox).put(index, books[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Favorite Books'),
          ),
          body: ValueListenableBuilder<Box<String>>(
            valueListenable: Hive.box<String>(favoritesBox).listenable(),
            builder: (context, value, _) {
              return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, listIndex) {
                    return ListTile(
                      title: Text(books[listIndex]),
                      trailing: IconButton(
                          onPressed: () => onFavoritePress(listIndex),
                          icon: getIcon(listIndex)),
                    );
                  });
            },
          )),
    );
  }
}
