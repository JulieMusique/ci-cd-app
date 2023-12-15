class User {
  int? id;
  String lastName;
  String firstName;
  String email;
  String? phone;
  String? address;
  String? login;
  String password;
  double soldeCarteCrous;

  User({
    this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
    this.phone,
    this.address,
    this.login,
    required this.password,
    required this.soldeCarteCrous
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      phone: json['phone'],
      address: json['adresse'],
      login: json['login'],
      password: json['password'],
      soldeCarteCrous: json['soldeCarteCrous'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'adresse': address,
      'login': login,
      'password': password,
      'soldeCarteCrous': soldeCarteCrous,
    };
  }
}
