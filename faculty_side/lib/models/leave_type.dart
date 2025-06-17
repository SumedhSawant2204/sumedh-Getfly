import 'package:flutter/material.dart';

class LeaveType {
  final int leaveId;
  final String lname;

  LeaveType({required this.leaveId, required this.lname});

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(leaveId: json['leave_id'], lname: json['lname']);
  }
}

class LeaveTypeDropdown extends StatefulWidget {
  @override
  _LeaveTypeDropdownState createState() => _LeaveTypeDropdownState();
}

class _LeaveTypeDropdownState extends State<LeaveTypeDropdown> {
  List<LeaveType> leaveTypes = [
    LeaveType(leaveId: 1, lname: 'Sick Leave'),
    LeaveType(leaveId: 2, lname: 'Casual Leave'),
    LeaveType(leaveId: 3, lname: 'Annual Leave'),
  ];

  String? selectedLeaveType;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      items: leaveTypes.map((type) {
        return DropdownMenuItem<int>(
          value: type.leaveId,
          child: Text(type.lname),
        );
      }).toList(),
      value: selectedLeaveType == null
          ? null
          : int.tryParse(selectedLeaveType!),
      onChanged: (val) => setState(() => selectedLeaveType = val?.toString()),
      validator: (val) => val == null ? 'Please select a leave type' : null,
    );
  }
}
