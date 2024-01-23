import 'package:flutter/material.dart';
import 'AlbumSongsPage.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taylor Swift Albums'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://i.pinimg.com/564x/68/12/50/68125057ce8c77a5a11955855e47a9ca.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 10, // Number of albums
          itemBuilder: (BuildContext context, int index) {
            // Replace the placeholder with your album images
            String albumImageUrl = getAlbumImageUrl(index);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumSongsPage(albumIndex: index),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // Replace the placeholder with your album images
                    image: NetworkImage(albumImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String getAlbumImageUrl(int index) {
    // Replace with the actual URLs for each album
    switch (index) {
      case 0:
        return 'https://i.pinimg.com/originals/f2/f1/40/f2f14005df7f1ab3552ae121907ffc7f.jpg';
      case 1:
        return 'https://i.pinimg.com/originals/bc/76/61/bc76611fda46e6956057a631777377ad.jpg';
      case 2:
        return 'https://i.pinimg.com/originals/19/3a/72/193a72197eb88e04a7a96014a3cdd23c.jpg';
      case 3:
        return 'https://i.pinimg.com/originals/5e/1e/58/5e1e58425b59ad9e86b3abcc400bd193.jpg';
      case 4:
        return 'https://i.pinimg.com/originals/a7/0f/0b/a70f0b64fa718b20694b91f67c710bd4.jpg';
      case 5:
        return 'https://i.pinimg.com/564x/81/d8/df/81d8dffcb104d73a91f06cca6dff620a.jpg';
      case 6:
        return 'https://i.pinimg.com/originals/a6/a5/bb/a6a5bba86743c42b1b587384a57e0487.jpg';
      case 7:
        return 'https://i.pinimg.com/originals/12/d1/14/12d11437297d4183a646af986b152422.jpg';
      case 8:
        return 'https://i.pinimg.com/originals/90/76/e4/9076e4341a204b30152c4ba32ea39d70.jpg';
      case 9:
        return 'https://i.pinimg.com/originals/96/bf/38/96bf38ff9e7d816e3b241d5a2ecf80d9.jpg';

    // Add more cases for other albums
      default:
        return 'https://i.pinimg.com/originals/a5/dd/d3/a5ddd313774344d0e81d986087fbe53e.jpg';
    }
  }
}
