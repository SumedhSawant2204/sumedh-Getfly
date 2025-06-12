import '../widgets/custom_appBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Classroom {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  Classroom({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });
}

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Classroom> _classrooms = [];
  List<Classroom> _filteredClassrooms = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterClassrooms);

    // Initialize with sample data
    _classrooms = [
      Classroom(
        id: '1',
        name: 'Mathematics 101',
        description: 'Semester 5',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      Classroom(
        id: '2',
        name: 'Physics Advanced',
        description: 'Semester 1',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
      ),
      Classroom(
        id: '3',
        name: 'Chemistry Fundamentals',
        description: 'Semester 2',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
    ];

    _filteredClassrooms = List.from(_classrooms);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterClassrooms() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredClassrooms = _classrooms;
      } else {
        String searchTerm = _searchController.text.toLowerCase();
        _filteredClassrooms = _classrooms
            .where((classroom) =>
                classroom.name.toLowerCase().contains(searchTerm) ||
                classroom.description.toLowerCase().contains(searchTerm))
            .toList();
      }
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  Widget _buildClassroomCard(Classroom classroom) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.class_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classroom.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (classroom.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        classroom.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Active',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Created ${_formatDate(classroom.createdAt)}',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
          title: 'Your Classrooms',
          subtitle:
              'Manage your virtual classrooms, assignments, and student interactions.'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Classrooms header with count and search
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.class_outlined,
                          size: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Classrooms (${_classrooms.length})',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search classrooms...',
                      hintStyle:
                          TextStyle(color: theme.textTheme.bodySmall?.color),
                      prefixIcon: Icon(Icons.search,
                          color: theme.textTheme.bodyMedium?.color),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Classrooms list
            Expanded(
              child: _filteredClassrooms.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _filteredClassrooms.length,
                      itemBuilder: (context, index) {
                        return _buildClassroomCard(_filteredClassrooms[index]);
                      },
                    ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
      // Floating Action Button to Start a Meeting
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _startMeeting();
        },
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.video_call),
        label: const Text('Start Meeting'),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.info_outline,
              size: 28,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Classrooms Found',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'No classrooms match your search criteria',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _startMeeting() async {
    const String meetUrl = 'https://meet.google.com/new';
    final Uri uri = Uri.parse(meetUrl);

    try {
      final bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw Exception('Launch failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to start Google Meet.')),
        );
      }
    }
  }
}