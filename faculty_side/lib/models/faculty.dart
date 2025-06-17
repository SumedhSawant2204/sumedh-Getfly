// faculty.dart - Model classes for Faculty API


class AllowedLeavesResponse {
  final bool success;
  final String message;
  final List<AllowedLeave> data;

  AllowedLeavesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AllowedLeavesResponse.fromJson(Map<String, dynamic> json) {
    return AllowedLeavesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => AllowedLeave.fromJson(item))
          .toList() ?? [],
    );
  }
}

class AllowedLeave {
  final String id;
  final String leaveName;
  final int allowedDays;
  final String description;

  AllowedLeave({
    required this.id,
    required this.leaveName,
    required this.allowedDays,
    required this.description,
  });

  factory AllowedLeave.fromJson(Map<String, dynamic> json) {
    return AllowedLeave(
      id: json['id']?.toString() ?? '',
      leaveName: json['leave_name'] ?? '',
      allowedDays: json['allowed_days'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}

class DashboardResponse {
  final List<LeaveType> leaveList;
  final int used;
  final List<AlternateLeave> alternate;

  DashboardResponse({
    required this.leaveList,
    required this.used,
    required this.alternate,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      leaveList: (json['leave_list'] as List)
          .map((e) => LeaveType.fromJson(e))
          .toList(),
      used: json['used'] ?? 0,
      alternate: (json['alternate'] as List)
          .map((e) => AlternateLeave.fromJson(e))
          .toList(),
    );
  }
}

class LeaveType {
  final int leaveId;
  final String lname;

  LeaveType({required this.leaveId, required this.lname});

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      leaveId: json['leave_id'],
      lname: json['lname'],
    );
    
  }
}

class AlternateLeave {
  final int leaveAppId;
  final String name;
  final String lname;
  final int noOfDays;
  final String reason;
  final String fromDate;
  final String toDate;
  final String appliedDate;

  AlternateLeave({
    required this.leaveAppId,
    required this.name,
    required this.lname,
    required this.noOfDays,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.appliedDate,
  });

  factory AlternateLeave.fromJson(Map<String, dynamic> json) {
    return AlternateLeave(
      leaveAppId: json['leave_app_id'],
      name: json['name'],
      lname: json['lname'],
      noOfDays: json['no_of_days'],
      reason: json['reason'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      appliedDate: json['applied_date'],
    );
  }
}


class LeaveRecord {
  final int id;
  final String leaveId;
  final String fromDate;
  final String toDate;
  final String appliedDate;
  final String reason;
  final double noOfDays;
  final String alternate;
  final String uid;
  final String? doc;
  final String halfFullDay;
  final String status;
  final String leaveName;

  LeaveRecord({
    required this.id,
    required this.leaveId,
    required this.fromDate,
    required this.toDate,
    required this.appliedDate,
    required this.reason,
    required this.noOfDays,
    required this.alternate,
    required this.uid,
    this.doc,
    required this.halfFullDay,
    required this.status,
    required this.leaveName,
  });

  factory LeaveRecord.fromJson(Map<String, dynamic> json) {
    return LeaveRecord(
      id: json['id'] ?? 0,
      leaveId: json['leave_id']?.toString() ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      appliedDate: json['applied_date'] ?? '',
      reason: json['reason'] ?? '',
      noOfDays: (json['no_of_date'] ?? 0).toDouble(),
      alternate: json['alternate'] ?? '',
      uid: json['uid'] ?? '',
      doc: json['doc'],
      halfFullDay: json['half_full_day'] ?? '',
      status: json['status'] ?? '',
      leaveName: json['leave_name'] ?? '',
    );
  }
}

class LeaveCountResponse {
  final bool success;
  final String message;
  final LeaveCountData data;

  LeaveCountResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaveCountResponse.fromJson(Map<String, dynamic> json) {
    return LeaveCountResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LeaveCountData.fromJson(json['data'] ?? {}),
    );
  }
}

class LeaveCountData {
  final int availableLeaves;
  final int usedLeaves;
  final int totalLeaves;

  LeaveCountData({
    required this.availableLeaves,
    required this.usedLeaves,
    required this.totalLeaves,
  });

  factory LeaveCountData.fromJson(Map<String, dynamic> json) {
    return LeaveCountData(
      availableLeaves: json['available_leaves'] ?? 0,
      usedLeaves: json['used_leaves'] ?? 0,
      totalLeaves: json['total_leaves'] ?? 0,
    );
  }
}

class UploadResponse {
  final bool success;
  final String message;
  final String? fileName;
  final String? filePath;

  UploadResponse({
    required this.success,
    required this.message,
    this.fileName,
    this.filePath,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      fileName: json['file_name'],
      filePath: json['file_path'],
    );
  }
}

class ApplyLeaveRequest {
  final String leaveId;
  final String fromDate;
  final String toDate;
  final String appliedDate;
  final String reason;
  final double noOfDate;
  final String alternate;
  final String uid;
  final String doc;
  final String halfFullDay;

  ApplyLeaveRequest({
    required this.leaveId,
    required this.fromDate,
    required this.toDate,
    required this.appliedDate,
    required this.reason,
    required this.noOfDate,
    required this.alternate,
    required this.uid,
    required this.doc,
    required this.halfFullDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'leave_id': leaveId,
      'from_date': fromDate,
      'to_date': toDate,
      'applied_date': appliedDate,
      'reason': reason,
      'no_of_date': noOfDate,
      'alternate': alternate,
      'uid': uid,
      'doc': doc,
      'half_full_day': halfFullDay,
    };
  }
}

class ApplyLeaveResponse {
  final bool success;
  final String message;
  final int? leaveId;

  ApplyLeaveResponse({
    required this.success,
    required this.message,
    this.leaveId,
  });

  factory ApplyLeaveResponse.fromJson(Map<String, dynamic> json) {
    return ApplyLeaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      leaveId: json['leave_id'],
    );
  }
}

class LeaveHistoryResponse {
  final bool success;
  final String message;
  final List<LeaveRecord> data;

  LeaveHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => LeaveRecord.fromJson(item))
          .toList() ?? [],
    );
  }
}

class CancelLeaveResponse {
  final bool success;
  final String message;

  CancelLeaveResponse({
    required this.success,
    required this.message,
  });

  factory CancelLeaveResponse.fromJson(Map<String, dynamic> json) {
    return CancelLeaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class PostLeaveDocumentResponse {
  final bool success;
  final String message;

  PostLeaveDocumentResponse({
    required this.success,
    required this.message,
  });

  factory PostLeaveDocumentResponse.fromJson(Map<String, dynamic> json) {
    return PostLeaveDocumentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class CancelledLeaveResponse {
  final bool success;
  final String message;
  final List<LeaveRecord> data;

  CancelledLeaveResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CancelledLeaveResponse.fromJson(Map<String, dynamic> json) {
    return CancelledLeaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => LeaveRecord.fromJson(item))
          .toList() ?? [],
    );
  }
}

class FacultyDashboardResponse {
  final bool success;
  final String message;
  final FacultyDashboardData data;

  FacultyDashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FacultyDashboardResponse.fromJson(Map<String, dynamic> json) {
    return FacultyDashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: FacultyDashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class FacultyDashboardData {
  final List<AlternateLeaveRequest> alternateRequests;
  final List<LeaveRecord> myLeaves;
  final FacultyStats stats;

  FacultyDashboardData({
    required this.alternateRequests,
    required this.myLeaves,
    required this.stats,
  });

  factory FacultyDashboardData.fromJson(Map<String, dynamic> json) {
    return FacultyDashboardData(
      alternateRequests: (json['alternate_requests'] as List<dynamic>?)
          ?.map((item) => AlternateLeaveRequest.fromJson(item))
          .toList() ?? [],
      myLeaves: (json['my_leaves'] as List<dynamic>?)
          ?.map((item) => LeaveRecord.fromJson(item))
          .toList() ?? [],
      stats: FacultyStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class AlternateLeaveRequest {
  final int id;
  final String facultyName;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String reason;
  final String status;
  final double noOfDays;

  AlternateLeaveRequest({
    required this.id,
    required this.facultyName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    required this.noOfDays,
  });

  factory AlternateLeaveRequest.fromJson(Map<String, dynamic> json) {
    return AlternateLeaveRequest(
      id: json['id'] ?? 0,
      facultyName: json['faculty_name'] ?? '',
      leaveType: json['leave_type'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      noOfDays: (json['no_of_days'] ?? 0).toDouble(),
    );
  }
}

class FacultyStats {
  final int totalLeaves;
  final int pendingApprovals;
  final int approvedLeaves;
  final int rejectedLeaves;

  FacultyStats({
    required this.totalLeaves,
    required this.pendingApprovals,
    required this.approvedLeaves,
    required this.rejectedLeaves,
  });

  factory FacultyStats.fromJson(Map<String, dynamic> json) {
    return FacultyStats(
      totalLeaves: json['total_leaves'] ?? 0,
      pendingApprovals: json['pending_approvals'] ?? 0,
      approvedLeaves: json['approved_leaves'] ?? 0,
      rejectedLeaves: json['rejected_leaves'] ?? 0,
    );
  }
}

class PrivilegeResponse {
  final bool success;
  final String message;
  final List<Privilege> data;

  PrivilegeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PrivilegeResponse.fromJson(Map<String, dynamic> json) {
    return PrivilegeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Privilege.fromJson(item))
          .toList() ?? [],
    );
  }
}

class Privilege {
  final String role;
  final String permission;
  final bool canApprove;
  final bool canReject;
  final bool canView;

  Privilege({
    required this.role,
    required this.permission,
    required this.canApprove,
    required this.canReject,
    required this.canView,
  });

  factory Privilege.fromJson(Map<String, dynamic> json) {
    return Privilege(
      role: json['role'] ?? '',
      permission: json['permission'] ?? '',
      canApprove: json['can_approve'] ?? false,
      canReject: json['can_reject'] ?? false,
      canView: json['can_view'] ?? false,
    );
  }
}

class LeaveApprovalResponse {
  final bool success;
  final String message;
  final List<PendingLeaveApproval> data;

  LeaveApprovalResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaveApprovalResponse.fromJson(Map<String, dynamic> json) {
    return LeaveApprovalResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => PendingLeaveApproval.fromJson(item))
          .toList() ?? [],
    );
  }
}

class PendingLeaveApproval {
  final int appId;
  final String facultyName;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String reason;
  final double noOfDays;
  final String appliedDate;
  final String alternate;
  final String? document;
  final String halfFullDay;

  PendingLeaveApproval({
    required this.appId,
    required this.facultyName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.noOfDays,
    required this.appliedDate,
    required this.alternate,
    this.document,
    required this.halfFullDay,
  });

  factory PendingLeaveApproval.fromJson(Map<String, dynamic> json) {
    return PendingLeaveApproval(
      appId: json['app_id'] ?? 0,
      facultyName: json['faculty_name'] ?? '',
      leaveType: json['leave_type'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      reason: json['reason'] ?? '',
      noOfDays: (json['no_of_days'] ?? 0).toDouble(),
      appliedDate: json['applied_date'] ?? '',
      alternate: json['alternate'] ?? '',
      document: json['document'],
      halfFullDay: json['half_full_day'] ?? '',
    );
  }
}

class UpdateLeaveStatusRequest {
  final String appId;
  final int status;
  final int noOfDays;
  final String facultyId;
  final String leaveId;
  final String role;
  final String uid;

  UpdateLeaveStatusRequest({
    required this.appId,
    required this.status,
    required this.noOfDays,
    required this.facultyId,
    required this.leaveId,
    required this.role,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'status': status,
      'no_of_days': noOfDays,
      'faculty_id': facultyId,
      'leave_id': leaveId,
      'role': role,
      'uid': uid,
    };
  }
}

class UpdateLeaveStatusResponse {
  final bool success;
  final String message;

  UpdateLeaveStatusResponse({
    required this.success,
    required this.message,
  });

  factory UpdateLeaveStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateLeaveStatusResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class ApproveAllLeavesResponse {
  final bool success;
  final String message;
  final int approvedCount;

  ApproveAllLeavesResponse({
    required this.success,
    required this.message,
    required this.approvedCount,
  });

  factory ApproveAllLeavesResponse.fromJson(Map<String, dynamic> json) {
    return ApproveAllLeavesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      approvedCount: json['approved_count'] ?? 0,
    );
  }
}

class DenyLeaveResponse {
  final bool success;
  final String message;

  DenyLeaveResponse({
    required this.success,
    required this.message,
  });

  factory DenyLeaveResponse.fromJson(Map<String, dynamic> json) {
    return DenyLeaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class TakeChargeResponse {
  final bool success;
  final String message;

  TakeChargeResponse({
    required this.success,
    required this.message,
  });

  factory TakeChargeResponse.fromJson(Map<String, dynamic> json) {
    return TakeChargeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class PunchReportResponse {
  final bool success;
  final String message;
  final List<PunchRecord> data;

  PunchReportResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PunchReportResponse.fromJson(Map<String, dynamic> json) {
    return PunchReportResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => PunchRecord.fromJson(item))
          .toList() ?? [],
    );
  }
}

class PunchRecord {
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String? totalHours;
  final String status;
  final String? remarks;

  PunchRecord({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.totalHours,
    required this.status,
    this.remarks,
  });

  factory PunchRecord.fromJson(Map<String, dynamic> json) {
    return PunchRecord(
      date: json['date'] ?? '',
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      totalHours: json['total_hours'],
      status: json['status'] ?? '',
      remarks: json['remarks'],
    );
  }
}