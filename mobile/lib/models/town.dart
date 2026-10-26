class Town {
  final int id;
  final String name;
  final String state;
  final String country;
  final double? latitude;
  final double? longitude;

  const Town({
    required this.id,
    required this.name,
    required this.state,
    this.country = 'India',
    this.latitude,
    this.longitude,
  });

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      id: json['id'] as int,
      name: json['name'] as String,
      state: json['state'] as String? ?? 'Tamil Nadu',
      country: json['country'] as String? ?? 'India',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'state': state,
    'country': country,
    'latitude': latitude,
    'longitude': longitude,
  };
}
