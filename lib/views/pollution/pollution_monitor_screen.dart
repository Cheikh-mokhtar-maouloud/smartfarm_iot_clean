// lib/views/pollution/pollution_monitor_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartfarm_iot1/controllers/pollution_controller.dart';
import 'package:smartfarm_iot1/models/sensor_data.dart';

class PollutionMonitorScreen extends StatefulWidget {
  const PollutionMonitorScreen({super.key});

  @override
  State<PollutionMonitorScreen> createState() => _PollutionMonitorScreenState();
}

class _PollutionMonitorScreenState extends State<PollutionMonitorScreen> {
  final PollutionController _pollutionController = PollutionController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Pollution Monitor'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<List<SensorData>>(
        stream: _pollutionController.getPollutionDataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pollutionData = snapshot.data!;

          if (pollutionData.isEmpty) {
            return const Center(child: Text('No pollution data available'));
          }

          // Calculer le niveau de pollution actuel
          final currentPollution = pollutionData.first.pollutionLevel;
          final pollutionStatus = _getPollutionStatus(currentPollution);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte d'information principale
                _buildPollutionStatusCard(currentPollution, pollutionStatus),

                const SizedBox(height: 24),

                // Graphique
                _buildPollutionChart(pollutionData),

                const SizedBox(height: 24),

                // Tableau de données
                _buildPollutionDataTable(pollutionData),

                const SizedBox(height: 24),

                // Recommandations
                _buildRecommendationsCard(pollutionStatus),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDataDialog(),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPollutionStatusCard(double pollutionLevel, String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Good':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Moderate':
        statusColor = Colors.yellow;
        statusIcon = Icons.info;
        break;
      case 'Unhealthy':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'Hazardous':
        statusColor = Colors.red;
        statusIcon = Icons.dangerous;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.help;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Air Quality',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${pollutionLevel.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'AQI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getPollutionDescription(status),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutionChart(List<SensorData> data) {
    // Limiter à 10 données pour la clarté
    final chartData = data.take(10).toList().reversed.toList();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                    final date = chartData[value.toInt()].timestamp;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                chartData.length,
                (index) =>
                    FlSpot(index.toDouble(), chartData[index].pollutionLevel),
              ),
              isCurved: true,
              color: Colors.purple,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.purple.withOpacity(0.2),
              ),
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutionDataTable(List<SensorData> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Readings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('AQI')),
                  DataColumn(label: Text('Status'))
                ],
                rows: data.take(5).map((item) {
                  final time =
                      '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}';
                  final status = _getPollutionStatus(item.pollutionLevel);

                  return DataRow(cells: [
                    DataCell(Text(time)),
                    DataCell(Text(item.pollutionLevel.toStringAsFixed(1))),
                    DataCell(Text(status))
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(String status) {
    String recommendation;
    IconData recommendationIcon;

    switch (status) {
      case 'Good':
        recommendation = 'Air quality is good. Enjoy outdoor activities!';
        recommendationIcon = Icons.directions_bike;
        break;
      case 'Moderate':
        recommendation =
            'Air quality is acceptable. Consider reducing prolonged outdoor exertion for sensitive groups.';
        recommendationIcon = Icons.directions_walk;
        break;
      case 'Unhealthy':
        recommendation =
            'Everyone may experience health effects. Sensitive groups should limit outdoor activities.';
        recommendationIcon = Icons.home;
        break;
      case 'Hazardous':
        recommendation =
            'Health alert! Everyone should avoid outdoor activities and use air purifiers indoors.';
        recommendationIcon = Icons.warning;
        break;
      default:
        recommendation =
            'Data unavailable. Check back later for recommendations.';
        recommendationIcon = Icons.help;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  recommendationIcon,
                  size: 28,
                  color: Colors.purple,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    recommendation,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPollutionStatus(double level) {
    if (level <= 50) {
      return 'Good';
    } else if (level <= 100) {
      return 'Moderate';
    } else if (level <= 150) {
      return 'Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  String _getPollutionDescription(String status) {
    switch (status) {
      case 'Good':
        return 'Air quality is considered satisfactory, and air pollution poses little or no risk.';
      case 'Moderate':
        return 'Air quality is acceptable; however, there may be a moderate health concern for a very small number of people.';
      case 'Unhealthy':
        return 'Members of sensitive groups may experience health effects. The general public is less likely to be affected.';
      case 'Hazardous':
        return 'Health warnings of emergency conditions. The entire population is likely to be affected.';
      default:
        return '';
    }
  }

  void _showAddDataDialog() {
    double pollutionValue = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Pollution Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter pollution level (AQI):'),
              Slider(
                value: pollutionValue,
                min: 0,
                max: 300,
                divisions: 300,
                label: pollutionValue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    pollutionValue = value;
                  });
                },
              ),
              Text(
                'Value: ${pollutionValue.round()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _pollutionController.addPollutionData(pollutionValue);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data added successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
