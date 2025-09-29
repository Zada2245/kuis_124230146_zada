import 'package:belajar/movie_model.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final MovieData movie;

  const DetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: movie.title,
                child: Image.network(
                  movie.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.movie_creation_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(),
                    SizedBox(height: 20),
                    _buildSectionTitle('Sinopsis'),
                    SizedBox(height: 8),
                    Text(
                      movie.synopsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Pemeran'),
                    SizedBox(height: 8),
                    // Menampilkan daftar pemeran
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: movie.casts
                          .map((cast) => Chip(label: Text(cast)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan judul section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // Widget untuk menampilkan info rating, genre, dan tahun
  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${movie.genre} | ${movie.year}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Sutradara: ${movie.director}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 24),
            SizedBox(width: 4),
            Text(
              movie.rating.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
