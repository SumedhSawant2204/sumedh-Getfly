import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/punch_record_list.dart';

class PunchRecordScreen extends StatefulWidget {
  const PunchRecordScreen({super.key});

  @override
  _PunchRecordScreenState createState() => _PunchRecordScreenState();
}

class _PunchRecordScreenState extends State<PunchRecordScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<Map<String, dynamic>> _allPunchCards = [
    {
      'date': '2024-06-01',
      'name': 'John Doe',
      'punchIn': '09:00',
      'punchOut': '17:00',
      'type': 'Full Day'
    },
    {
      'date': '2024-06-02',
      'name': 'John Doe',
      'punchIn': '09:10',
      'punchOut': '17:05',
      'type': 'Full Day'
    },
    {
      'date': '2024-06-03',
      'name': 'John Doe',
      'punchIn': '09:05',
      'punchOut': '17:10',
      'type': 'Full Day'
    },
    {
      'date': '2024-06-04',
      'name': 'John Doe',
      'punchIn': '09:02',
      'punchOut': '17:08',
      'type': 'Full Day'
    },
    {
      'date': '2024-06-05',
      'name': 'John Doe',
      'punchIn': '08:58',
      'punchOut': '17:15',
      'type': 'Full Day'
    },
    {
      'date': '2024-06-06',
      'name': 'John Doe',
      'punchIn': '09:15',
      'punchOut': '13:00',
      'type': 'Half Day'
    },
    {
      'date': '2024-06-07',
      'name': 'Jane Smith',
      'punchIn': '08:45',
      'punchOut': '17:30',
      'type': 'Full Day'
    },
    {
      'date': '2024-06-08',
      'name': 'Jane Smith',
      'punchIn': '09:00',
      'punchOut': '12:30',
      'type': 'Half Day'
    },
  ];

  List<Map<String, dynamic>> get _filteredPunchCards {
    return _allPunchCards.where((card) {
      final date = DateTime.parse(card['date']);
      if (_fromDate != null && date.isBefore(_fromDate!)) return false;
      if (_toDate != null && date.isAfter(_toDate!)) return false;
      return true;
    }).toList();
  }

  void _onFromDateChanged(DateTime date) {
    setState(() {
      _fromDate = date;
    });
  }

  void _onToDateChanged(DateTime date) {
    setState(() {
      _toDate = date;
    });
  }

  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
    });
  }

  // Convert filtered data to the format expected by PunchRecordList
  List<Map<String, String>> get _formattedPunchRecords {
    return _filteredPunchCards.map((card) {
      // Format the date for better display
      final date = DateTime.parse(card['date']);
      final formattedDate = DateFormat('MMM dd, yyyy').format(date);

      return {
        'name': card['name'].toString(),
        'punchIn': card['punchIn'].toString(),
        'punchOut': card['punchOut'].toString(),
        'date': formattedDate,
        'type': card['type'].toString(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F6F8), // Using scaffoldBackgroundColor from theme
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 5.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1070), // Using primary color from theme
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
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (_fromDate != null || _toDate != null)
                IconButton(
                  icon: Icon(Icons.clear_all, color: Colors.white),
                  onPressed: _clearFilters,
                  tooltip: 'Clear Filters',
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
                            'Showing ${_filteredPunchCards.length} records',
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
              ],
            ),
          ),

          // Records list
          Expanded(
            child: _filteredPunchCards.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 64,
                            color: const Color(
                                0xFF5F6A7D), // Using secondary color
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
                            'Try adjusting your date filters',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF5C5C5C),
                            ),
                          ),
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