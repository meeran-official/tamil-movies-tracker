import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tamil_track/watch_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tamil_track/watch_provider_model.dart';
import 'movie_model.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isLoading = true;
  bool _isTamilDubAvailable = false;
  // New state variable to hold the list of streaming services
  List<WatchProvider> _watchProviders = [];

  @override
  void initState() {
    super.initState();
    _fetchMovieData();
  }

  // Renamed the function to be more accurate
  Future<void> _fetchMovieData() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null) throw Exception("API Key not found");

    // The new, more powerful API URL
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movie.id}?api_key=$apiKey&append_to_response=translations,watch/providers';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // --- Check for Tamil Dub ---
        final List translations = data['translations']['translations'];
        for (var translation in translations) {
          if (translation['iso_639_1'] == 'ta') {
            _isTamilDubAvailable = true;
            break;
          }
        }

        // --- NEW: Check for Watch Providers in India ---
        final providersData = data['watch/providers']['results']['IN'];
        if (providersData != null && providersData['flatrate'] != null) {
          final List providerList = providersData['flatrate'];
          _watchProviders =
              providerList.map((p) => WatchProvider.fromMap(p)).toList();
        }
      }
    } catch (e) {
      print("Error fetching movie data: $e");
    }

    // Update the UI
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            // --- The Movie Poster ---
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: widget.movie.fullPosterPath,
                  height: 300,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- The Movie Title ---
            Center(
              child: Text(widget.movie.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),

            // --- The Dub Status Card ---
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Card(
                color: _isTamilDubAvailable
                    ? Colors.green[800]
                    : Colors.red[800],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          _isTamilDubAvailable
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        _isTamilDubAvailable
                            ? "Tamil Dub Available"
                            : "Tamil Dub Not Found",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- The NEW "WHERE TO WATCH" SECTION ---
            if (!_isLoading && _watchProviders.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Available On (Subscription):",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  SizedBox(
                    height: 70, // Give the list a fixed height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Scroll left-to-right
                      itemCount: _watchProviders.length,
                      itemBuilder: (context, index) {
                        final provider = _watchProviders[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: provider.fullLogoPath,
                              width: 54, // Fixed width for logos
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            // --- The Overview Section ---
            const Text("Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(widget.movie.overview,
                style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}