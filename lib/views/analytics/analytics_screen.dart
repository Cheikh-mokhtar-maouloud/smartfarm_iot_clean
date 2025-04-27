import 'package:flutter/material.dart';
import 'package:smartfarm_iot1/controllers/sensor_controller.dart';
import 'package:smartfarm_iot1/models/sensor_data.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final SensorController _sensorController = SensorController();
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: StreamBuilder<List<SensorData>>(
        stream: _sensorController.getSensorDataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateRangeChip(),
                const SizedBox(height: 16),
                _buildAverageValues(data),
                const SizedBox(height: 24),
                _buildDataTable(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateRangeChip() {
    return Chip(
      label: Text(
        '${_dateRange.start.toString().split(' ')[0]} - '
        '${_dateRange.end.toString().split(' ')[0]}',
      ),
      deleteIcon: const Icon(Icons.close),
      onDeleted: _selectDateRange,
    );
  }

  Widget _buildAverageValues(List<SensorData> data) {
    if (data.isEmpty) return const SizedBox();

    double avgTemp = data.map((e) => e.temperature).reduce((a, b) => a + b) / data.length;
    double avgHumidity = data.map((e) => e.humidity).reduce((a, b) => a + b) / data.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Averages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Temperature: ${avgTemp.toStringAsFixed(1)}°C'),
            Text('Humidity: ${avgHumidity.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SensorData> data) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Temp')),
            DataColumn(label: Text('Humidity')),
            DataColumn(label: Text('Soil')),
            DataColumn(label: Text('Light')),
          ],
          rows: data.map((sensor) {
            return DataRow(cells: [
              DataCell(Text(sensor.timestamp.toString().split(' ')[0])),
              DataCell(Text('${sensor.temperature}°C')),
              DataCell(Text('${sensor.humidity}%')),
              DataCell(Text('${sensor.soilMoisture}%')),
              DataCell(Text('${sensor.lightLevel}%')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
    }
  }
}