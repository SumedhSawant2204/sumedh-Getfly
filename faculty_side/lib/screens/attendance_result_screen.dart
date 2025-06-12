import 'package:flutter/material.dart';

class Student {
  String name;
  int rollNo;
  bool isPresent;

  Student({required this.name, required this.rollNo, this.isPresent = true});
}

class AttendanceResultScreen extends StatefulWidget {
  final DateTime date;

  const AttendanceResultScreen({super.key, required this.date});

  @override
  _AttendanceResultScreenState createState() => _AttendanceResultScreenState();
}

class _AttendanceResultScreenState extends State<AttendanceResultScreen> {
  List<Student> students = [
    Student(name: "Aarya Desai", rollNo: 1),
    Student(name: "Bhavesh Patel", rollNo: 2),
    Student(name: "Chinmay Joshi", rollNo: 3),
    Student(name: "Divya Shah", rollNo: 4),
    Student(name: "Eshan Mehta", rollNo: 5),
  ];

  int get presentCount => students.where((s) => s.isPresent).length;
  int get absentCount => students.where((s) => !s.isPresent).length;

  void toggleAttendance(int index) {
    setState(() {
      students[index].isPresent = !students[index].isPresent;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = widget.date.toLocal().toString().split(' ')[0];
    return Scaffold(
      appBar: AppBar(title: Text("Attendance on $formattedDate")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AttendanceCounter(label: 'Present', count: presentCount, color: Colors.green),
                AttendanceCounter(label: 'Absent', count: absentCount, color: Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (_, index) {
                  var student = students[index];
                  return Card(
                    child: ListTile(
                      title: Text('${student.rollNo}. ${student.name}'),
                      trailing: Switch(
                        value: student.isPresent,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        onChanged: (_) => toggleAttendance(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceCounter extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const AttendanceCounter({super.key, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 8),
          Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
