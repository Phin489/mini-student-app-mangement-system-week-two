# Student Management System

A Flutter mobile application for managing student records using SQLite for local data storage. The app supports student registration, login authentication, and CRUD operations on student data.

## Features

### User Authentication
- **Login Screen**: Authenticate students using registration number and password
- **Registration Screen**: Create new student accounts with validated form inputs
- **Splash Screen**: Auto-navigates to login screen on app launch

### Student Management
- **Dashboard**: View total student count and recent students (up to 5 most recent)
- **All Students**: View, edit, and delete all registered students
- **Registration**: Add new students with course selection and year of study

### Data Validation
- Required field validation on all inputs
- Phone number must be exactly 10 digits
- Password minimum length of 4 characters
- Password confirmation match validation
- Unique registration number enforcement

### UI Features
- Material 3 design with responsive layout
- Pull-to-refresh on list screens
- Confirmation dialogs for delete and logout actions
- Loading indicators and SnackBar feedback
- CircleAvatar student initials and year badges

## Screens

| Screen | Route | Description |
|--------|-------|-------------|
| Splash Screen | `/splash` | Entry point, auto-navigates to login after 2 seconds |
| Login Screen | `/login` | Student authentication with registration number and password |
| Registration Screen | `/register` | New student signup with full form validation |
| Dashboard Screen | `/dashboard` | Main authenticated view with student stats and recent list |
| All Students Screen | `/all_students` | View, edit, and delete all student records |

## Screenshots

### Splash Screen
- Blue background with school icon and app title
- Auto-transitions to login after 2 seconds

### Login Screen
- Registration Number and Password fields with icons
- Create Account button navigates to registration
- Login button validates credentials against database

### Registration Screen
- Full Name, Registration Number, Course dropdown, Year dropdown
- Phone Number (10 digits), Password (min 4 characters), Confirm Password
- Validates unique registration number against database

### Dashboard Screen
- Total student count display
- Recent students list (up to 5 most recent)
- Welcome chip with logged-in student name
- Navigation drawer: All Students, Add New Student, Logout

### All Students Screen
- Complete list of all registered students
- Pull-to-refresh capability
- Edit dialog for updating student details (name, course, year, phone)
- Delete with confirmation dialog
- FAB to add new student

## Data Model

### Student
| Field | Type | Description |
|-------|------|-------------|
| id | int? | Primary key, auto-generated |
| name | String | Full name |
| registrationNumber | String | Unique registration identifier |
| course | String | Selected course (Computer Science, IT, Business, Engineering) |
| year | int | Year of study (1-4) |
| phoneNumber | String | 10-digit phone number |
| password | String | Authentication password |

## Database

### SQLite Database
- **File**: `student_management.db`
- **Table**: `students`
- **Columns**: id, name, registrationNumber, course, year, phoneNumber, password

### Database Operations
| Operation | Method | Description |
|-----------|--------|-------------|
| Create | `insertStudent(Student)` | Insert new student record |
| Read | `getStudentByRegNumber(String)` | Query student by registration number |
| Read | `getAllStudents()` | Retrieve all students |
| Read | `getStudentCount()` | Get total student count |
| Update | `updateStudent(Student)` | Update existing student by ID |
| Delete | `deleteStudent(int id)` | Delete student by ID |

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **Database**: SQLite via sqflite
- **Desktop Support**: sqflite_common_ffi
- **Path Handling**: path, path_provider
- **Design**: Material 3

## Project Structure

```
lib/
├── main.dart                    # App entry point and routing
├── models/
│   └── student_model.dart       # Student data model
├── database/
│   └── database_helper.dart     # SQLite database operations
├── screens/
│   ├── splash_screen.dart       # Launch screen
│   ├── login_screen.dart        # Student login
│   ├── registration_screen.dart # New student signup
│   ├── dashboard_screen.dart    # Main authenticated view
│   └── all_students_screen.dart # Student list with CRUD
└── widgets/
    ├── custom_textfield.dart    # Reusable text input
    └── custom_button.dart       # Reusable button
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.12.0)
- Dart SDK (^3.12.0)

### Installation

1. Clone or download the project
2. Navigate to the project directory:
   ```bash
   cd mini_sudent_management_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

```bash
# Run on Windows desktop
flutter run -d windows

# Run on Chrome (web)
flutter run -d chrome

# Run on connected Android device
flutter run -d <device-id>

# Run on connected iOS device
flutter run -d <device-id>
```

### Building for Release

```bash
# Build Windows desktop executable
flutter build windows

# Build Android APK
flutter build apk

# Build iOS app (macOS only)
flutter build ios
```

## Available Devices

The app supports:
- Android (via sqflite)
- iOS (via sqflite)
- Windows desktop (via sqflite_common_ffi)
- macOS desktop (via sqflite_common_ffi)
- Web/Chrome (via sqflite_common_ffi)

## Default Credentials

There are no default credentials. Users must register first through the Registration Screen, then log in with their registration number and password.

## Notes

- Student registration numbers must be unique
- Phone numbers must be exactly 10 digits
- Passwords must be at least 4 characters
- Database is stored locally on the device
- No backend/server required - fully offline functionality
