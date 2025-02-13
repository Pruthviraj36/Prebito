class User {
  String id;
  String fullName;
  String email;
  String mobileNumber;
  String dateOfBirth;
  String city;
  String gender;
  List<String> hobbies;
  String password;
  bool isFavorite;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.city,
    required this.gender,
    required this.hobbies,
    required this.password,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'city': city,
      'gender': gender,
      'hobbies': hobbies.join(','),
      'password': password,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      dateOfBirth: map['dateOfBirth'],
      city: map['city'],
      gender: map['gender'],
      hobbies: map['hobbies'] != null ? map['hobbies'].split(',') : [],
      password: map['password'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? mobileNumber,
    String? dateOfBirth,
    String? city,
    String? gender,
    List<String>? hobbies,
    String? password,
    bool? isFavorite,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      hobbies: hobbies ?? this.hobbies,
      password: password ?? this.password,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}