class Employee {
  late int? id;
  late String name;
  late String role;
  late String fromDate;
  late String? toDate;
  late String status;

  Employee(
      {this.id,
      required this.name,
      required this.role,
      required this.fromDate,
      this.toDate,
      required this.status});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['role'] = role;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['status'] = status;
    return data;
  }
}
