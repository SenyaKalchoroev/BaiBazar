class UserModel {
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  UserModel(
      {required this.firstName,
        required this.middleName,
        required this.lastName,
        required this.phone});
  factory UserModel.fromJson(Map j) => UserModel(
    firstName: j['first_name'] ?? '',
    middleName: j['middle_name'] ?? '',
    lastName: j['last_name'] ?? '',
    phone: j['phonenumber'] ?? '',
  );
}
