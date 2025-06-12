import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';
import '../widgets/app_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  
  String? gender, facultyType, department, designation, bloodGroup;
  int currentStep = 0;

  final List<String> sectionTitles = [
    'Personal Information',
    'Professional Details',
    'Contact & Address',
    'Documents'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer(),
      appBar: AppHeader(scaffoldKey: _scaffoldKey),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2A1070),
                      const Color(0xFF5A4FCF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2A1070).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: const Color(0xFF5A4FCF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile Settings',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Update your personal and professional information',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
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

              // Progress Indicator
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Your Profile',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2A1070),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: const Color(0xFF5A4FCF).withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF5A4FCF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '65% Complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF5C5C5C),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Form Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Personal Information Section
                      _buildSection(
                        'Personal Information',
                        Icons.person_outline,
                        [
                          Row(
                            children: [
                              Expanded(child: _buildTextField(label: "Full Name", icon: Icons.person)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: "Gender",
                                  value: gender,
                                  items: ["Male", "Female", "Other"],
                                  onChanged: (val) => setState(() => gender = val),
                                  icon: Icons.wc,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(label: "Email Address", icon: Icons.email)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: "Blood Group",
                                  value: bloodGroup,
                                  items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
                                  onChanged: (val) => setState(() => bloodGroup = val),
                                  icon: Icons.bloodtype,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(label: "Phone Number", keyboardType: TextInputType.phone, icon: Icons.phone)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(label: "Alternate Mobile", keyboardType: TextInputType.phone, icon: Icons.phone_android)),
                            ],
                          ),
                        ],
                      ),

                      _buildDivider(),

                      // Professional Details Section
                      _buildSection(
                        'Professional Details',
                        Icons.work_outline,
                        [
                          Row(
                            children: [
                              Expanded(child: _buildTextField(label: "Faculty College ID", icon: Icons.badge)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(label: "Joining Date", keyboardType: TextInputType.datetime, icon: Icons.calendar_today)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: "Faculty Type",
                                  value: facultyType,
                                  items: ["Full Time", "Part Time", "Visiting"],
                                  onChanged: (val) => setState(() => facultyType = val),
                                  icon: Icons.access_time,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: "Department",
                                  value: department,
                                  items: ["Computer Engineering", "Information Technology", "EXTC", "Mechanical Engineering"],
                                  onChanged: (val) => setState(() => department = val),
                                  icon: Icons.school,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: "Faculty Designation",
                                  value: designation,
                                  items: ["Professor", "Assistant Professor", "Associate Professor", "Lecturer"],
                                  onChanged: (val) => setState(() => designation = val),
                                  icon: Icons.work,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(label: "Qualification", icon: Icons.school)),
                            ],
                          ),
                          _buildTextField(label: "Experience Details", maxLines: 3, icon: Icons.history_edu),
                        ],
                      ),

                      _buildDivider(),

                      // Contact & Address Section
                      _buildSection(
                        'Contact & Address',
                        Icons.location_on_outlined,
                        [
                          Row(
                            children: [
                              Expanded(child: _buildTextField(label: "PAN Number", icon: Icons.credit_card)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(label: "Aadhar Number", icon: Icons.fingerprint)),
                            ],
                          ),
                          _buildTextField(label: "Permanent Address", maxLines: 2, icon: Icons.home),
                          _buildTextField(label: "Current Address", maxLines: 2, icon: Icons.location_city),
                        ],
                      ),

                      _buildDivider(),

                      // Documents Section
                      _buildSection(
                        'Documents',
                        Icons.upload_file,
                        [
                          Row(
                            children: [
                              Expanded(child: _buildFileField(label: "Profile Photo", icon: Icons.photo_camera)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildFileField(label: "Digital Signature", icon: Icons.draw)),
                            ],
                          ),
                          _buildFileField(label: "Curriculum Vitae (CV)", icon: Icons.description),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _formKey.currentState?.reset();
                                  setState(() {
                                    gender = null;
                                    facultyType = null;
                                    department = null;
                                    designation = null;
                                    bloodGroup = null;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF5A4FCF)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: const Color(0xFF2A1070),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF5A4FCF),
                                      const Color(0xFF2A1070),
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
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle, color: Colors.white),
                                              const SizedBox(width: 8),
                                              Text("Profile Updated Successfully"),
                                            ],
                                          ),
                                          backgroundColor: const Color(0xFF10B981),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  icon: const Icon(Icons.save, size: 20),
                                  label: const Text(
                                    'Update Profile',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5A4FCF).withOpacity(0.2),
                      const Color(0xFF2A1070).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2A1070),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF2A1070),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF5A4FCF).withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5A4FCF).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF5A4FCF),
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF5A4FCF).withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF5A4FCF).withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A1070), width: 2),
            ),
            labelStyle: TextStyle(color: const Color(0xFF5C5C5C)),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (val) => val == null || val.isEmpty ? "This field is required" : null,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5A4FCF).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF5A4FCF),
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF5A4FCF).withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF5A4FCF).withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2A1070), width: 2),
            ),
            labelStyle: TextStyle(color: const Color(0xFF5C5C5C)),
          ),
          value: value,
          items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(color: const Color(0xFF1C1C1E)),
            ),
          )).toList(),
          onChanged: onChanged,
          validator: (val) => val == null || val.isEmpty ? "Please select an option" : null,
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: const Color(0xFF5A4FCF),
          ),
        ),
      ),
    );
  }

  Widget _buildFileField({required String label, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF5A4FCF).withOpacity(0.3),
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5A4FCF).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF5A4FCF),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1C1C1E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF5A4FCF),
                    const Color(0xFF2A1070),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2A1070).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload, size: 18),
                label: const Text(
                  "Choose File",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  // TODO: Implement file picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("File picker for $label will be implemented"),
                      backgroundColor: const Color(0xFF3B82F6),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}