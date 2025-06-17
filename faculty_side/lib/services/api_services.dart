import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/faculty.dart' hide LeaveType;
import '../screens/apply_leave_screen.dart';
import '../models/leave_type.dart';
import '../models/alternate_models.dart';
// Import AlternatePerson if needed

class ApiServices {
  static const String baseUrl =
      'https://api.test.vppcoe.getflytechnologies.com/api/faculty/';
  static const String dashboardUrl =
      'https://api.test.vppcoe.getflytechnologies.com/';

  static const String uid = '195'; // Example UID, replace as needed

  /// 🔐 Static token for development (avoid in production)
  static const String staticToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjMyMDMsInVzZXJfdHlwZSI6MiwicHJpdmlsZWdlIjpudWxsLCJpYXQiOjE3NDk2MzA3MzcsImV4cCI6MTc4MTE2NjczN30.V4okpSzbqNTeFklZljZEiHDZMa2fTH_YKvQJ7uve3NM';

  static Map<String, String> _getHeaders({String? token}) {
    return {
      'Authorization': 'Bearer ${token ?? staticToken}',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  ///////
  static Future<List<LeaveType>> getLeaveTypes({required String token}) async {
    final response = await http.get(
      Uri.parse('${baseUrl}get_allowed_leaves?uid=$uid'),
      headers: _getHeaders(token: token),
    );
    print('this is the response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['leave_list'] ?? [];
      return data.map((item) => LeaveType.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load leave types: ${response.statusCode}');
    }
  }

  ///

  // APPLY LEAVE SECTION

  /// 3.1 Get Allowed Leaves for User
  static Future<AllowedLeavesResponse> getAllowedLeaves({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}get_allowed_leaves?uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return AllowedLeavesResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get allowed leaves: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting allowed leaves: $e');
    }
  }

  /// 3.2 Get Dashboard Leave Records
  static Future<DashboardResponse> getDashboardLeaveRecords({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}dashboard?uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to get dashboard records: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting dashboard records: $e');
    }
  }

  /// 3.3 Get Leave Count by Leave Type
  static Future<LeaveCountResponse> getLeaveCount({
    required String id,
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}getLeaveCount?id=$id&uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return LeaveCountResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get leave count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting leave count: $e');
    }
  }

  /// 3.4 Upload Supporting Document
  static Future<UploadResponse> uploadDocument({
    required File file,
    required String token,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}upload'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('application', 'octet-stream'),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return UploadResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to upload document: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading document: $e');
    }
  }

  /// 3.5 Apply for Leave
  static Future<ApplyLeaveResponse> applyLeave({
    required ApplyLeaveRequest request,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Apply_leave'),
        headers: _getHeaders(token: token),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return ApplyLeaveResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to apply leave: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error applying leave: $e');
    }
  }

  // LEAVE HISTORY SECTION

  /// 3.6 Get Leave History
  static Future<LeaveHistoryResponse> getLeaveHistory({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}leave_hisotry?uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return LeaveHistoryResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get leave history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting leave history: $e');
    }
  }

  /// 3.7 Cancel Leave
  static Future<CancelLeaveResponse> cancelLeave({
    required int id,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}cancel_leave'),
        headers: _getHeaders(token: token),
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        return CancelLeaveResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to cancel leave: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cancelling leave: $e');
    }
  }

  /// 3.9 Post Uploaded Document to Leave Record
  static Future<PostLeaveDocumentResponse> postLeaveDocument({
    required String uploadedFileName,
    required int leaveid,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}postLeaveDocument'),
        headers: _getHeaders(token: token),
        body: json.encode({
          'uploadedFileName': uploadedFileName,
          'leaveid': leaveid,
        }),
      );

      if (response.statusCode == 200) {
        return PostLeaveDocumentResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to post leave document: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error posting leave document: $e');
    }
  }

  /// 3.10 Get Faculty Cancelled Leave
  static Future<CancelledLeaveResponse> getFacultyCancelledLeave({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}faculty_cancelled_leave?uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return CancelledLeaveResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to get cancelled leaves: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting cancelled leaves: $e');
    }
  }

  // ALTERNATE LEAVE APPROVAL SECTION

  /// 4.2 Get Faculty Dashboard
  static Future<FacultyDashboardResponse> getFacultyDashboard({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${dashboardUrl}dashboard?uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return FacultyDashboardResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to get faculty dashboard: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting faculty dashboard: $e');
    }
  }

  /// 4.3 Get Faculty Privileges
  static Future<PrivilegeResponse> getFacultyPrivileges({
    required String uid,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${dashboardUrl}getPrevilege?uid=$uid'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return PrivilegeResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to get faculty privileges: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting faculty privileges: $e');
    }
  }

  /// 4.4 Get HR Pending Leave Approvals
  static Future<LeaveApprovalResponse> getHRPendingLeaveApprovals({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${dashboardUrl}leaveApproval'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return LeaveApprovalResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to get HR pending approvals: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting HR pending approvals: $e');
    }
  }

  /// 4.6 Update Leave Status (Approve/Deny)
  static Future<UpdateLeaveStatusResponse> updateLeaveStatus({
    required UpdateLeaveStatusRequest request,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${dashboardUrl}update_leave_status'),
        headers: _getHeaders(token: token),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return UpdateLeaveStatusResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to update leave status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating leave status: $e');
    }
  }

  /// 4.7 Approve All Leaves
  static Future<ApproveAllLeavesResponse> approveAllLeaves({
    required String role,
    required String uid,
    required List<String> approveSelected,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${dashboardUrl}update_Allleave_status'),
        headers: _getHeaders(token: token),
        body: json.encode({
          'role': role,
          'uid': uid,
          'aproveSelected': approveSelected,
        }),
      );

      if (response.statusCode == 200) {
        return ApproveAllLeavesResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to approve all leaves: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error approving all leaves: $e');
    }
  }

  /// 4.8 Deny Leave Application
  static Future<DenyLeaveResponse> denyLeaveApplication({
    required int appId,
    required int status,
    required String reason,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${dashboardUrl}denyClick'),
        headers: _getHeaders(token: token),
        body: json.encode({
          'app_id': appId,
          'status': status,
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        return DenyLeaveResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to deny leave application: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error denying leave application: $e');
    }
  }

  /// 4.9 Take Charge of Leave
  static Future<TakeChargeResponse> takeChargeOfLeave({
    required int appId,
    required int status,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${dashboardUrl}takeCharge'),
        headers: _getHeaders(token: token),
        body: json.encode({'app_id': appId, 'status': status}),
      );

      if (response.statusCode == 200) {
        return TakeChargeResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to take charge of leave: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error taking charge of leave: $e');
    }
  }

  // PUNCH RECORD SECTION

  /// 5.1 Get My Punch Report
  static Future<PunchReportResponse> getMyPunchReport({
    required String startDate,
    required String endDate,
    required String facultyClgId,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${dashboardUrl}report/myPunchReport'),
        headers: _getHeaders(token: token),
        body: json.encode({
          'startDate': startDate,
          'endDate': endDate,
          'faculty_clg_id': facultyClgId,
        }),
      );

      if (response.statusCode == 200) {
        return PunchReportResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get punch report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting punch report: $e');
    }
  }

  static Future<List<AlternatePerson>> getAlternates({required String token}) async {
    final response = await http.get(
      Uri.parse('${baseUrl}get_allowed_leaves?uid=$uid'),
      headers: _getHeaders(token: token),
    );
    print('response of alternates: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['facultylist'] ?? [];
      return data.map((item) => AlternatePerson.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load alternates: ${response.statusCode}');
    }
  }
}

class AlternatePerson {
  final int facultyId;
  final String name;

  AlternatePerson({required this.facultyId, required this.name});

  factory AlternatePerson.fromJson(Map<String, dynamic> json) {
    return AlternatePerson(facultyId: json['faculty_id'], name: json['name']);
  }
}

class AlternateDropdownWidget extends StatefulWidget {
  final String apiToken;
  final BuildContext context;
  const AlternateDropdownWidget({Key? key, required this.apiToken, required this.context}) : super(key: key);

  @override
  _AlternateDropdownWidgetState createState() => _AlternateDropdownWidgetState();
}

class _AlternateDropdownWidgetState extends State<AlternateDropdownWidget> {
  List<AlternatePerson> alternates = [];
  bool isLoadingAlternates = true;
  String? selectedAlternate;

  @override
  void initState() {
    super.initState();
    _fetchAlternates();
  }

  Future<void> _fetchAlternates() async {
    setState(() {
      isLoadingAlternates = true;
    });
    try {
      List<AlternatePerson> fetchedAlternates = await ApiServices.getAlternates(token: widget.apiToken);
      setState(() {
        alternates = fetchedAlternates;
        isLoadingAlternates = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAlternates = false;
      });
      ScaffoldMessenger.of(widget.context).showSnackBar(
        SnackBar(
          content: Text('Failed to load alternates: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAlternateDropdown() {
    if (isLoadingAlternates) {
      return const Center(child: CircularProgressIndicator());
    }
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Select Alternate Faculty',
        prefixIcon: Icon(Icons.person_outline),
      ),
      items: alternates.map((alt) {
        return DropdownMenuItem<int>(
          value: alt.facultyId,
          child: Text(alt.name),
        );
      }).toList(),
      value: selectedAlternate == null ? null : int.tryParse(selectedAlternate!),
      onChanged: (val) => setState(() => selectedAlternate = val?.toString()),
      validator: (val) => val == null ? 'Please select an alternate faculty' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAlternateDropdown();
  }
}
