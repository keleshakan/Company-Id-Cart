import 'package:flutter/material.dart';
import 'Quotes.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(
  home: QuoteList(),
));

class QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quotes> quotes = [
    Quotes(author:'Oscar Wilde' , text:'Be yourself man!'),
    Quotes(author:'Oscar Wilde' , text:'Be kind man!'),
    Quotes(author:'Oscar Wilde' , text:'Be strong man!'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Awesome Quote List'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: quotes.map((e) => QuoteCard(
          quote: e,
          delete: (){
            setState(() {
              quotes.remove(e);
            });
          }
        )).toList(),
      ),
    );
  }
}

