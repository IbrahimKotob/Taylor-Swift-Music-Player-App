import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AlbumSongsPage extends StatelessWidget {
  final int albumIndex;

  AlbumSongsPage({Key? key, required this.albumIndex}) : super(key: key);

  final List<String> albumNames = [
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

  final List<String> albumBackgroundImages = [
    'https://i.pinimg.com/originals/77/ae/22/77ae224661b5874261df9cb5bdd5c6c9.jpg',
    'https://i.pinimg.com/originals/d8/70/0d/d8700d4c476564fd16d1c423b417173e.jpg',
    'https://i.pinimg.com/originals/4f/9e/d8/4f9ed8f31e5b0db5d359cb5e2bf36308.jpg',
    'https://i.pinimg.com/originals/5b/53/68/5b5368121f4eaad6de4761164d38e038.jpg',
    'https://i.pinimg.com/originals/61/a9/d7/61a9d7d9af67c2797e5c6a50f2fa0719.jpg',
    'https://i.pinimg.com/originals/76/f5/4f/76f54f25956eb4f905048ef5e9e25b1e.jpg',
    'https://i.pinimg.com/originals/b6/e5/59/b6e559521076600a5e2813ddf48e59e5.jpg',
    'https://i.pinimg.com/originals/a3/db/b5/a3dbb57867a487eb3b8020eeac029871.jpg',
    'https://i.pinimg.com/564x/30/80/17/308017584af1e4c59c9c1053182ce023.jpg',
    'https://i.pinimg.com/originals/0a/78/fe/0a78fe28c64c2f0bcac23e650fe9f5a9.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Album ${albumIndex + 1}: ${getAlbumName(albumIndex)} Songs'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(albumBackgroundImages[albumIndex]),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: fetchSongsForAlbum(albumNames[albumIndex]),
          builder: (context, AsyncSnapshot<List<Song>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No songs available for ${getAlbumName(albumIndex)}'));
            } else {
              List<Song> songs = snapshot.data!;
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white, // Set a white background for each list item
                    child: ListTile(
                      title: Text(songs[index].title),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongDetailsPage(song: songs[index], background: albumBackgroundImages[albumIndex]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  String getAlbumName(int index) {
    return index >= 0 && index < albumNames.length ? albumNames[index] : 'Unknown Album';
  }

  Future<List<Song>> fetchSongsForAlbum(String albumName) async {
    CollectionReference songsCollection = FirebaseFirestore.instance.collection('ts_songs');

    try {
      print('Fetching songs for album: $albumName');
      QuerySnapshot querySnapshot = await songsCollection.where('album', isEqualTo: albumName).get();

      List<Song> songs = [];
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        print('Document data: ${documentSnapshot.data()}');
        songs.add(Song.fromSnapshot(documentSnapshot));
      }

      print('Fetched songs: $songs');

      return songs;
    } catch (error) {
      print('Error fetching songs: $error');
      return [];
    }
  }
}

class Song {
  final String title;
  final String length;
  final String mood;
  final String lyrics;
  final String url; // New field for the YouTube URL

  Song({
    required this.title,
    required this.length,
    required this.mood,
    required this.lyrics,
    required this.url,
  });

  factory Song.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return Song(
      title: snapshot['title'],
      length: snapshot['length'],
      mood: snapshot['mood'],
      lyrics: snapshot['lyrics'],
      url: snapshot['url'],
    );
  }
}

class SongDetailsPage extends StatelessWidget {
  final Song song;
  final String background;

  const SongDetailsPage({Key? key, required this.song, required this.background}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRect(
              child: Card(
                color: Colors.white, // Set a white background for the card
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _extractVideoId(song.url),
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.blueAccent,
                          handleColor: Colors.blueAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Title: ${song.title}'),
                            Text('Length: ${song.length}'),
                            Text('Mood: ${song.mood}'),
                            Text('Lyrics: ${song.lyrics}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to extract video ID from YouTube URL
  String _extractVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host == 'www.youtube.com' || uri.host == 'm.youtube.com') {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }
}


