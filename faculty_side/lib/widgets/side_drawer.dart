import 'package:flutter/material.dart';
import '../screens/apply_leave_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/alternate_leave_approval_screen.dart';
import '../screens/my_mentee_screen.dart';
import '../screens/punch_record_screen.dart';
import '../screens/your_courses.dart';
import '../screens/alternate_approved_leaves.dart';
import '../screens/reset_password.dart';
import '../screens/create_cohort_screen.dart';
import '../screens/manage_cohort_screen.dart';
import '../screens/mark_attendance.dart';
import '../screens/your_classrooms.dart';
import '../screens/payslip_screen.dart';
import '../screens/leave_history.dart';
import '../screens/cancelled_leaves.dart';
import '../screens/manage_classroom_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2A1070),
              const Color(0xFF5A4FCF),
              const Color(0xFF2A1070).withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.dashboard,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Academate",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                  children: [
                    Text(
                      "MAIN MENU",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF5C5C5C),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dashboard
                    _buildMenuItem(
                      context,
                      icon: Icons.dashboard,
                      title: "Dashboard",
                      subtitle: "View overview",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Leaves Section
                    _buildExpandableMenuItem(
                      context,
                      icon: Icons.event_note,
                      title: "Leave Management",
                      subtitle: "Apply & track leaves",
                      children: [
                        _buildSubMenuItem(
                          context,
                          icon: Icons.add_circle_outline,
                          title: "Apply Leave",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ApplyLeaveScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.history,
                          title: "Leave History",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LeaveHistoryScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.history,
                          title: "Cancelled Leaves",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PendingLeaveScreen()),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Alternate Leaves
                    _buildExpandableMenuItem(
                      context,
                      icon: Icons.swap_calls,
                      title: "Alternate Leaves",
                      subtitle: "Manage substitutions",
                      children: [
                        _buildSubMenuItem(
                          context,
                          icon: Icons.check_circle,
                          title: "Leave Approval",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AlternateApprovalScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.check_circle_outline,
                          title: "Approved Leaves",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AlternateApprovedLeaves()),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Punch Record
                    _buildMenuItem(
                      context,
                      icon: Icons.access_time,
                      title: "Punch Record",
                      subtitle: "Track attendance",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PunchRecordScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Courses
                    _buildExpandableMenuItem(
                      context,
                      icon: Icons.school,
                      title: "Courses",
                      subtitle: "Manage curriculum",
                      children: [
                        _buildSubMenuItem(
                          context,
                          icon: Icons.book,
                          title: "Your Courses",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const YourCourses()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.assignment,
                          title: "PO's",
                          enabled: false,
                          onTap: () {},
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.map,
                          title: "COPO Mapping",
                          enabled: false,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Assessment
                    _buildMenuItem(
                      context,
                      icon: Icons.checklist,
                      title: "Assessment",
                      subtitle: "Evaluate performance",
                      enabled: false,
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),

                    // LMS
                    _buildExpandableMenuItem(
                      context,
                      icon: Icons.class_,
                      title: "Learning Management",
                      subtitle: "Classroom & cohorts",
                      children: [
                        _buildSubMenuItem(
                          context,
                          icon: Icons.meeting_room,
                          title: "Classroom",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ClassroomScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.group_add,
                          title: "Manage Classroom",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ManageClassroomScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.group_add,
                          title: "Create Cohort",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CreateCohortScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.group,
                          title: "Manage Cohort",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ManageCohortScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.how_to_reg,
                          title: "Mark Attendance",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ManageAttendance()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.history,
                          title: "Attendance History",
                          enabled: false,
                          onTap: () {},
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.supervisor_account,
                          title: "My Mentees",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MyMenteesScreen()),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Exam
                    _buildMenuItem(
                      context,
                      icon: Icons.quiz,
                      title: "Examinations",
                      subtitle: "Manage exams",
                      enabled: false,
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),

                    // Add-ons
                    _buildExpandableMenuItem(
                      context,
                      icon: Icons.extension,
                      title: "Additional Features",
                      subtitle: "Extra utilities",
                      children: [
                        _buildSubMenuItem(
                          context,
                          icon: Icons.receipt_long,
                          title: "Download Pay Slip",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SalarySlipScreen()),
                            );
                          },
                        ),
                        _buildSubMenuItem(
                          context,
                          icon: Icons.lock_reset,
                          title: "Reset Password",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Logout Section
            Container(
              color: const Color(0xFFF4F6F8),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFD32F2F).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Color(0xFFD32F2F),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "Sign out safely",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFD32F2F).withOpacity(0.7),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Logged out successfully"),
                        backgroundColor: const Color(0xFFD32F2F),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    // Add actual logout logic here
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A1070).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: enabled 
                ? const Color(0xFF2A1070).withOpacity(0.1)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: enabled 
                ? const Color(0xFF2A1070)
                : Colors.grey,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: enabled 
                ? const Color(0xFF1C1C1E)
                : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: enabled 
                      ? const Color(0xFF5C5C5C)
                      : Colors.grey,
                ),
              )
            : null,
        trailing: enabled
            ? Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF5C5C5C),
                size: 16,
              )
            : null,
        onTap: enabled ? onTap : null,
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A1070).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          listTileTheme: const ListTileThemeData(
            dense: true,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2A1070).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2A1070),
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1C1C1E),
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF5C5C5C),
                  ),
                )
              : null,
          iconColor: const Color(0xFF2A1070),
          collapsedIconColor: const Color(0xFF5C5C5C),
          children: children,
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: enabled 
            ? const Color(0xFFF4F6F8)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: enabled 
                ? const Color(0xFF5A4FCF).withOpacity(0.1)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: enabled 
                ? const Color(0xFF5A4FCF)
                : Colors.grey,
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: enabled 
                ? const Color(0xFF1C1C1E)
                : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: enabled
            ? Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF5C5C5C),
                size: 14,
              )
            : null,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}