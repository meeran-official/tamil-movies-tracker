class WatchProvider {
  final String providerName;
  final String logoPath;

  WatchProvider({
    required this.providerName,
    required this.logoPath,
  });

  factory WatchProvider.fromMap(Map<String, dynamic> map) {
    return WatchProvider(
      providerName: map['provider_name'],
      logoPath: map['logo_path'],
    );
  }

  String get fullLogoPath {
    if (logoPath.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$logoPath';
    }
    return ''; // Should not happen if data is good
  }
}