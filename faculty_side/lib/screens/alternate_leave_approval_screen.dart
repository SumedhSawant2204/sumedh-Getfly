import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';

class AlternateApprovalScreen extends StatelessWidget {
  const AlternateApprovalScreen({super.key});

  final List<Map<String, String>> facultyLeaves = const [
    {
      'name': 'Dr. GAYATRI DASHRATH BACHHAV',
      'days': '0.50',
      'type': 'Outdoor Duty',
      'reason': 'Education Summit',
      'from': '05/12/2024',
      'to': '05/12/2024',
      'applied': '01/01/1970',
    },
    {
      'name': 'Mr. ATUL HINDURAO SHINTRE',
      'days': '0.50',
      'type': 'Compensation Leave',
      'reason': 'Relative expired',
      'from': '06/01/2025',
      'to': '06/01/2025',
      'applied': '01/01/1970',
    },
    {
      'name': 'Dr. MAHAVIR ARJUN DEVMANE',
      'days': '1.00',
      'type': 'Compensation Leave',
      'reason': 'My son is ill...require medical treatment',
      'from': '10/01/2025',
      'to': '10/01/2025',
      'applied': '01/01/1970',
    },
    {
      'name': 'MRS. MANJIRI CHAITANYA KARANDIKAR',
      'days': '0.50',
      'type': 'Compensation Leave',
      'reason': 'Personal reason',
      'from': '09/01/2025',
      'to': '09/01/2025',
      'applied': '01/01/1970',
    },
  ];

  void _showDetailsPopup(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.info, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('Leave Details', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _detailRow('Faculty Name:', data['name']!),
            _detailRow('Number of Days:', data['days']!),
            _detailRow('Leave Type:', data['type']!),
            _detailRow('Reason:', data['reason']!),
            _detailRow('From:', data['from']!),
            _detailRow('To:', data['to']!),
            _detailRow('Applied On:', data['applied']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: Colors.red.shade50),
            child: const Text('Deny', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: Colors.green.shade50),
            child: const Text('Approve', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  static Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          children: [
            TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const SideDrawer(),
      appBar: AppHeader(scaffoldKey: scaffoldKey),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alternate Approval',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("View Approved Leaves tapped")),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('View Approved Leaves'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: facultyLeaves.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final faculty = facultyLeaves[index];
                  return Card(
                    elevation: 4,
                    shadowColor: Colors.deepPurple.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        faculty['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showDetailsPopup(context, faculty),
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
