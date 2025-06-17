import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/punch_record_list.dart';
import '../themes/theme.dart';
import '../services/punchRecord.dart';

class PunchRecordScreen extends StatefulWidget {
  @override
  _PunchRecordScreenState createState() => _PunchRecordScreenState();
}

class _PunchRecordScreenState extends State<PunchRecordScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  List<Map<String, dynamic>> _punchRecords = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Set default date range (current month)
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1);
    _toDate = now;
    _fetchPunchRecords();
  }

  Future<void> _fetchPunchRecords() async {
    if (_fromDate == null || _toDate == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final startDate = DateFormat('yyyy-MM-dd').format(_fromDate!);
      final endDate = DateFormat('yyyy-MM-dd').format(_toDate!);

      print("Fetching records from $startDate to $endDate");

      // You may need to get the actual faculty college ID from user session/preferences
      final response = await getMyPunchReport(
        startDate: startDate,
        endDate: endDate,
        facultyClgId: "195", // Replace with actual faculty ID
      );

      setState(() {
        _isLoading = false;
        if (response != null && response['attendanceList'] != null) {
          _punchRecords =
              List<Map<String, dynamic>>.from(response['attendanceList']);
        } else if (response != null) {
          // Handle case where data might be directly in response or in different structure
          _punchRecords = [response];
        } else {
          _punchRecords = [];
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (e.toString().contains('Authentication failed')) {
          _errorMessage = 'Authentication failed. Please login again.';
        } else if (e.toString().contains('Bad request')) {
          _errorMessage = 'Invalid request. Please check your input.';
        } else {
          _errorMessage =
              'Failed to fetch records: ${e.toString().replaceAll('Exception: ', '')}';
        }
        _punchRecords = [];
      });
      print("Error in _fetchPunchRecords: $e");
    }
  }

  void _onFromDateChanged(DateTime date) {
    setState(() {
      _fromDate = date;
    });
    _fetchPunchRecords();
  }

  void _onToDateChanged(DateTime date) {
    setState(() {
      _toDate = date;
    });
    _fetchPunchRecords();
  }

  void _clearFilters() {
    final now = DateTime.now();
    setState(() {
      _fromDate = DateTime(now.year, now.month, 1);
      _toDate = now;
    });
    _fetchPunchRecords();
  }

  void _refreshData() {
    _fetchPunchRecords();
  }

  // Convert API data to the format expected by PunchRecordList
  List<Map<String, String>> get _formattedPunchRecords {
    return _punchRecords.map((record) {
      // Parse the API response based on the actual structure
      final name = record['Name']?.toString() ?? 'N/A';
      final date = record['Date']?.toString() ?? '';
      final punchInTime = record['Punch In Time']?.toString() ?? 'N/A';
      final punchOutTime = record['Punch Out Time']?.toString() ?? 'N/A';

      // Format the date for better display
      String formattedDate = 'N/A';
      if (date.isNotEmpty && date != 'N/A') {
        try {
          // Assuming the date is in format "01-06-2024" (DD-MM-YYYY)
          final parts = date.split('-');
          if (parts.length == 3) {
            final day = parts[0];
            final month = parts[1];
            final year = parts[2];
            final dateTime =
                DateTime(int.parse(year), int.parse(month), int.parse(day));
            formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
          } else {
            formattedDate = date;
          }
        } catch (e) {
          formattedDate = date;
        }
      }

      // Determine attendance type based on punch times
      String attendanceType = 'N/A';
      if (punchInTime != 'N/A' &&
          punchInTime != 'null' &&
          punchInTime.isNotEmpty &&
          punchOutTime != 'N/A' &&
          punchOutTime != 'null' &&
          punchOutTime.isNotEmpty) {
        attendanceType = 'Full Day';
      } else if (punchInTime != 'N/A' &&
          punchInTime != 'null' &&
          punchInTime.isNotEmpty) {
        attendanceType = 'Punch In Only';
      } else if (punchOutTime != 'N/A' &&
          punchOutTime != 'null' &&
          punchOutTime.isNotEmpty) {
        attendanceType = 'Punch Out Only';
      } else {
        attendanceType = 'No Punch';
      }

      return {
        'name': name,
        'punchIn': punchInTime == 'null' ? 'N/A' : punchInTime,
        'punchOut': punchOutTime == 'null' ? 'N/A' : punchOutTime,
        'date': formattedDate,
        'type': attendanceType,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 5.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1070),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Punch Records',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'View and filter your attendance records',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Right icon buttons
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white, size: 30),
                      onPressed: _refreshData,
                      tooltip: 'Refresh Data',
                      constraints: BoxConstraints(minWidth: 5, minHeight: 5),
                    ),
                    if (_fromDate != null || _toDate != null) ...[
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.clear_all,
                            color: Colors.white, size: 30),
                        onPressed: _clearFilters,
                        tooltip: 'Clear Filters',
                        constraints:
                            BoxConstraints(minWidth: 5, minHeight: 5),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Date filter section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Records',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomDatePicker(
                        initialDate: _fromDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        onDateChanged: _onFromDateChanged,
                        labelText: 'From Date',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomDatePicker(
                        initialDate: _toDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        onDateChanged: _onToDateChanged,
                        labelText: 'To Date',
                      ),
                    ),
                  ],
                ),
                if (_fromDate != null || _toDate != null) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1070).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: const Color(0xFF2A1070),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isLoading
                                ? 'Loading records...'
                                : 'Showing ${_punchRecords.length} records',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF2A1070),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Error message display
                if (_errorMessage != null) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.inter(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Records list
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: const Color(0xFF2A1070),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading punch records...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                      ],
                    ),
                  )
                : _punchRecords.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 64,
                                color: const Color(0xFF5F6A7D),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No punch records found',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5F6A7D),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _errorMessage == null
                                    ? 'Try adjusting your date filters'
                                    : 'Please check your connection and try again',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF5C5C5C),
                                ),
                              ),
                              if (_errorMessage != null) ...[
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _refreshData,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2A1070),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Retry'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            PunchRecordList(
                              punchRecords: _formattedPunchRecords,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}