import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'movie_detail_page.dart';
import 'movie_model.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dub Track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for our new search field
  final TextEditingController _searchController = TextEditingController();
  // Renamed to be more generic, as it can hold popular movies or search results
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    // Load popular movies by default when the app starts
    _moviesFuture = _fetchPopularMovies();
  }

  // --- API Functions ---

  Future<List<Movie>> _fetchMovies(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((movieData) => Movie.fromMap(movieData)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> _fetchPopularMovies() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1&region=IN';
    return _fetchMovies(url);
  }

  Future<List<Movie>> _searchMovies(String query) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(query)}';
    return _fetchMovies(url);
  }

  // --- Helper function to trigger a search ---
  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      // If there's a search query, update the future to fetch search results
      setState(() {
        _moviesFuture = _searchMovies(query);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title is now a search field!
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for a movie...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white70),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white70),
                onPressed: () {
                  _searchController.clear();
                  // Reload popular movies when search is cleared
                  setState(() {
                    _moviesFuture = _fetchPopularMovies();
                  });
                },
              ),
            ),
            onSubmitted: (value) => _performSearch(),
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture, // The FutureBuilder now uses our state variable
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final movies = snapshot.data!;
            // The ListView.builder is unchanged
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    // This is the navigation logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie Poster
                          CachedNetworkImage(
                            imageUrl: movie.fullPosterPath,
                            width: 100,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          const SizedBox(width: 12),
                          // Movie Title and Overview
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),

                                // --- ADD THIS NEW ROW FOR THE RATING ---
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    // We get the vote_average from our movie model
                                    // and use toStringAsFixed(1) to show only one decimal place
                                    Text(
                                      movie.voteAverage.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Text(movie.overview, maxLines: 3, overflow: TextOverflow.ellipsis), // Changed to 3 lines
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No movies found. Try searching!'));
        },
      ),
    );
  }
}