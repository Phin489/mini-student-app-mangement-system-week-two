import 'package:flutter/material.dart';

class DevReportScreen extends StatelessWidget {
  const DevReportScreen({super.key});

  Future<String> _loadReport(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/dev_report.md');
  }

  @override
  Widget build(BuildContext context) {
    final futureReport = _loadReport(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Development Report'),
      ),
      body: FutureBuilder(
        future: futureReport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                snapshot.data ?? '',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}