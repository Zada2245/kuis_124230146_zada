// File: detail_page.dart

import 'package:flutter/material.dart';
import 'movie_model.dart'; // Impor model movie
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final MovieData movie; // Nama kelas model diperbaiki menjadi MovieData

  const DetailPage({
    super.key,
    required this.movie,
  }); // Nama parameter diperbaiki menjadi movie

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(
      widget.movie.movieUrl,
    ); // Menggunakan widget.movie
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Menampilkan SnackBar jika gagal membuka URL
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${url.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndSynopsis(),
                  SizedBox(height: 24),
                  _buildTags(),
                  SizedBox(height: 24),
                  _buildAboutSection(),
                  SizedBox(height: 24),
                  _buildReviewSection(), // Ini adalah widget yang hilang dan harus dipanggil
                  SizedBox(height: 32),
                  _buildStoreButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET BARU: SliverAppBar yang lebih rapi
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      stretch: true,
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 16.0),
        title: Text(
          widget.movie.title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        background: Hero(
          tag: widget.movie.title,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.movie.imgUrl.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.movie.imgUrl[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              // Gradient overlay untuk kontras teks
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.0],
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  ),
                ),
              ),
              // Indikator halaman (dots) yang lebih stylish
              Positioned(
                bottom: 16.0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.movie.imgUrl.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 24.0 : 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _currentPage == index
                            ? Colors.blueAccent
                            : Colors.white.withOpacity(0.5),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BARU: Judul dan Sinopsis
  Widget _buildTitleAndSynopsis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.movie.synopsis,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // WIDGET BARU: Tampilan Tags yang lebih modern
  Widget _buildTags() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.movie.tags
          .map(
            (tag) => Chip(
              label: Text(tag),
              labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
              backgroundColor: Colors.grey.shade800,
              side: BorderSide(color: Colors.grey.shade700),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
            ),
          )
          .toList(),
    );
  }

  // WIDGET BARU: Bagian "About"
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About This Movie',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.movie.synopsis,
          style: TextStyle(color: Colors.grey[400], fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  // WIDGET BARU: Tampilan Review dalam bentuk kartu statistik (DIKEMBALIKAN)
  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _reviewStatCard(
                'Average',
                widget.movie.reviewAverage,
                Icons.thumb_up_alt_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _reviewStatCard(
                'Total',
                widget.movie.reviewCount,
                Icons.people_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _reviewStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  // WIDGET BARU: Tombol Visit Store dengan lebar penuh dan gradien
  Widget _buildStoreButton() {
    return SizedBox(
      width: double.infinity,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ElevatedButton.icon(
          onPressed: _launchUrl,
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          label: const Text('Visit Store Page'),
          style:
              ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 8,
                shadowColor: Colors.blueAccent.withOpacity(0.5),
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.1),
                ),
              ),
        ),
      ),
    );
  }
}
