class StudentProfileModel {
  final String name;
  final String dob;
  final String address;
  final String department;
  final String rollNo;
  final String program;
  final String email;

  StudentProfileModel({
    required this.name,
    required this.dob,
    required this.address,
    required this.department,
    required this.rollNo,
    required this.program,
    required this.email,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
      department: json['Department']['name'] ?? '',
      rollNo: json['Student'][0]['rollNo'] ?? '',
      email: json['email'] ?? '',
      program:
          "${json['Student'][0]['Program']['level']} at ${json['Student'][0]['Program']['name']}",
    );
  }
}
