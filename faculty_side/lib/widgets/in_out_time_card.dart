import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/theme.dart'; // Adjust based on your folder structure

class InOutTimeCard extends StatelessWidget {
  const InOutTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      shadowColor: AppColors.primary.withOpacity(0.15),
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            _InOutColumn(
              icon: FontAwesomeIcons.rightToBracket,
              label: 'IN TIME',
              time: '-----',
              gradientColors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            ),
            _InOutColumn(
              icon: FontAwesomeIcons.rightFromBracket,
              label: 'OUT TIME',
              time: '-----',
              gradientColors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
            ),
          ],
        ),
      ),
    );
  }
}

class _InOutColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final List<Color> gradientColors;

  const _InOutColumn({
    required this.icon,
    required this.label,
    required this.time,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gradient Icon Circle
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(height: 12),

        // Label
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),

        // Time Text
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
