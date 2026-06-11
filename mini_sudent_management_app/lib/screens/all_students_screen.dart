import 'package:flutter/material.dart';
import 'package:mini_sudent_management_app/database/database_helper.dart';
import 'package:mini_sudent_management_app/models/student_model.dart';
import 'package:mini_sudent_management_app/screens/registration_screen.dart';

class AllStudentsScreen extends StatefulWidget {
  const AllStudentsScreen({super.key});

  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  List<Student> _students = [];
  bool _isLoading = true;
  bool _isDeleting = false;
  int? _deletingId;

  final List<String> _courses = [
    'Computer Science',
    'Information Technology',
    'Business',
    'Engineering',
  ];

  final List<int> _years = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final students = await DatabaseHelper.instance.getAllStudents();
      if (mounted) {
        setState(() {
          _students = students;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load students: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _confirmDelete(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;
    setState(() {
      _isDeleting = true;
      _deletingId = student.id;
    });

    try {
      await DatabaseHelper.instance.deleteStudent(student.id!);
      await _loadStudents();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
          _deletingId = null;
        });
      }
    }
  }

  Future<void> _openEditDialog(Student student) async {
    String? selectedCourse = student.course;
    int? selectedYear = student.year;

    final nameController = TextEditingController(text: student.name);
    final phoneController = TextEditingController(text: student.phoneNumber);

    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedCourse,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  items: _courses
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCourse = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'Year of Study',
                    border: OutlineInputBorder(),
                  ),
                  items: _years
                      .map((y) => DropdownMenuItem(value: y, child: Text('Year $y')))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedYear = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );

    if (updated != true) return;

    try {
      final updatedStudent = Student(
        id: student.id,
        name: nameController.text.trim(),
        registrationNumber: student.registrationNumber,
        course: selectedCourse ?? student.course,
        year: selectedYear ?? student.year,
        phoneNumber: phoneController.text.trim(),
        password: student.password,
      );

      await DatabaseHelper.instance.updateStudent(updatedStudent);
      await _loadStudents();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadStudents,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _students.isEmpty
                    ? const Center(child: Text('No students registered yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final student = _students[index];
                          final initial = student.name.isNotEmpty
                              ? student.name[0].toUpperCase()
                              : '?';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () => _openEditDialog(student),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  initial,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(student.name),
                              subtitle: Text(
                                'Reg: ${student.registrationNumber} | Course: ${student.course} | Year ${student.year}',
                              ),
                              trailing: _isDeleting && _deletingId == student.id
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmDelete(student),
                                    ),
                            ),
                          );
                        },
                      ),
          ),
          if (_isDeleting)
            const Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Deleting...', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
          );
          await _loadStudents();
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Student', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}