class Employee {
  int? id;
  String? name;
  String? role;
  String? fromDate;
  String? toDate;
  String? status;

  Employee(
      {this.id, this.name, this.role, this.fromDate, this.toDate, this.status});

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
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['status'] = this.status;
    return data;
  }
}
