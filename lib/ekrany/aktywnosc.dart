import 'package:flutter/material.dart';
import '../widgets/charts/histogram/histogram.dart';
import '../widgets/common/main_shape.dart';
import '../services/database_service.dart';

class Aktywnosc extends StatefulWidget {
  final DatabaseService databaseService;

  const Aktywnosc({super.key, required this.databaseService});

  @override
  State<Aktywnosc> createState() => _AktywnoscState();
}

class _AktywnoscState extends State<Aktywnosc> {
  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  // Data
  List<int> tygodniowePodsumowanie = [];
  int todaySteps = 0;
  int calories = 0;
  int distanceKm = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load activity data from database service
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load data from service (currently returns mock data)
      final steps = await widget.databaseService.getWeeklySteps();
      final todayStepsData = await widget.databaseService.getTodaySteps();
      final caloriesData = await widget.databaseService.getTodayCalories();
      final distanceData = await widget.databaseService.getTodayDistanceKm();

      if (mounted) {
        setState(() {
          tygodniowePodsumowanie = steps;
          todaySteps = todayStepsData;
          calories = caloriesData;
          distanceKm = distanceData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load activity data: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int myIndex = 2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 64, 155, 197),
        title: const Center(child: Text('Aktywność')),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 1) {
            Navigator.pushNamed(context, '/startowy');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/glowny');
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 217, 127, 201),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Mój Ring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Podsumowanie",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "Więcej",
          ),
        ],
      ),
    );
  }

  /// Build the body with loading/error/content states
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Stack(
      children: [
        /*Positioned.fill(
          child: Image.asset('assets/tlo_aktywnosc.jpg', fit: BoxFit.cover),
        ),*/
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30.0,
            children: <Widget>[
              MainShape(
                kolor: const Color.fromARGB(255, 130, 167, 197),
                nazwa: 'kroki: $todaySteps',
              ),
              SizedBox(
                height: 200,
                child: MyHistogram(
                  tygodniowePodsumowanie: tygodniowePodsumowanie,
                ),
              ),
              MainShape(
                kolor: const Color.fromARGB(255, 130, 167, 197),
                nazwa: 'spalone kalorie: $calories',
              ),
              MainShape(
                kolor: const Color.fromARGB(255, 130, 167, 197),
                nazwa: 'przebyty dystans: $distanceKm km',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
