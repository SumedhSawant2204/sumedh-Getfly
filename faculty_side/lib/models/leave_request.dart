// models/leave_request.dart
class LeaveRequest {
  final String facultyName;
  final double numberOfDays;
  final String leaveType;
  final String leaveReason;
  final String from;
  final String to;
  final String appliedDate;

  LeaveRequest({
    required this.facultyName,
    required this.numberOfDays,
    required this.leaveType,
    required this.leaveReason,
    required this.from,
    required this.to,
    required this.appliedDate,
  });
}

// leave record

class LeaveRecord {
  final int srNo;
  final DateTime fromDate;
  final DateTime toDate;
  final int numberOfDays;
  final String leaveType;
  final String reason;
  final String? uploadDocument;
  final String alternateApprovalStatus;
  final String approvedByHOD;
  final String approvalStatus;
  final bool canCancel;

  LeaveRecord({
    required this.srNo,
    required this.fromDate,
    required this.toDate,
    required this.numberOfDays,
    required this.leaveType,
    required this.reason,
    this.uploadDocument,
    required this.alternateApprovalStatus,
    required this.approvedByHOD,
    required this.approvalStatus,
    required this.canCancel,
  });
}