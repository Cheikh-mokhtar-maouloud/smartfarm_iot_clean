class SensorData {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double lightLevel;

  SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.lightLevel,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      soilMoisture: json['soilMoisture'].toDouble(),
      lightLevel: json['lightLevel'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'lightLevel': lightLevel,
    };
  }
}