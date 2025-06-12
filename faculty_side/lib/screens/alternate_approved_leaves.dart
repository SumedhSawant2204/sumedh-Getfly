import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';

class FacultyLeave {
  final String name;
  final double days;
  final String type;
  final String reason;
  final String from;
  final String to;
  final String applied;

  FacultyLeave({
    required this.name,
    required this.days,
    required this.type,
    required this.reason,
    required this.from,
    required this.to,
    required this.applied,
  });
}

class AlternateApprovedLeaves extends StatefulWidget {
  const AlternateApprovedLeaves({super.key});

  @override
  State<AlternateApprovedLeaves> createState() => _AlternateApprovedLeavesState();
}

class _AlternateApprovedLeavesState extends State<AlternateApprovedLeaves> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<FacultyLeave> approvedLeaves = [
    FacultyLeave(
      name: 'Dr. MAHENDRA EKNATH PAWAR',
      days: 1.00,
      type: 'Outdoor Duty',
      reason: 'Bootcamp Ideation 2.0, Maharashtra state skill university',
      from: '17/01/2025',
      to: '17/01/2025',
      applied: '01/01/1970',
    ),
    FacultyLeave(
      name: 'MRS. MANJIRI CHAITANYA KARANDIKAR',
      days: 0.50,
      type: 'Compensation Leave',
      reason: 'Personal reason',
      from: '09/01/2025',
      to: '09/01/2025',
      applied: '01/01/1970',
    ),
    FacultyLeave(
      name: 'Dr. MAHAVIR ARJUN DEVMANE',
      days: 1.00,
      type: 'Compensation Leave',
      reason: 'My son is ill...require medical treatment',
      from: '10/01/2025',
      to: '10/01/2025',
      applied: '01/01/1970',
    ),
    FacultyLeave(
      name: 'Mr. ATUL HINDURAO SHINTRE',
      days: 0.50,
      type: 'Compensation Leave',
      reason: 'Relative expired',
      from: '06/01/2025',
      to: '06/01/2025',
      applied: '01/01/1970',
    ),
    FacultyLeave(
      name: 'Dr. GAYATRI DASHRATH BACHHAV',
      days: 0.50,
      type: 'Outdoor Duty',
      reason: 'Education Summit',
      from: '05/12/2024',
      to: '05/12/2024',
      applied: '01/01/1970',
    ),
    FacultyLeave(
      name: 'Dr. MAHENDRA EKNATH PAWAR',
      days: 18.00,
      type: 'Winter Vacation',
      reason: 'Winter Vacation',
      from: '16/12/2024',
      to: '02/01/2025',
      applied: '01/01/1970',
    ),
  ];

  void _showLeaveDetails(BuildContext context, FacultyLeave leave) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(
                leave.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              detailRow('Number of Days:', leave.days.toString()),
              detailRow('Leave Type:', leave.type),
              detailRow('Leave Reason:', leave.reason),
              detailRow('From:', leave.from),
              detailRow('To:', leave.to),
              detailRow('Applied Date:', leave.applied),
              detailRow('Status:', 'Approved'),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  // <-- assign scaffold key here
      drawer: const SideDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppHeader(scaffoldKey: _scaffoldKey), // <-- pass scaffold key here
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back To Approval"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade200,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: approvedLeaves.length,
                itemBuilder: (context, index) {
                  final leave = approvedLeaves[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(
                        leave.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Approved", style: TextStyle(color: Colors.green)),
                      ),
                      onTap: () => _showLeaveDetails(context, leave),
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
