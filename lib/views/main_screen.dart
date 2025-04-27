// lib/views/main_screen.dart
import 'package:flutter/material.dart';
import 'package:smartfarm_iot1/views/home/home_screen.dart';
import 'package:smartfarm_iot1/views/analytics/analytics_screen.dart';
import 'package:smartfarm_iot1/views/settings/settings_screen.dart';
import 'package:smartfarm_iot1/views/irrigation/water_control_screen.dart';
import 'package:smartfarm_iot1/views/pollution/pollution_monitor_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const WaterControlScreen(),
    const PollutionMonitorScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Irrigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Pollution',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}