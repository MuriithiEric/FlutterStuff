import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // <-- add ChangeNotifier here to notify listeners when the state changes
  var current = WordPair
      .random(); // <-- add this line here to store the current word pair in the state object
  void getNext() {
    // <-- add this method here to get the next word pair and notify listeners
    current =
        WordPair.random(); // <-- add this line here to get the next word pair
    notifyListeners(); // <-- add this line here to notify listeners
  }

  var favorites = <WordPair>[]; // <-- add this line here to store favorites

  void toggleFavorite() {
    // <-- add this method here to toggle favorites
    if (favorites.contains(current)) {
      // <-- add this line here to check if the current word pair is already a favorite
      favorites.remove(
          current); // <-- add this line here to remove the current word pair from the favorites list
    } else {
      // <-- add this line here to add the current word pair to the favorites list
      favorites.add(
          current); // <-- add this line here to add the current word pair to the favorites list
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10), // used to add some space
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  // <-- use ElevatedButton.icon here
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  label: Text("Like"), // <-- add a label here
                  icon: Icon(
                      icon), // <-- add an icon here (use Icons.favorite) to show a heart
                ),
                SizedBox(width: 10), // used to add some space
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text("Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); // <-- get the theme from context here
    final style = theme.textTheme.copyWith().displayMedium!.copyWith(
          color: theme.colorScheme.onPrimary,
        ); // <-- use the theme here to get the text style
    return Card(
      color: theme.colorScheme
          .primary, // <-- use the theme here to get the primary color
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ), // <-- use the style here
      ),
    );
  }
}
