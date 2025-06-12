// apply_leave_screen.dart
import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String? selectedLeaveType;
  String? selectedAlternate;
  DateTime? fromDate;
  DateTime? toDate;
  String? fileName;
  bool isSubmitting = false;

  final List<Map<String, dynamic>> leaveTypes = [
    {'value': 'Casual Leave', 'icon': Icons.beach_access, 'color': Colors.blue},
    {'value': 'Sick Leave', 'icon': Icons.local_hospital, 'color': Colors.red},
    {'value': 'Compensation Leave', 'icon': Icons.access_time, 'color': Colors.orange},
    {'value': 'Outdoor Duty', 'icon': Icons.work_outline, 'color': Colors.green},
  ];

  final List<Map<String, dynamic>> alternates = [
    {'value': 'Dr. Smith', 'department': 'Cardiology'},
    {'value': 'Ms. Patel', 'department': 'Neurology'},
    {'value': 'Mr. John', 'department': 'Emergency'},
  ];

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
        content: const Text('File picker would open here. For demo, we\'ll simulate a selected file.'),
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
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select Leave Type',
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: leaveTypes.map((type) {
        return DropdownMenuItem(
          value: type['value'] as String,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (type['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  type['icon'] as IconData,
                  color: type['color'] as Color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(type['value'] as String),
            ],
          ),
        );
      }).toList(),
      value: selectedLeaveType,
      onChanged: (val) => setState(() => selectedLeaveType = val),
      validator: (val) => val == null ? 'Please select a leave type' : null,
    );
  }

  Widget _buildAlternateDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select Alternate Person',
        prefixIcon: Icon(Icons.person_outline),
      ),
      items: alternates.map((alt) {
        return DropdownMenuItem(
          value: alt['value'] as String,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                alt['value'] as String,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                alt['department'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      value: selectedAlternate,
      onChanged: (val) => setState(() => selectedAlternate = val),
      validator: (val) => val == null ? 'Please select an alternate person' : null,
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
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                          ),
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
                                validator: (_) => fromDate == null ? 'Select from date' : null,
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
                                  if (fromDate != null && toDate!.isBefore(fromDate!)) {
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
                          ? 'Please provide a reason for leave' : null,
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
                                    onPressed: () => setState(() => fileName = null),
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
                      onPressed: isSubmitting ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isSubmitting = true);
                          
                          // Simulate API call
                          await Future.delayed(const Duration(seconds: 2));
                          
                          setState(() => isSubmitting = false);
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text("Leave application submitted successfully!"),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                          
                          // Reset form
                          _formKey.currentState!.reset();
                          setState(() {
                            selectedLeaveType = null;
                            selectedAlternate = null;
                            fromDate = null;
                            toDate = null;
                            fileName = null;
                          });
                          _reasonController.clear();
                        }
                      },
                      child: isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Submitting...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Submit Leave Application',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}