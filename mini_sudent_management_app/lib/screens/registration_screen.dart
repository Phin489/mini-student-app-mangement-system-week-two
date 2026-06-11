import 'package:flutter/material.dart';
import 'package:mini_sudent_management_app/database/database_helper.dart';
import 'package:mini_sudent_management_app/models/student_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCourse;
  int? _selectedYear;
  bool _isLoading = false;

  final List<String> _courses = [
    'Computer Science',
    'Information Technology',
    'Business',
    'Engineering',
  ];

  final List<int> _years = [1, 2, 3, 4];

  @override
  void dispose() {
    _nameController.dispose();
    _regNumberController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourse == null) {
      _showErrorSnackBar('Please select a course');
      return;
    }
    if (_selectedYear == null) {
      _showErrorSnackBar('Please select a year');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existingStudent =
          await DatabaseHelper.instance.getStudentByRegNumber(
        _regNumberController.text.trim(),
      );

      if (existingStudent != null) {
        _showErrorSnackBar('Registration number already exists');
        return;
      }

      final student = Student(
        name: _nameController.text.trim(),
        registrationNumber: _regNumberController.text.trim(),
        course: _selectedCourse!,
        year: _selectedYear!,
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await DatabaseHelper.instance.insertStudent(student);

      if (mounted) {
        _showSuccessSnackBar('Registration successful!');
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showErrorSnackBar('Registration failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _regNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter registration number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCourse,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      prefixIcon: Icon(Icons.book),
                    ),
                    items: _courses
                        .map((course) => DropdownMenuItem(
                              value: course,
                              child: Text(course),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedCourse = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a course';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Year of Study',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    items: _years
                        .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text('Year $year'),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedYear = value),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.trim().length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.trim().length < 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value.trim() != _passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Register Student', style: TextStyle(fontSize: 16)),
                        ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}