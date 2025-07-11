import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/apply_leave_screen.dart';
import '../services/api_services.dart';
import '../models/cancelled_leave_response.dart';
import 'package:pie_chart/pie_chart.dart';

// Helper to parse string numbers like "12.00" or "0" to int
int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value.split('.').first) ?? 0;
  }
  return 0;
}

class LeaveData {
  final String facultyName;
  final int casualLeave, medicalLeave, earnedLeave, compensationLeave;
  final int summerVacation, winterVacation, specialLeave, usedEarnedLeaves;
  final String remark;

  LeaveData({
    required this.facultyName,
    required this.casualLeave,
    required this.medicalLeave,
    required this.earnedLeave,
    required this.compensationLeave,
    required this.summerVacation,
    required this.winterVacation,
    required this.specialLeave,
    required this.usedEarnedLeaves,
    required this.remark,
  });
}

// Theme Colors
class AppColors {
  static const primary = Color(0xFF2A1070);
  static const accent = Color(0xFF5A4FCF);
  static const secondary = Color(0xFF5F6A7D);
  static const success = Color(0xFF2E7D32);
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFFFA000);
  static const info = Color(0xFF7986CB);
  static const vacation = Color(0xFF8E24AA);
  static const special = Color(0xFF00ACC1);
  static const background = Color(0xFFF4F6F8);
  static const textPrimary = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF5C5C5C);
}

class PendingLeaveScreen extends StatefulWidget {
  final String uid;
  final String token;

  const PendingLeaveScreen({Key? key, required this.uid, required this.token})
    : super(key: key);

  @override
  State<PendingLeaveScreen> createState() => _PendingLeaveScreenState();
}

class _PendingLeaveScreenState extends State<PendingLeaveScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController, _cardController;
  late Animation<double> _heroAnimation, _cardAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  LeaveData? _leaveData;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutBack,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    );

    _heroController.forward();
    Future.delayed(
      const Duration(milliseconds: 300),
      () => _cardController.forward(),
    );

    _loadLeaveData();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaveData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiList = await ApiServices.getFacultyCancelledLeave(
        uid: widget.uid,
        token: widget.token,
      );
      if (apiList.isNotEmpty) {
        final leave = apiList.first;
        setState(() {
          _leaveData = LeaveData(
            facultyName: leave.name,
            casualLeave: parseInt(leave.casualLeave),
            medicalLeave: parseInt(leave.medicalLeave),
            earnedLeave: parseInt(leave.earnedLeave),
            compensationLeave: parseInt(leave.compensationLeave),
            summerVacation: parseInt(leave.summerVacation),
            winterVacation: parseInt(leave.winterVacation),
            specialLeave: parseInt(leave.specialLeave),
            usedEarnedLeaves: leave.usedEarnedLeaves,
            remark: leave.remark ?? '',
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _leaveData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadLeaveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Updated Header - removed floating icons and increased text size
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Leave Balance',
              style: GoogleFonts.poppins(
                fontSize: 24, // Increased from 18 to 24
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _heroAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _heroAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: CustomPaint(painter: PatternPainter()),
                          ),
                        ),
                        // Removed the floating icons section
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _cardAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 50 * (1 - _cardAnimation.value)),
                child: Opacity(
                  opacity: _cardAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ApplyLeaveScreen()),
          );
        },
        backgroundColor: AppColors.accent,
        elevation: 8,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Apply Leave',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildShimmerLoading();
    } else if (_hasError) {
      return _buildErrorState();
    } else if (_leaveData != null) {
      return _buildLeaveContent(_leaveData!);
    } else {
      return _buildErrorState();
    }
  }

  Widget _buildLeaveContent(LeaveData leaveData) {
    return Column(
      children: [
        _buildQuickStatsCard(leaveData),
        const SizedBox(height: 20),
        _buildFacultyCard(leaveData),
        const SizedBox(height: 20),
        _buildLeaveGrid(leaveData),
        const SizedBox(height: 20),
        _buildSummary(leaveData),
      ],
    );
  }

  Widget _buildQuickStatsCard(LeaveData leaveData) {
    final totalAvailable =
        leaveData.casualLeave +
        leaveData.medicalLeave +
        leaveData.earnedLeave +
        leaveData.compensationLeave +
        leaveData.summerVacation +
        leaveData.winterVacation +
        leaveData.specialLeave;
    final usedEarnedLeavesNum =
        num.tryParse(leaveData.usedEarnedLeaves.toString()) ?? 0;
    final earnedLeaveNum = num.tryParse(leaveData.earnedLeave.toString()) ?? 1;
    final utilizationRate =
        (earnedLeaveNum != 0 ? (usedEarnedLeavesNum / earnedLeaveNum * 100) : 0)
            .round();

    return Row(
      children: [
        Expanded(
          child: _buildQuickStatItem(
            "Available",
            "$totalAvailable",
            AppColors.success,
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatItem(
            "Used",
            "${leaveData.usedEarnedLeaves}",
            AppColors.warning,
            Icons.schedule,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatItem(
            "Rate",
            "$utilizationRate%",
            AppColors.info,
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyCard(LeaveData leaveData) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Text(
                  leaveData.facultyName
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leaveData.facultyName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active Faculty',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.accent,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveGrid(LeaveData leaveData) {
    final leaveItems = [
      _LeaveItem(
        'Casual Leave',
        int.tryParse(leaveData.casualLeave.toString()) ?? 0,
        12,
        Icons.person_outline,
        AppColors.info,
      ),
      _LeaveItem(
        'Medical Leave',
        int.tryParse(leaveData.medicalLeave.toString()) ?? 0,
        15,
        Icons.medical_services_outlined,
        AppColors.error,
      ),
      _LeaveItem(
        'Earned Leave',
        int.tryParse(leaveData.earnedLeave.toString()) ?? 0,
        30,
        Icons.star_outline,
        AppColors.warning,
      ),
      _LeaveItem(
        'Compensation Leave',
        int.tryParse(leaveData.compensationLeave.toString()) ?? 0,
        10,
        Icons.balance_outlined,
        AppColors.accent,
      ),
      _LeaveItem(
        'Summer Vacation',
        int.tryParse(leaveData.summerVacation.toString()) ?? 0,
        60,
        Icons.wb_sunny_outlined,
        AppColors.vacation,
      ),
      _LeaveItem(
        'Winter Vacation',
        int.tryParse(leaveData.winterVacation.toString()) ?? 0,
        15,
        Icons.ac_unit_outlined,
        AppColors.info,
      ),
      _LeaveItem(
        'Special Leave',
        int.tryParse(leaveData.specialLeave.toString()) ?? 0,
        5,
        Icons.card_giftcard_outlined,
        AppColors.special,
      ),
      _LeaveItem(
        'Used Earned Leaves',
        int.tryParse(leaveData.usedEarnedLeaves.toString()) ?? 0,
        int.tryParse(leaveData.earnedLeave.toString()) ?? 0,
        Icons.assignment_turned_in_outlined,
        AppColors.secondary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leave Categories',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                1.0, // Changed from 1.1 to 1.0 to provide more height
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: leaveItems.length,
          itemBuilder: (context, index) =>
              _buildLeaveCard(leaveItems[index], index),
        ),
      ],
    );
  }

  Widget _buildLeaveCard(_LeaveItem item, int index) {
    final progress = item.available > 0 ? (item.count / item.available) : 0.0;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animation, child) => Transform.scale(
        scale: animation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            item.color.withOpacity(0.1),
                            item.color.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    const Spacer(),
                    Text(
                      '${item.count}',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: item.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 1200 + (index * 200)),
                  tween: Tween(begin: 0.0, end: progress),
                  builder: (context, progressAnimation, child) => Column(
                    children: [
                      LinearProgressIndicator(
                        value: progressAnimation,
                        backgroundColor: item.color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(item.color),
                        minHeight: 4,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progressAnimation * 100).round()}% utilized',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(LeaveData leaveData) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Leave Analytics',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PieChart(
            dataMap: {
              "Casual": leaveData.casualLeave.toDouble(),
              "Medical": leaveData.medicalLeave.toDouble(),
              "Earned": leaveData.earnedLeave.toDouble(),
              "Compensation": leaveData.compensationLeave.toDouble(),
              "Summer": leaveData.summerVacation.toDouble(),
              "Winter": leaveData.winterVacation.toDouble(),
              "Special": leaveData.specialLeave.toDouble(),
            },
            colorList: [
              AppColors.info,
              AppColors.error,
              AppColors.warning,
              AppColors.accent,
              AppColors.vacation,
              AppColors.secondary,
              AppColors.special,
            ],
            chartRadius: 120,
            chartType: ChartType.disc,
            legendOptions: const LegendOptions(
              showLegends: true,
              legendPosition: LegendPosition.right,
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValues: true,
            ),
          ),
          if (leaveData.remark != null &&
              leaveData.remark?.isNotEmpty == true) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                        Text(
                          leaveData.remark ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.error_outline, size: 48, color: AppColors.error),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load leave data',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaveItem {
  final String title;
  final int count, available;
  final IconData icon;
  final Color color;
  _LeaveItem(this.title, this.count, this.available, this.icon, this.color);
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    for (int i = 0; i < size.width; i += 30) {
      for (int j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CancelledLeavesScreen extends StatefulWidget {
  final String uid;
  final String token;

  const CancelledLeavesScreen({
    Key? key,
    required this.uid,
    required this.token,
  }) : super(key: key);

  @override
  State<CancelledLeavesScreen> createState() => _CancelledLeavesScreenState();
}

class _CancelledLeavesScreenState extends State<CancelledLeavesScreen> {
  late Future<List<CancelledLeaveResponse>> _cancelledLeavesFuture;

  @override
  void initState() {
    super.initState();
    _cancelledLeavesFuture = ApiServices.getFacultyCancelledLeave(
      uid: widget.uid,
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cancelled Leaves')),
      body: FutureBuilder<List<CancelledLeaveResponse>>(
        future: _cancelledLeavesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cancelled leaves found.'));
          }
          final leaves = snapshot.data!;
          return ListView.builder(
            itemCount: leaves.length,
            itemBuilder: (context, index) {
              final leave = leaves[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(leave.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Casual Leave: ${leave.casualLeave}'),
                      Text('Earned Leave: ${leave.earnedLeave}'),
                      Text('Special Leave: ${leave.specialLeave}'),
                      Text('Summer Vacation: ${leave.summerVacation}'),
                      Text('Winter Vacation: ${leave.winterVacation}'),
                      Text('Compensation Leave: ${leave.compensationLeave}'),
                      Text('Medical Leave: ${leave.medicalLeave}'),
                      Text('Maternity Leave: ${leave.maternityLeave}'),
                      Text('Used Earned Leaves: ${leave.usedEarnedLeaves}'),
                      if (leave.remark != null) Text('Remark: ${leave.remark}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
