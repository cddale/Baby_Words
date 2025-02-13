import 'package:baby_words_tracker/util/check_and_update_words.dart';
import 'package:flutter/material.dart';
import 'package:baby_words_tracker/data/models/word_tracker.dart';
import 'package:baby_words_tracker/util/language_code.dart';
import 'package:baby_words_tracker/util/part_of_speech.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:baby_words_tracker/data/services/child_data_service.dart';
import 'package:baby_words_tracker/data/services/parent_data_service.dart';
import 'package:baby_words_tracker/data/services/word_data_service.dart';
import 'package:baby_words_tracker/data/services/word_tracker_data_service.dart';
import 'package:baby_words_tracker/data/models/child.dart';
import 'package:baby_words_tracker/data/models/parent.dart';
import 'package:baby_words_tracker/data/models/word.dart';

class AddTextPage extends StatefulWidget {
  const AddTextPage({super.key, required this.title});

  final String title;

  @override
  State<AddTextPage> createState() => _AddTextPageState();
}

class _AddTextPageState extends State<AddTextPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> parsedWords = [];

  void _parseWords() {
    String text = _controller.text;
    String cleanedText = text.replaceAll(RegExp(r'[^\w\s]'), ''); // Remove punctuation
    parsedWords = cleanedText.split(' ');   
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color(0xFF828A8F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Baby Word Tracker', style: TextStyle(color: Color(0xFF9E1B32), 
                                                         fontSize: 24,        
                                                         fontWeight: FontWeight.bold, 
                                                        ),
                    ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF9E1B32),
        child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Icon(
              Icons.home,
              color: Colors.white,
              size: 40.0,
              ),
          Icon(
              Icons.chat_bubble_outlined,
              color: Colors.white,
              size: 40.0,
          ),
          Icon(
              Icons.bar_chart_outlined,
              color: Colors.white,
              size: 40.0,
          ),
  ],
)
  ),
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          const SizedBox(
            height : 120,
          ),
          const Center(
            child: Text(
              'Add Words',
              style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(
            height : 80,
            ),
          const Text(
            'My Child Said...',
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
            hintText: 'Enter word or sentence',
            hintStyle: TextStyle(color: Colors.white),
            filled: true,  
            fillColor: Color(0xFF9E1B32),
            ),
          ),
            Center(
              child: OutlinedButton(
                onPressed: () async {  
                final childDataService = context.read<ChildDataService>();
                final wordDataService = context.read<WordDataService>();
                final wordTrackerDataService = context.read<WordTrackerDataService>();

                _parseWords();

                for (var word in parsedWords){
                  Word? result = await checkAndUpdateWords(word);
                  if(result != null){
                    addWordToChild(word, childDataService, wordDataService, wordTrackerDataService);
                  }
                  else{
                    if (!context.mounted) return;
                    await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text('$word not found, please try again'),
                      actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _controller.clear();
                          },
                        ),
                      ],
                    );
                  },
                );
                break;
                }
                }
                if (!context.mounted) return;
                    await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Words successfully submitted'),
                      actions: <Widget>[
                    TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
                _controller.clear();
                },
                style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xFF828A8F), 
                foregroundColor: Colors.white,        
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),  
            ),
            side: const BorderSide(color: Colors.white, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0), 
            ),
            child: const Text('Submit', style: TextStyle(fontSize: 18)),
)
            ),
          ],
        ),
      ),
      
    );
  }
}

Future<void> addWordToChild(String word, ChildDataService childService, WordDataService wordService, WordTrackerDataService trackerService, {String id = "gz1Qe32xJcF0oRGmhw7f"})
async {
  if (childService.getChild(id) == null)
  {
    return;
  }
  //FIXME: implement language, part of speech, defn, spellcheck
  //Word wordObject = await wordService.createWord(word, [LanguageCode.en], PartOfSpeech.noun, "testWord");
  trackerService.createWordTracker(id, word, DateTime.now());
}