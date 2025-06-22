import 'package:faculty_side/models/FacultyDashboardResponse.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';
import '../services/api_services.dart';
import '../models/FacultyDashboardResponse.dart';
import '../themes/theme.dart'; // Make sure you have your AppColors

class AlternateApprovalScreen extends StatefulWidget {
  final String uid;
  final String token;

  const AlternateApprovalScreen({Key? key, required this.uid, required this.token}) : super(key: key);

  @override
  State<AlternateApprovalScreen> createState() => _AlternateApprovalScreenState();
}

class _AlternateApprovalScreenState extends State<AlternateApprovalScreen> {
  late Future<List<FacultyDashboardResponse>> _facultyLeavesFuture;

  @override
  void initState() {
    super.initState();
    _facultyLeavesFuture = ApiServices.getFacultyDashboard(
      uid: widget.uid,
      token: widget.token,
    );
  }

  void _showDetailsPopup(BuildContext context, FacultyDashboardResponse record) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildPopupCard(record),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupCard(FacultyDashboardResponse record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: IDs and Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _idChip('ID: ${record.leaveAppId}'),
            _idChip('Faculty ID: ${record.facultyId}'),
            _statusChip(record.status),
          ],
        ),
        const SizedBox(height: 16),
        // Leave Type and Days
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getLeaveTypeColor(record.lname).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getLeaveIcon(record.lname),
                size: 18,
                color: _getLeaveTypeColor(record.lname),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.lname ?? 'Leave',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${record.noOfDays ?? '-'} ${record.noOfDays == "1" ? 'day' : 'days'}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // From/To Dates
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'From',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.fromDate?.split("T").first ?? '-',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.secondary.withOpacity(0.3),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'To',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.toDate?.split("T").first ?? '-',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Reason
        _infoBlock('REASON', record.reason ?? '-'),
        // Alternate
        _infoBlock('ALTERNATE', record.name ?? '-'),
        const SizedBox(height: 16),
        // Document and HOD Approval
        Row(
          children: [
            Expanded(
              child: _docChip(record.docLink),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _hodChip(record.hodApprovalDate),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Approve/Deny Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Deny'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Approve'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _idChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _statusChip(int? status) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getStatusColor(status).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _statusText(status).toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _getStatusColor(status),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );

  Widget _infoBlock(String label, String value) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notes_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ],
        ),
      );

  Widget _docChip(String? docLink) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (docLink != null ? AppColors.success : AppColors.secondary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (docLink != null ? AppColors.success : AppColors.secondary).withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.attach_file_rounded,
              size: 14,
              color: docLink != null ? AppColors.success : AppColors.secondary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                docLink != null ? 'Document' : 'No Document',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: docLink != null ? AppColors.success : AppColors.secondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Widget _hodChip(String? hodApprovalDate) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ((hodApprovalDate?.isEmpty ?? true) ? AppColors.warning : AppColors.success).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ((hodApprovalDate?.isEmpty ?? true) ? AppColors.warning : AppColors.success).withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 14,
              color: (hodApprovalDate?.isEmpty ?? true) ? AppColors.warning : AppColors.success,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                (hodApprovalDate?.isEmpty ?? true) ? 'Pending HOD' : 'HOD Approved',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: (hodApprovalDate?.isEmpty ?? true) ? AppColors.warning : AppColors.success,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  // Dummy helpers for status, leave type color, and icon
  Color _getStatusColor(int? status) {
    switch (status) {
      case 1:
        return AppColors.success;
      case 0:
        return AppColors.warning;
      case -1:
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  String _statusText(int? status) {
    switch (status) {
      case 1:
        return "Approved";
      case 0:
        return "Pending";
      case -1:
        return "Denied";
      default:
        return "Unknown";
    }
  }

  Color _getLeaveTypeColor(String? lname) {
    if (lname == null) return AppColors.secondary;
    switch (lname.toLowerCase()) {
      case "compensation leave":
        return AppColors.accent;
      case "medical leave":
        return AppColors.error;
      case "casual leave":
        return AppColors.info;
      default:
        return AppColors.secondary;
    }
  }

  IconData _getLeaveIcon(String? lname) {
    if (lname == null) return Icons.beach_access;
    switch (lname.toLowerCase()) {
      case "compensation leave":
        return Icons.balance_outlined;
      case "medical leave":
        return Icons.medical_services_outlined;
      case "casual leave":
        return Icons.person_outline;
      default:
        return Icons.beach_access;
    }
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
              child: FutureBuilder<List<FacultyDashboardResponse>>(
                future: _facultyLeavesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No alternate leaves found.'));
                  }
                  final facultyLeaves = snapshot.data!;
                  return ListView.separated(
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
                            faculty.name ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _showDetailsPopup(context, faculty),
                        ),
                      );
                    },
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
