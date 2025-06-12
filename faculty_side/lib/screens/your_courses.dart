import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/course_card.dart';

class YourCourses extends StatefulWidget {
  const YourCourses({super.key});

  @override
  State<YourCourses> createState() => _YourCoursesState();
}

class _YourCoursesState extends State<YourCourses> {
  final List<Map<String, dynamic>> _courses = [
    {
      'name': 'Machine Learning',
      'semester': '5',
      'year': '2024–25',
      'branch': 'CSE',
      'coCount': 6
    },
    {
      'name': 'Data Structures and Algorithms',
      'semester': '3',
      'year': '2023–24',
      'branch': 'CSE',
      'coCount': 5
    },
    {
      'name': 'Mathematics',
      'semester': '1',
      'year': '2023–24',
      'branch': 'IT',
      'coCount': 4
    },
    {
      'name': 'Statistics',
      'semester': '2',
      'year': '2022–23',
      'branch': 'CS',
      'coCount': 4
    },
    {
      'name': 'Web Development',
      'semester': '6',
      'year': '2024–25',
      'branch': 'CSE',
      'coCount': 7
    },
  ];

  void _addCourseDialog() {
    final nameController = TextEditingController();
    final semesterController = TextEditingController();
    final yearController = TextEditingController();
    final branchController = TextEditingController();
    final coCountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Course", style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: semesterController,
                decoration: InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              TextField(
                controller: yearController,
                decoration: InputDecoration(labelText: 'Academic Year'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: branchController,
                decoration: InputDecoration(labelText: 'Branch'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: coCountController,
                decoration: InputDecoration(labelText: 'CO Count'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Add"),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  semesterController.text.isNotEmpty &&
                  yearController.text.isNotEmpty &&
                  branchController.text.isNotEmpty &&
                  coCountController.text.isNotEmpty) {
                setState(() {
                  _courses.add({
                    'name': nameController.text,
                    'semester': semesterController.text,
                    'year': yearController.text,
                    'branch': branchController.text,
                    'coCount': int.tryParse(coCountController.text) ?? 0,
                  });
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 5.0),
          decoration: const BoxDecoration(
            color: Color(0xFF2A1070),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Courses',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage and view your course details',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
        child: ListView.builder(
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return CourseCard(
              courseName: course['name'],
              semester: course['semester'],
              academicYear: course['year'],
              branch: course['branch'],
              coCount: course['coCount'],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCourseDialog,
        label: Text('Add Course'),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFF2A1070),
      ),
    );
  }
}