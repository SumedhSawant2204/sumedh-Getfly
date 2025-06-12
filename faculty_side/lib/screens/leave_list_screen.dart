import 'package:flutter/material.dart';
import '../models/leave_request.dart';
import 'leave_detail_screen.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> 
    with TickerProviderStateMixin {
  final List<LeaveRequest> requests = [
    LeaveRequest(
      facultyName: 'Dr. GAYATRI DASHRATH BACHHAV',
      numberOfDays: 0.5,
      leaveType: 'Outdoor Duty',
      leaveReason: 'Education Summit',
      from: '05/12/2024',
      to: '05/12/2024',
      appliedDate: '01/01/1970',
    ),
    LeaveRequest(
      facultyName: 'Mr. ATUL HINDURAO SHINTRE',
      numberOfDays: 0.5,
      leaveType: 'Compensation Leave',
      leaveReason: 'Relative expired',
      from: '06/01/2025',
      to: '06/01/2025',
      appliedDate: '01/01/1970',
    ),
    LeaveRequest(
      facultyName: 'Dr. MAHAVIR ARJUN DEVMANE',
      numberOfDays: 1.0,
      leaveType: 'Compensation Leave',
      leaveReason: 'My son is ill...require medical treatment',
      from: '10/01/2025',
      to: '10/01/2025',
      appliedDate: '01/01/1970',
    ),
    LeaveRequest(
      facultyName: 'MRS. MANJIRI CHAITANYA KARANDIKAR',
      numberOfDays: 0.5,
      leaveType: 'Compensation Leave',
      leaveReason: 'Personal reason',
      from: '09/01/2025',
      to: '09/01/2025',
      appliedDate: '01/01/1970',
    ),
  ];

  late final AnimationController _headerAnimController;
  late final AnimationController _listAnimController;
  late final Animation<double> _headerFadeAnimation;
  late final Animation<Offset> _headerSlideAnimation;

  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Pending', 'Approved', 'Denied'];

  @override
  void initState() {
    super.initState();
    
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerFadeAnimation = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOutCubic,
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _headerAnimController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      _listAnimController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // AppColors.background
      appBar: AppBar(
        title: Text(
          'Leave Requests',
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Statistics and Filter Section
          SlideTransition(
            position: _headerSlideAnimation,
            child: FadeTransition(
              opacity: _headerFadeAnimation,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildStatsCard(theme),
                    const SizedBox(height: 16),
                    _buildFilterSection(theme),
                  ],
                ),
              ),
            ),
          ),
          
          // Leave Requests List
          Expanded(
            child: AnimatedBuilder(
              animation: _listAnimController,
              builder: (context, child) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _listAnimController,
                      builder: (context, child) {
                        final animationValue = Curves.easeOutCubic.transform(
                          (_listAnimController.value - (index * 0.1)).clamp(0.0, 1.0),
                        );
                        
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - animationValue)),
                          child: Opacity(
                            opacity: animationValue,
                            child: _EnhancedLeaveCard(
                              leaveRequest: requests[index],
                              index: index,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        LeaveDetailScreen(request: requests[index]),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        )),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 300),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new leave request functionality
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
        elevation: 8,
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            const Color(0xFF5A4FCF), // AppColors.accent
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Total', '${requests.length}', Icons.assignment_outlined, theme),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem('Pending', '${requests.length}', Icons.schedule_outlined, theme),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem('This Week', '2', Icons.calendar_today_outlined, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = option == _selectedFilter;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = option;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : const Color(0xFF5A4FCF).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Text(
                option,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : const Color(0xFF5C5C5C),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EnhancedLeaveCard extends StatefulWidget {
  final LeaveRequest leaveRequest;
  final int index;
  final VoidCallback onTap;

  const _EnhancedLeaveCard({
    required this.leaveRequest,
    required this.index,
    required this.onTap,
  });

  @override
  State<_EnhancedLeaveCard> createState() => __EnhancedLeaveCardState();
}

class __EnhancedLeaveCardState extends State<_EnhancedLeaveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF5A4FCF).withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Avatar with gradient background
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.8),
                              const Color(0xFF5A4FCF).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.leaveRequest.facultyName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF1C1C1E), // AppColors.textPrimary
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.leaveRequest.leaveType,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${widget.leaveRequest.numberOfDays} day${widget.leaveRequest.numberOfDays != 1 ? 's' : ''}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF5C5C5C), // AppColors.textSecondary
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range_outlined,
                                  size: 16,
                                  color: const Color(0xFF5C5C5C),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.leaveRequest.from} - ${widget.leaveRequest.to}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF5C5C5C),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Status and Arrow
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.1), // AppColors.warning
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Pending',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFFF59E0B),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}