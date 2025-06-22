class LeaveCountResponse {
  final String casualLeave;
  final String earnedLeave;
  final String medicalLeave;
  final String summerVacation;
  final String winterVacation;
  final String compensationLeave;

  LeaveCountResponse({
    required this.casualLeave,
    required this.earnedLeave,
    required this.medicalLeave,
    required this.summerVacation,
    required this.winterVacation,
    required this.compensationLeave,
  });

  factory LeaveCountResponse.fromJson(Map<String, dynamic> json) {
    return LeaveCountResponse(
      casualLeave: json['Casual Leave'] ?? '0.00',
      earnedLeave: json['Earned Leave'] ?? '0.00',
      medicalLeave: json['Medical Leave'] ?? '0.00',
      summerVacation: json['Summer Vacation'] ?? '0.00',
      winterVacation: json['Winter Vacation'] ?? '0.00',
      compensationLeave: json['Compensation Leave'] ?? '0.00',
    );
  }
}