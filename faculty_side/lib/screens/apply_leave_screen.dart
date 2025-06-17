// apply_leave_screen.dart
import 'package:flutter/material.dart';
import '../models/faculty.dart' hide LeaveType;
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';
import '../services/api_services.dart';
import '../models/faculty.dart' hide LeaveType;
import 'package:intl/intl.dart';
import '../models/leave_type.dart';
import '../models/alternate_models.dart' hide AlternatePerson; // Make sure this file exports AlternatePerson

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final String apiToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjMyMDMsInVzZXJfdHlwZSI6MiwicHJpdmlsZWdlIjpudWxsLCJpYXQiOjE3NDk2MzA3MzcsImV4cCI6MTc4MTE2NjczN30.V4okpSzbqNTeFklZljZEiHDZMa2fTH_YKvQJ7uve3NM';
  final String userId = '3203'; // Replace with actual user id if available

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  List<LeaveType> leaveTypes = [];
  bool isLoadingLeaveTypes = true;
  String? selectedLeaveType;
  String? selectedAlternate;
  DateTime? fromDate;
  DateTime? toDate;
  String? fileName;
  bool isSubmitting = false;

  List<AlternatePerson> alternates = [];
  bool isLoadingAlternates = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes();
    _fetchAlternates();
  }

  Future<void> _fetchLeaveTypes() async {
    setState(() {
      isLoadingLeaveTypes = true;
    });
    try {
      List<LeaveType> fetchedLeaveTypes = await ApiServices.getLeaveTypes(
        token: apiToken,
      );
      setState(() {
        leaveTypes = fetchedLeaveTypes;
        isLoadingLeaveTypes = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLeaveTypes = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load leave types: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchAlternates() async {
    setState(() {
      isLoadingAlternates = true;
    });
    try {
      List<AlternatePerson> fetchedAlternates = await ApiServices.getAlternates(token: apiToken);
      setState(() {
        alternates = fetchedAlternates;
        isLoadingAlternates = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAlternates = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load alternates: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? fromDate ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF2A1070),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isFrom) {
          fromDate = pickedDate;
          // Clear toDate if it's before the new fromDate
          if (toDate != null && toDate!.isBefore(pickedDate)) {
            toDate = null;
          }
        } else {
          toDate = pickedDate;
        }
      });
    }
  }

  void _pickFile() {
    // Simulate file picking - in real app, use file_picker package
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select File'),
        content: const Text(
          'File picker would open here. For demo, we\'ll simulate a selected file.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                fileName = 'sample_document.pdf';
              });
              Navigator.pop(context);
            },
            child: const Text('Select Sample File'),
          ),
        ],
      ),
    );
  }

  int _calculateLeaveDays() {
    if (fromDate != null && toDate != null) {
      return toDate!.difference(fromDate!).inDays + 1;
    }
    return 0;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    IconData? icon,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1070).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: const Color(0xFF2A1070), size: 20),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A1070),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveTypeDropdown() {
    if (isLoadingLeaveTypes) {
      return const Center(child: CircularProgressIndicator());
    }
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Select Leave Type',
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: leaveTypes.map((type) {
        return DropdownMenuItem<int>(
          value: type.leaveId,
          child: Text(type.lname),
        );
      }).toList(),
      value: selectedLeaveType == null
          ? null
          : int.tryParse(selectedLeaveType!),
      onChanged: (val) => setState(() => selectedLeaveType = val?.toString()),
      validator: (val) => val == null ? 'Please select a leave type' : null,
    );
  }

  Widget _buildAlternateDropdown() {
    if (isLoadingAlternates) {
      return const Center(child: CircularProgressIndicator());
    }
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Select Alternate Faculty',
        prefixIcon: Icon(Icons.person_outline),
      ),
      items: alternates.map((alt) {
        return DropdownMenuItem<int>(
          value: alt.facultyId,
          child: Text(alt.name),
        );
      }).toList(),
      value: selectedAlternate == null ? null : int.tryParse(selectedAlternate!),
      onChanged: (val) => setState(() => selectedAlternate = val?.toString()),
      validator: (val) => val == null ? 'Please select an alternate faculty' : null,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit_calendar),
          onPressed: onTap,
        ),
      ),
      controller: TextEditingController(text: _formatDate(date)),
      onTap: onTap,
      validator: validator,
    );
  }

  Widget _buildLeaveSummary() {
    if (fromDate != null && toDate != null) {
      final days = _calculateLeaveDays();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1070).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A1070).withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Leave Days:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1070),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                days.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer(),
      appBar: AppHeader(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A1070), Color(0xFF5A4FCF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.event_note,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Leave Application',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: Colors.white, fontSize: 28),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fill out the details below to submit your leave request',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Leave Type Section
                  _buildSectionCard(
                    title: 'Leave Information',
                    icon: Icons.info_outline,
                    child: _buildLeaveTypeDropdown(),
                  ),

                  // Date Selection Section
                  _buildSectionCard(
                    title: 'Duration',
                    icon: Icons.date_range,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                label: 'From Date',
                                date: fromDate,
                                onTap: () => _pickDate(isFrom: true),
                                validator: (_) => fromDate == null
                                    ? 'Select from date'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDateField(
                                label: 'To Date',
                                date: toDate,
                                onTap: () => _pickDate(isFrom: false),
                                validator: (_) {
                                  if (toDate == null) return 'Select to date';
                                  if (fromDate != null &&
                                      toDate!.isBefore(fromDate!)) {
                                    return 'To date must be after from date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildLeaveSummary(),
                      ],
                    ),
                  ),

                  // Alternate Section
                  _buildSectionCard(
                    title: 'Alternate Arrangement',
                    icon: Icons.swap_horiz,
                    child: _buildAlternateDropdown(),
                  ),

                  // Reason Section
                  _buildSectionCard(
                    title: 'Reason for Leave',
                    icon: Icons.description_outlined,
                    child: TextFormField(
                      controller: _reasonController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Please provide reason for your leave',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Icon(Icons.edit_outlined),
                        ),
                        alignLabelWithHint: true,
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Please provide a reason for leave'
                          : null,
                    ),
                  ),

                  // Attachment Section
                  _buildSectionCard(
                    title: 'Supporting Documents',
                    icon: Icons.attach_file,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attach supporting documents (Optional)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _pickFile,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: fileName != null
                                    ? const Color(0xFF10B981)
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: fileName != null
                                  ? const Color(0xFF10B981).withOpacity(0.05)
                                  : Colors.grey.shade50,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  fileName != null
                                      ? Icons.check_circle_outline
                                      : Icons.cloud_upload_outlined,
                                  color: fileName != null
                                      ? const Color(0xFF10B981)
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    fileName ?? 'Tap to select file',
                                    style: TextStyle(
                                      color: fileName != null
                                          ? const Color(0xFF10B981)
                                          : Colors.grey.shade600,
                                      fontWeight: fileName != null
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (fileName != null)
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () =>
                                        setState(() => fileName = null),
                                    color: Colors.grey.shade600,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Submit Button
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A1070),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isSubmitting = true);

                                try {
                                  // Use the provided token and userId directly
                                  String token = apiToken;
                                  String uid = userId;

                                  final now = DateTime.now();
                                  final appliedDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(now);
                                  final fromDateStr = fromDate != null
                                      ? DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(fromDate!)
                                      : '';
                                  final toDateStr = toDate != null
                                      ? DateFormat('yyyy-MM-dd').format(toDate!)
                                      : '';

                                  final request = ApplyLeaveRequest(
                                    leaveId: selectedLeaveType ?? '',
                                    fromDate: fromDateStr,
                                    toDate: toDateStr,
                                    appliedDate: appliedDate,
                                    reason: _reasonController.text.trim(),
                                    noOfDate: toDate != null && fromDate != null
                                        ? toDate!.difference(fromDate!).inDays +
                                              1
                                        : 0,
                                    alternate: selectedAlternate ?? '',
                                    uid: uid,
                                    doc: fileName ?? '',
                                    halfFullDay: '', // Adjust if needed
                                  );

                                  final response = await ApiServices.applyLeave(
                                    request: request,
                                    token: token,
                                  );

                                  // ...handle response...
                                } catch (e) {
                                  // ...handle error...
                                } finally {
                                  setState(() => isSubmitting = false);
                                }
                              }
                            },
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit Leave Request',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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

/* AlternatePerson class removed; now imported from ../models/alternate_models.dart */
