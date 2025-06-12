import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';
import '../themes/theme.dart'; // Import your theme

class CreateCohortScreen extends StatefulWidget {
  const CreateCohortScreen({super.key});

  @override
  State<CreateCohortScreen> createState() => _CreateCohortScreenState();
}

class _CreateCohortScreenState extends State<CreateCohortScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController cohortController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  String? selectedBranch;
  String? selectedAcademicYear;

  final List<String> branches = ['Computer', 'IT', 'EXTC', 'Mechanical', 'Civil'];
  final List<String> academicYears = ['2022-23', '2023-24', '2024-25', '2025-26'];

  void createCohort() {
    if (cohortController.text.isNotEmpty &&
        selectedBranch != null &&
        semesterController.text.isNotEmpty &&
        classController.text.isNotEmpty &&
        selectedAcademicYear != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Cohort created successfully", 
                style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      // Clear form
      setState(() {
        cohortController.clear();
        semesterController.clear();
        classController.clear();
        selectedBranch = null;
        selectedAcademicYear = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text("Please fill in all fields", 
                style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Widget buildFormCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 700),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.group_add,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cohort Details",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "Fill in the information below to create a new cohort",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Cohort Name Field
            _buildInputField(
              label: "Cohort Name",
              icon: Icons.groups,
              child: TextFormField(
                controller: cohortController,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Enter cohort name (e.g., Batch 2024-A)",
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  prefixIcon: Icon(Icons.groups, color: AppColors.accent),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Branch and Semester Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: "Branch",
                    icon: Icons.school,
                    child: DropdownButtonFormField<String>(
                      value: selectedBranch,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "Select branch",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(Icons.school, color: AppColors.accent),
                      ),
                      items: branches.map((branch) {
                        return DropdownMenuItem(
                          value: branch,
                          child: Text(branch),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBranch = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildInputField(
                    label: "Semester",
                    icon: Icons.calendar_today,
                    child: TextFormField(
                      controller: semesterController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "1-8",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(Icons.calendar_today, color: AppColors.accent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Class Name and Academic Year Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: "Class Name",
                    icon: Icons.class_,
                    child: TextFormField(
                      controller: classController,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter class name (e.g., CSE-A)",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(Icons.class_, color: AppColors.accent),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildInputField(
                    label: "Academic Year",
                    icon: Icons.date_range,
                    child: DropdownButtonFormField<String>(
                      value: selectedAcademicYear,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "Select academic year",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(Icons.date_range, color: AppColors.accent),
                      ),
                      items: academicYears.map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAcademicYear = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 40),
            
            // Create Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: createCohort,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Create Cohort",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer(),
      appBar: AppHeader(scaffoldKey: _scaffoldKey),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32),
            
            // Page Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.group_add,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Create New Cohort",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Set up a new student cohort for your academic program",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Form Card
            Center(child: buildFormCard()),
            
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cohortController.dispose();
    semesterController.dispose();
    classController.dispose();
    super.dispose();
  }
}