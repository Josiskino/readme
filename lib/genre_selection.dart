import 'package:flutter/material.dart';
import 'dart:async';

class GenreSelection extends StatefulWidget {
  const GenreSelection({super.key});

  @override
  _GenreSelectionState createState() => _GenreSelectionState();
}

class _GenreSelectionState extends State<GenreSelection> {
  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  final ScrollController _controller3 = ScrollController();

  final List<String> genres1 = ['Action', 'Comedy', 'Horror', 'Romance', 'Sci-Fi'];
  final List<String> genres2 = ['Drama', 'Thriller', 'Mystery', 'Fantasy', 'Adventure'];
  final List<String> genres3 = ['Animation', 'Documentary', 'Crime', 'Family', 'Western'];

  String? selectedGenre;

  @override
  void initState() {
    super.initState();
    startInfiniteScroll(_controller1, true);
    startInfiniteScroll(_controller2, false);
    startInfiniteScroll(_controller3, true);
  }

  void startInfiniteScroll(ScrollController controller, bool forward) {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!controller.hasClients) {
        timer.cancel();
        return;
      }

      double scrollAmount = forward ? 1.0 : -1.0;
      controller.jumpTo(controller.offset + scrollAmount);

      if (controller.offset >= controller.position.maxScrollExtent) {
        controller.jumpTo(controller.position.minScrollExtent);
      } else if (controller.offset <= controller.position.minScrollExtent) {
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });
  }

  Widget buildGenreContainer(String genre) {
    final isSelected = selectedGenre == genre;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGenre = genre;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          genre,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

Widget buildScrollingRow(List<String> genres, ScrollController controller,bool forward) {
  final repeatedGenres = [...genres, ...genres]; // Doublage des genres pour un défilement fluide

  return Transform.rotate(
    angle: - 0.1, // Inclinaison uniforme pour toutes les lignes (environ 5.7°)
    child: SizedBox(
      height: 60,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: repeatedGenres.length,
        itemBuilder: (context, index) {
          final genre = repeatedGenres[index % genres.length];
          return buildGenreContainer(genre);
        },
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAFAFA),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Choose Your\nFavorite Genre',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildScrollingRow(genres1, _controller1, true),
              buildScrollingRow(genres2, _controller2, false),
              buildScrollingRow(genres3, _controller3, true),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedGenre != null
                          ? 'Selected Genre: $selectedGenre'
                          : 'No Genre Selected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Skip'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
}