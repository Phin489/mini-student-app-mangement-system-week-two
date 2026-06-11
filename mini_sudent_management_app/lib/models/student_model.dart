class Student {
  final int? id;
  final String name;
  final String registrationNumber;
  final String course;
  final int year;
  final String phoneNumber;
  final String password;

  Student({
    this.id,
    required this.name,
    required this.registrationNumber,
    required this.course,
    required this.year,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'registrationNumber': registrationNumber,
      'course': course,
      'year': year,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      registrationNumber: map['registrationNumber'],
      course: map['course'],
      year: map['year'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
    );
  }
}