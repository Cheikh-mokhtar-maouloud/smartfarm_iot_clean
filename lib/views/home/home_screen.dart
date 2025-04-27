import 'package:flutter/material.dart';
import 'package:smartfarm_iot1/views/home/widgets/dashboard_card.dart';
import 'package:smartfarm_iot1/views/home/widgets/sensor_chart.dart';
import 'package:smartfarm_iot1/controllers/sensor_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Farm Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Implement settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                DashboardCard(
                  title: 'Temperature',
                  value: '25°C',
                  icon: Icons.thermostat,
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: 'Humidity',
                  value: '65%',
                  icon: Icons.water_drop,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: 'Soil Moisture',
                  value: '45%',
                  icon: Icons.grass,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: 'Light',
                  value: '75%',
                  icon: Icons.light_mode,
                  color: Colors.yellow,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Sensor Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const SensorChart(),
          ],
        ),
      ),

    );
  }
}
