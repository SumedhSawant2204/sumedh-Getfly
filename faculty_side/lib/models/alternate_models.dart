import 'package:flutter/material.dart';

class AlternatePerson {
  final int facultyId;
  final String name;

  AlternatePerson({required this.facultyId, required this.name});

  factory AlternatePerson.fromJson(Map<String, dynamic> json) {
    return AlternatePerson(facultyId: json['faculty_id'], name: json['name']);
  }
}

class AlternatePersonDropdown extends StatefulWidget {
  final List<AlternatePerson> alternates;
  final String? selectedAlternate;
  final Function(String?) onChanged;

  const AlternatePersonDropdown({
    Key? key,
    required this.alternates,
    required this.selectedAlternate,
    required this.onChanged,
  }) : super(key: key);

  @override
  _AlternatePersonDropdownState createState() =>
      _AlternatePersonDropdownState();
}

class _AlternatePersonDropdownState extends State<AlternatePersonDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Select Alternate Faculty',
        prefixIcon: Icon(Icons.person_outline),
      ),
      items: widget.alternates.map((alt) {
        return DropdownMenuItem<int>(
          value: alt.facultyId,
          child: Text(alt.name),
        );
      }).toList(),
      value: widget.selectedAlternate == null
          ? null
          : int.tryParse(widget.selectedAlternate!),
      onChanged: (val) => widget.onChanged(val?.toString()),
      validator: (val) =>
          val == null ? 'Please select an alternate faculty' : null,
    );
  }
}
