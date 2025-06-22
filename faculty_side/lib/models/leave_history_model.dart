class LeaveHistoryResponse {
  final int leaveAppId;
  final int facultyId;
  final int leaveId;
  final String? fromDate;
  final String? toDate;
  final String? reason;
  final String? noOfDays;
  final String? docLink;
  final int? status;
  final int? signedByHod;
  final int? signedByPrincipal;
  final int? alternate;
  final int? statusAlternate;
  final String? appliedDate;
  final String? halfFullDay;
  final String? hodApprovalDate;
  final String? alternateApprovalDate;
  final String? hrApprovalDate;
  final String? lname;
  final String? hodName;
  final String? altname;

  LeaveHistoryResponse({
    required this.leaveAppId,
    required this.facultyId,
    required this.leaveId,
    this.fromDate,
    this.toDate,
    this.reason,
    this.noOfDays,
    this.docLink,
    this.status,
    this.signedByHod,
    this.signedByPrincipal,
    this.alternate,
    this.statusAlternate,
    this.appliedDate,
    this.halfFullDay,
    this.hodApprovalDate,
    this.alternateApprovalDate,
    this.hrApprovalDate,
    this.lname,
    this.hodName,
    this.altname,
  });

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
      leaveAppId: json['leave_app_id'],
      facultyId: json['faculty_id'],
      leaveId: json['leave_id'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      reason: json['reason'],
      noOfDays: json['no_of_days'],
      docLink: json['doc_link'],
      status: json['status'],
      signedByHod: json['signed_by_hod'],
      signedByPrincipal: json['signed_by_principal'],
      alternate: json['alternate'],
      statusAlternate: json['status_alternate'],
      appliedDate: json['applied_date'],
      halfFullDay: json['half_full_day'],
      hodApprovalDate: json['hod_approval_date'],
      alternateApprovalDate: json['alternate_approval_date'],
      hrApprovalDate: json['hr_approval_date'],
      lname: json['lname'],
      hodName: json['hod_name'],
      altname: json['altname'],
    );
  }
}
