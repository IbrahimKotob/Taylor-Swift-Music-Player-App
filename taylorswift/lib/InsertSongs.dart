import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsertSongs extends StatefulWidget {
  const InsertSongs({Key? key});

  @override
  _InsertSongsState createState() => _InsertSongsState();
}

class _InsertSongsState extends State<InsertSongs> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  final List<String> albumOptions = [
    'Debut',
    'Fearless',
    'Speak Now',
    'Red',
    '1989',
    'Reputation',
    'Lover',
    'Folklore',
    'Evermore',
    'Midnights',
  ];

  String _selectedAlbum = 'Debut';

  @override
  void dispose() {
    _titleController.dispose();
    _lengthController.dispose();
    _lyricsController.dispose();
    _moodController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Songs'),
      ),
      body: Container(
        color: Colors.purple[100], // Set the background color to light purple
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/564x/68/12/50/68125057ce8c77a5a11955855e47a9ca.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Enter Title',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _lengthController,
                  decoration: InputDecoration(
                    labelText: 'Enter Length',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedAlbum,
                  items: albumOptions.map((album) {
                    return DropdownMenuItem<String>(
                      value: album,
                      child: Text(
                        album,
                        style: TextStyle(
                          color: Colors.black, // Set text color to black
                          fontSize: 18.0,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAlbum = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Album',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _lyricsController,
                  decoration: InputDecoration(
                    labelText: 'Enter Lyrics',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _moodController,
                  decoration: InputDecoration(
                    labelText: 'Enter Mood',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Enter URL',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String newTitle = _titleController.text;
                    String newLength = _lengthController.text;
                    String newLyrics = _lyricsController.text;
                    String newMood = _moodController.text;
                    String newUrl = _urlController.text;

                    insertSong(newTitle, newLength, _selectedAlbum, newLyrics, newMood, newUrl);

                    _titleController.clear();
                    _lengthController.clear();
                    _lyricsController.clear();
                    _moodController.clear();
                    _urlController.clear();
                  },
                  child: const Text(
                    'Insert',
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> insertSong(String title, String length, String album, String lyrics, String mood, String url) async {
    CollectionReference songsCollection = FirebaseFirestore.instance.collection('ts_songs');

    try {
      await songsCollection.add({
        'title': title,
        'length': length,
        'album': album,
        'lyrics': lyrics,
        'mood': mood,
        'url': url,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song inserted successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print('Error inserting song: $error');
    }
  }
}
