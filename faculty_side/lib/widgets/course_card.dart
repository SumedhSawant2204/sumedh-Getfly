import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../themes/theme.dart'; // adjust import based on your project structure

class CourseCard extends StatelessWidget {
  final String courseName;
  final String semester;
  final String academicYear;
  final String branch;
  final int coCount;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.semester,
    required this.academicYear,
    required this.branch,
    required this.coCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: AppColors.primary.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Title
            Row(
              children: [
                const Icon(FontAwesomeIcons.bookOpenReader,
                    size: 20, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    courseName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Details Section
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                _buildDetailItem(
                  icon: FontAwesomeIcons.calendarDays,
                  label: "Semester",
                  value: semester,
                ),
                _buildDetailItem(
                  icon: FontAwesomeIcons.graduationCap,
                  label: "Year",
                  value: academicYear,
                ),
                _buildDetailItem(
                  icon: FontAwesomeIcons.codeBranch,
                  label: "Branch",
                  value: branch,
                ),
                _buildDetailItem(
                  icon: FontAwesomeIcons.listCheck,
                  label: "CO Count",
                  value: "$coCount",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
