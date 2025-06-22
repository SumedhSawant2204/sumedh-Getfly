

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