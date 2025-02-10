// main.dart
import 'package:doc_proc/employee_table.dart';
import 'package:doc_proc/doc_section.dart';
import 'package:doc_proc/theme_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const VortelApp());
}

class VortelApp extends StatelessWidget {
  const VortelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Employee Documents Manager',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: NavigationWrapper());
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(
      initialPage: _selectedIndex,
      keepPage: true,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            minExtendedWidth: 200,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Employees'),
              ),
            ],
            selectedIndex: _selectedIndex,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                EmployeeTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
