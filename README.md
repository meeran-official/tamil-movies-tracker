# Tamil Track 🎬

> Because finding Tamil dubs shouldn't be harder than understanding the plot twist in Inception.

A Flutter app that actually solves a real problem - tracking Tamil dubbed movies and where to stream them. No more endless scrolling through Netflix wondering "Is this dubbed or am I gonna be reading subtitles for 3 hours?"

## What This Bad Boy Does 🚀

**For End Users (The People Who Matter):**
- **Search & Discover**: Search for any movie and get the 411 on whether it's Tamil dubbed
- **Streaming Intel**: Find out exactly where you can stream it in India (Netflix, Prime, etc.)
- **Popular Movies**: Browse trending flicks without having to think too hard
- **Detailed Info**: Movie posters, descriptions, and all the metadata your heart desires
- **Clean UI**: Dark theme because we're not savages who burn our retinas

**What You Get:**
- ✅ Tamil dub availability checker (the whole point)
- ✅ Streaming platform finder for Indian users
- ✅ Movie search that actually works
- ✅ Clean Material 3 UI that doesn't look like it's from 2010
- ✅ Cached images because nobody likes waiting for posters to load

## Tech Stack (For The Devs) 🛠️

**Frontend:**
- **Flutter** (3.8.1+) - Because cross-platform is life
- **Material 3** - Google's design language that actually looks good
- **Dart** - The language that makes sense

**Key Dependencies:**
```yaml
dependencies:
  http: ^1.2.1                    # API calls (duh)
  flutter_dotenv: ^5.1.0         # Environment vars (keep secrets secret)
  cached_network_image: ^3.3.1   # Image caching (performance++)
```

**Data Source:**
- **TMDB API** - The Movie Database API for all movie data
- **Watch Providers API** - For streaming platform availability

**Architecture:**
- Standard Flutter widget tree (no fancy state management... yet)
- RESTful API integration
- Future/async patterns for data fetching
- Model classes for type safety

## Setup for Devs 💻

**Prerequisites:**
- Flutter SDK 3.8.1+
- Android Studio / VS Code (whatever floats your boat)
- A functioning brain and coffee

**Quick Start:**
```bash
# Clone this beauty
git clone <your-repo-url>
cd tamil_track

# Get dependencies
flutter pub get

# Create your .env file (IMPORTANT!)
# Add your TMDB API key: TMDB_API_KEY=your_key_here
cp .env.example .env

# Run it
flutter run
```

**Environment Setup:**
1. Get a TMDB API key from [themoviedb.org](https://developers.themoviedb.org/3)
2. Create `.env` file in project root
3. Add: `TMDB_API_KEY=your_actual_api_key`
4. Don't commit the .env file (it's already in .gitignore, but just saying)

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point & home page
├── movie_detail_page.dart    # Individual movie details
├── movie_model.dart          # Movie data model
└── watch_provider_model.dart # Streaming platform model
```

**Key Files:**
- `main.dart` - Home page with search and popular movies list
- `movie_detail_page.dart` - Detailed view with Tamil dub check
- `*_model.dart` - Data models (because types matter)

## API Integration 🔌

**TMDB Endpoints Used:**
- `/movie/popular` - Get trending movies
- `/search/movie` - Search for specific movies
- `/movie/{id}` - Get detailed movie info with translations and watch providers

**Tamil Dub Detection:**
Checks the `translations` field for `iso_639_1: 'ta'` (Tamil language code)

## Contributing (If You're Feeling Generous) 🤝

**What Needs Work:**
- [ ] State management (Provider/Bloc/Riverpod - pick your poison)
- [ ] Better error handling (currently just prints to console like a noob)
- [ ] User favorites/watchlist
- [ ] Better UI animations
- [ ] Tests (I know, I know...)
- [ ] Regional streaming platforms beyond India

**Code Style:**
- Follow Flutter/Dart conventions
- Use meaningful variable names (no `var a, b, c` nonsense)
- Comment your weird code
- Format with `dart format`

## Known Issues & TODOs 🐛

- Error handling is basic (catches exceptions but UX could be better)
- No offline mode (internet required, deal with it)
- Limited to Indian streaming platforms
- No user accounts/preferences (stateless for now)

## License 📄

Whatever license lets you use this without hassle. It's for finding Tamil dubs, not launching rockets.

---

*Built with ☕ and the frustration of not knowing if a movie is dubbed before starting it.*
