import '../widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class SalarySlipScreen extends StatefulWidget {
  const SalarySlipScreen({super.key});

  @override
  State<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
  String? selectedMonth;
  bool isLoading = false;

  // Sample faculty data - replace with actual data from your backend
  final Map<String, dynamic> facultyData = {
    'name': 'Dr. Sarah Johnson',
    'designation': 'Associate Professor',
    'employeeId': 'EMP001',
    'department': 'Computer Science',
    'bankName': 'State Bank of India',
    'branch': 'University Campus Branch',
    'accountNo': '1234567890',
    'basicSalary': 75000.0,
    'hra': 18750.0,
    'da': 15000.0,
    'ta': 5000.0,
    'medicalAllowance': 2500.0,
    'pf': 9000.0,
    'tax': 12000.0,
    'insurance': 1500.0,
  };

  final List<Map<String, String>> months = [
    {'value': '2025-06', 'display': 'June 2025'},
    {'value': '2025-05', 'display': 'May 2025'},
    {'value': '2025-04', 'display': 'April 2025'},
    {'value': '2025-03', 'display': 'March 2025'},
    {'value': '2025-02', 'display': 'February 2025'},
    {'value': '2025-01', 'display': 'January 2025'},
    {'value': '2024-12', 'display': 'December 2024'},
    {'value': '2024-11', 'display': 'November 2024'},
    {'value': '2024-10', 'display': 'October 2024'},
    {'value': '2024-09', 'display': 'September 2024'},
    {'value': '2024-08', 'display': 'August 2024'},
    {'value': '2024-07', 'display': 'July 2024'},
  ];

  double _calculateGrossSalary() {
    return facultyData['basicSalary'] + 
           facultyData['hra'] + 
           facultyData['da'] + 
           facultyData['ta'] + 
           facultyData['medicalAllowance'];
  }

  double _calculateDeductions() {
    return facultyData['pf'] + 
           facultyData['tax'] + 
           facultyData['insurance'];
  }

  double _calculateNetSalary() {
    return _calculateGrossSalary() - _calculateDeductions();
  }

  Future<pw.Document> _generatePDF() async {
    final pdf = pw.Document();
    final grossSalary = _calculateGrossSalary();
    final deductions = _calculateDeductions();
    final netSalary = _calculateNetSalary();
    final selectedMonthDisplay = _getSelectedMonthDisplay();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#2A1070'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'SALARY SLIP',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      selectedMonthDisplay,
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 30),
              
              // Employee Details
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Employee Details',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF2A1070),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Name:', facultyData['name']),
                              _buildDetailRow('Employee ID:', facultyData['employeeId']),
                              _buildDetailRow('Designation:', facultyData['designation']),
                              _buildDetailRow('Department:', facultyData['department']),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 30),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Bank Name:', facultyData['bankName']),
                              _buildDetailRow('Branch:', facultyData['branch']),
                              _buildDetailRow('Account No:', facultyData['accountNo']),
                              _buildDetailRow('Pay Date:', DateTime.now().toString().split(' ')[0]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 30),
              
              // Salary Breakdown
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Earnings
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Earnings',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#2E7D32'),
                            ),
                          ),
                          pw.SizedBox(height: 15),
                          _buildSalaryRow('Basic Salary', facultyData['basicSalary']),
                          _buildSalaryRow('HRA', facultyData['hra']),
                          _buildSalaryRow('DA', facultyData['da']),
                          _buildSalaryRow('TA', facultyData['ta']),
                          _buildSalaryRow('Medical Allowance', facultyData['medicalAllowance']),
                          pw.Divider(color: PdfColors.grey300),
                          _buildSalaryRow('Gross Salary', grossSalary, isTotal: true),
                        ],
                      ),
                    ),
                  ),
                  
                  pw.SizedBox(width: 20),
                  
                  // Deductions
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Deductions',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#D32F2F'),
                            ),
                          ),
                          pw.SizedBox(height: 15),
                          _buildSalaryRow('PF', facultyData['pf']),
                          _buildSalaryRow('Tax', facultyData['tax']),
                          _buildSalaryRow('Insurance', facultyData['insurance']),
                          pw.SizedBox(height: 45), // Space to align with earnings
                          pw.Divider(color: PdfColors.grey300),
                          _buildSalaryRow('Total Deductions', deductions, isTotal: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 30),
              
              // Net Salary
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFF2A1070),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'NET SALARY',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.Text(
                      '₹${netSalary.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.Spacer(),
              
              // Footer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Text(
                  'This is a system generated salary slip and does not require signature.',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.italic,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSalaryRow(String label, double amount, {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: PdfColors.black,
            ),
          ),
          pw.Text(
            '₹${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadSalarySlip() async {
    if (selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a month first'),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Generate PDF
      final pdf = await _generatePDF();
      
      // Show PDF preview and download options
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Salary_Slip_${selectedMonth}_${facultyData['name'].replaceAll(' ', '_')}.pdf',
      );

      if (!mounted) return;
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salary slip for ${_getSelectedMonthDisplay()} generated successfully!'),
          backgroundColor: const Color(0xFF2E7D32), // AppColors.success
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getSelectedMonthDisplay() {
    if (selectedMonth == null) return '';
    return months.firstWhere((month) => month['value'] == selectedMonth)['display'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // AppColors.background
      appBar: const CustomAppBar(
        title: "View Salary Slip", 
        subtitle: "Select a month to download your salary slip"
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            
            // Main Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // AppColors.surface
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0D000000),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Faculty Info Preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1070).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facultyData['name'],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2A1070),
                          ),
                        ),
                        Text(
                          '${facultyData['designation']} - ${facultyData['department']}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Net Salary: ₹${_calculateNetSalary().toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Month Dropdown
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF5A4FCF)), // AppColors.accent
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMonth,
                        hint: Text(
                          'Select Month',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF5C5C5C), // AppColors.textSecondary
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF2A1070), // AppColors.primary
                        ),
                        items: months.map((month) {
                          return DropdownMenuItem<String>(
                            value: month['value'],
                            child: Text(
                              month['display']!,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: const Color(0xFF1C1C1E), // AppColors.textPrimary
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Download Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _downloadSalarySlip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A1070), // AppColors.primary
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: const Color(0xFF5C5C5C).withOpacity(0.3),
                      ),
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Generating PDF...',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Generate PDF Salary Slip',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white,
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
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
}