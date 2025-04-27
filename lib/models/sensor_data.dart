class SensorData {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double lightLevel;
  final double pollutionLevel; // Ajout du niveau de pollution
  final bool waterValveOpen; // État de la vanne d'eau

  SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.lightLevel,
    this.pollutionLevel = 0.0,
    this.waterValveOpen = false,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      timestamp: json['timestamp'] is String 
          ? DateTime.parse(json['timestamp']) 
          : json['timestamp'].toDate(),
      temperature: json['temperature']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toDouble() ?? 0.0,
      soilMoisture: json['soilMoisture']?.toDouble() ?? 0.0,
      lightLevel: json['lightLevel']?.toDouble() ?? 0.0,
      pollutionLevel: json['pollutionLevel']?.toDouble() ?? 0.0,
      waterValveOpen: json['waterValveOpen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'lightLevel': lightLevel,
      'pollutionLevel': pollutionLevel,
      'waterValveOpen': waterValveOpen,
    };
  }
}
