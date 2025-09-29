class MovieData {
  String title;
  int year;
  String genre;
  String director;
  List<String> casts;
  double rating;
  String synopsis;
  String imgUrl;
  String movieUrl;

  MovieData({
    required this.title,
    required this.year,
    required this.genre,
    required this.director,
    required this.casts,
    required this.rating,
    required this.synopsis,
    required this.imgUrl,
    required this.movieUrl,
  });
}
