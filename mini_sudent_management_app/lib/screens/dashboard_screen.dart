import 'package:flutter/material.dart';
import 'package:mini_sudent_management_app/database/database_helper.dart';
import 'package:mini_sudent_management_app/models/student_model.dart';

class DashboardScreen extends StatefulWidget {
  final Student? student;

  const DashboardScreen({super.key, this.student});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _studentCount = 0;
  List<Student> _recentStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      final dbHelper = DatabaseHelper.instance;
      final count = await dbHelper.getStudentCount();
      final allStudents = await dbHelper.getAllStudents();
      final recent = List<Student>.from(allStudents.reversed.take(5));

      if (mounted) {
        setState(() {
          _studentCount = count;
          _recentStudents = recent;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: ${e.toString()}')),
        );
      }
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Student Management System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.student != null)
                    Text(
                      'Logged in as: ${widget.student!.name}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('All Students'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/all_students');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add New Student'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/register');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Students',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_studentCount',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Recent Students',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (widget.student != null)
                    Chip(
                      label: Text('Welcome, ${widget.student!.name}'),
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      avatar: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _recentStudents.isEmpty
                        ? const Center(child: Text('No students registered yet'))
                        : ListView.builder(
                            itemCount: _recentStudents.length,
                            itemBuilder: (context, index) {
                              final student = _recentStudents[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(student.name),
                                  subtitle: Text(
                                    'Reg: ${student.registrationNumber} | ${student.course}',
                                  ),
                                  trailing: Chip(
                                    label: Text('Year ${student.year}'),
                                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}