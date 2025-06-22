class CancelledLeaveResponse {
  final int flaId;
  final int facultyId;
  final String casualLeave;
  final String earnedLeave;
  final String specialLeave;
  final String summerVacation;
  final String winterVacation;
  final String compensationLeave;
  final String medicalLeave;
  final int usedEarnedLeaves;
  final String? remark;
  final String maternityLeave;
  final String name;

  CancelledLeaveResponse({
    required this.flaId,
    required this.facultyId,
    required this.casualLeave,
    required this.earnedLeave,
    required this.specialLeave,
    required this.summerVacation,
    required this.winterVacation,
    required this.compensationLeave,
    required this.medicalLeave,
    required this.usedEarnedLeaves,
    required this.remark,
    required this.maternityLeave,
    required this.name,
  });

  factory CancelledLeaveResponse.fromJson(Map<String, dynamic> json) {
    return CancelledLeaveResponse(
      flaId: json['fla_id'],
      facultyId: json['faculty_id'],
      casualLeave: json['Casual Leave'] ?? "0",
      earnedLeave: json['Earned Leave'] ?? "0",
      specialLeave: json['Special Leave'] ?? "0",
      summerVacation: json['Summer Vacation'] ?? "0",
      winterVacation: json['Winter Vacation'] ?? "0",
      compensationLeave: json['Compensation Leave'] ?? "0",
      medicalLeave: json['Medical Leave'] ?? "0",
      usedEarnedLeaves: json['used_earned_leaves'] ?? 0,
      remark: json['remark'],
      maternityLeave: json['Maternity Leave'] ?? "0",
      name: json['name'] ?? "",
    );
  }
}