import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';
import '../screens/create_cohort_screen.dart';

class ManageCohortScreen extends StatefulWidget {
  const ManageCohortScreen({super.key});

  @override
  State<ManageCohortScreen> createState() => _ManageCohortScreenState();
}

class _ManageCohortScreenState extends State<ManageCohortScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'Name';

  final List<Map<String, String>> _cohorts = [
    {
      'name': 'Sumedh Sawant',
      'branch': 'Computer Engineering',
      'semester': '7',
      'className': 'BE / A',
      'academicYear': '2025-26',
      'image': 'assets/images/cohort1.png'
    },
    {
      'name': 'Tech Titans',
      'branch': 'Information Technology',
      'semester': '6',
      'className': 'TE / B',
      'academicYear': '2024-25',
      'image': 'assets/images/cohort2.png'
    },
    {
      'name': 'Alpha Coders',
      'branch': 'Artificial Intelligence',
      'semester': '5',
      'className': 'SE / C',
      'academicYear': '2023-24',
      'image': 'assets/images/cohort3.png'
    },
  ];

  List<Map<String, String>> get _filteredCohorts {
    final query = _searchController.text.toLowerCase();
    return _cohorts.where((cohort) => cohort['name']!.toLowerCase().contains(query)).toList();
  }

  void _showCohortDetails(Map<String, String> cohort) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFF2A1070).withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2A1070),
                        const Color(0xFF5A4FCF),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(cohort['image']!),
                    radius: 50,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Name
                Text(
                  cohort['name']!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A1070),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Details Cards
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF5A4FCF).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.school, 'Branch', cohort['branch']!),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.timeline, 'Semester', cohort['semester']!),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.class_, 'Class', cohort['className']!),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.calendar_today, 'Year', cohort['academicYear']!),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle edit
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.people,
                      label: 'Manage',
                      color: const Color(0xFF3B82F6),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle manage students
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.delete,
                      label: 'Delete',
                      color: const Color(0xFFD32F2F),
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(cohort);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF5A4FCF),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF5C5C5C),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1C1C1E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, String> cohort) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Cohort'),
        content: Text('Are you sure you want to delete "${cohort['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle delete
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(scaffoldKey: _scaffoldKey),
      drawer: const SideDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF4F6F8),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2A1070).withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF2A1070),
                                const Color(0xFF5A4FCF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.groups,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Cohorts',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: 28,
                                  color: const Color(0xFF2A1070),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'View, edit, and manage your student cohorts',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF5C5C5C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Search and Filter Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5A4FCF).withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search cohorts...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF5C5C5C).withOpacity(0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF5A4FCF),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Color(0xFF5C5C5C)),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Filter and Action Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF5A4FCF).withOpacity(0.3),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedSort,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF5A4FCF)),
                            items: ['Name', 'Semester', 'Year']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        'Sort by $e',
                                        style: const TextStyle(
                                          color: Color(0xFF1C1C1E),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedSort = value!),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF2A1070),
                                const Color(0xFF5A4FCF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2A1070).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CreateCohortScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text(
                              'New Cohort',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Cohorts List
              Expanded(
                child: _filteredCohorts.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _filteredCohorts.length,
                        itemBuilder: (_, index) {
                          final cohort = _filteredCohorts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _showCohortDetails(cohort),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      // Profile Image
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFF2A1070),
                                              const Color(0xFF5A4FCF),
                                            ],
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(cohort['image']!),
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      
                                      // Cohort Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cohort['name']!,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF1C1C1E),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${cohort['branch']} • Semester ${cohort['semester']}',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: const Color(0xFF5C5C5C),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF5A4FCF).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    cohort['className']!,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF5A4FCF),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  cohort['academicYear']!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF5C5C5C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Arrow Icon
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F6F8),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Color(0xFF5A4FCF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF5A4FCF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 64,
              color: Color(0xFF5A4FCF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No cohorts found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5C5C5C),
            ),
          ),
        ],
      ),
    );
  }
}