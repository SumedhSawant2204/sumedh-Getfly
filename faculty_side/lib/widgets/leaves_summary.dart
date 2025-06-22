import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/theme.dart'; // Adjust path if needed
import '../services/api_services.dart';
import '../models/LeaveCountResponse.dart';

class LeavesSummary extends StatefulWidget {
  final String uid;
  final String token;

  const LeavesSummary({super.key, required this.uid, required this.token});

  @override
  State<LeavesSummary> createState() => _LeavesSummaryState();
}

class _LeavesSummaryState extends State<LeavesSummary>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _controller;

  List<Map<String, dynamic>> leaveData = [];
  bool _loading = true;
  String? _error;

  final icons = [
    FontAwesomeIcons.clock,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.stethoscope,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.snowflake,
    FontAwesomeIcons.moneyCheckAlt,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fetchLeaves();
  }

  Future<void> _fetchLeaves() async {
    try {
      final result = await ApiServices.getLeaveCount(
        uid: widget.uid,
        token: widget.token,
      );
      if (result.isNotEmpty) {
        final leave = result.first;
        leaveData = [
          {
            'label': 'Casual Leave',
            'value': leave.casualLeave,
            'icon': icons[0],
          },
          {
            'label': 'Earned Leave',
            'value': leave.earnedLeave,
            'icon': icons[1],
          },
          {
            'label': 'Medical Leave',
            'value': leave.medicalLeave,
            'icon': icons[2],
          },
          {
            'label': 'Summer Vacation',
            'value': leave.summerVacation,
            'icon': icons[3],
          },
          {
            'label': 'Winter Vacation',
            'value': leave.winterVacation,
            'icon': icons[4],
          },
          {
            'label': 'Compensation Leave',
            'value': leave.compensationLeave,
            'icon': icons[5],
          },
        ];
      }
      setState(() {
        _loading = false;
        _error = null;
      });
      _insertItems();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _insertItems() async {
    for (int i = 0; i < leaveData.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLeaveItem(Map<String, dynamic> leave, int index, Animation<double> animation) {
    final theme = Theme.of(context);

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(
              leave['icon'],
              color: theme.colorScheme.primary,
              size: 18,
            ),
          ),
          title: Text(
            '${leave['label']} - ${leave['value']}',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${leave['label']} clicked'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Leaves Summary",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
            else
              AnimatedList(
                key: _listKey,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: 0,
                itemBuilder: (context, index, animation) {
                  return _buildLeaveItem(leaveData[index], index, animation);
                },
              ),
          ],
        ),
      ),
    );
  }
}
