import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PunchRecordList extends StatelessWidget {
  final List<Map<String, String>> punchRecords;

  const PunchRecordList({super.key, required this.punchRecords});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: punchRecords.map((record) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              record['name'] ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'In: ${record['punchIn']} | Out: ${record['punchOut']}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            trailing: Text(
              record['date'] ?? '',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
