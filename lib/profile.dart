// // profile.dart
// class Profile {
//   final int? id;
//   final String name;
//   final String email;
//   final String mobileNumber;
//   final int age;
//   final String location;
//   final String gender;
//   final String hobbies;
//   final String imageUrl;
//   final String dateOfBirth;
//   final String password;
//   final bool isFavorite;
//
//   Profile({
//     this.id,
//     required this.name,
//     required this.email,
//     required this.mobileNumber,
//     required this.age,
//     required this.location,
//     required this.gender,
//     required this.hobbies,
//     required this.imageUrl,
//     required this.dateOfBirth,
//     required this.password,
//     this.isFavorite = false,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'mobileNumber': mobileNumber,
//       'age': age,
//       'location': location,
//       'gender': gender,
//       'hobbies': hobbies,
//       'imageUrl': imageUrl,
//       'dateOfBirth': dateOfBirth,
//       'password': password,
//       'isFavorite': isFavorite ? 1 : 0,
//     };
//   }
//
//   static Profile fromMap(Map<String, dynamic> map) {
//     return Profile(
//       id: map['id'],
//       name: map['name'],
//       email: map['email'],
//       mobileNumber: map['mobileNumber'],
//       age: map['age'],
//       location: map['location'],
//       gender: map['gender'],
//       hobbies: map['hobbies'],
//       imageUrl: map['imageUrl'],
//       dateOfBirth: map['dateOfBirth'] ?? "", // Ensure it's always a String
//       password: map['password'],
//       isFavorite: (map['isFavorite'] ?? 0) == 1,
//     );
//   }
// }


class Profile {
  final String? id;
  final String name;
  final String email;
  final String mobileNumber;
  final int age;
  final String location;
  final String gender;
  final String hobbies;
  final String imageUrl;
  final String dateOfBirth;
  bool isFavorite;
  final String password;
  bool isOptap;

  Profile({
    this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.age,
    required this.location,
    required this.gender,
    required this.hobbies,
    required this.imageUrl,
    required this.dateOfBirth,
    this.isFavorite = false,
    required this.password,
    this.isOptap = true,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobileNumber'].toString(),
      age: json['age'],
      location: json['location'],
      gender: json['gender'],
      hobbies: json['hobbies'].toString(),
      imageUrl: json['imageUrl'].toString(),
      dateOfBirth: json['dateOfBirth'].toString(),
      isFavorite: json['isFavorite'] is int
          ? json['isFavorite'] == 1
          : json['isFavorite'] ?? false,
      password: json['password'].toString(),
      isOptap: json['isOptap'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'age': age,
      'location': location,
      'gender': gender,
      'hobbies': hobbies,
      'imageUrl': imageUrl,
      'dateOfBirth': dateOfBirth,
      'isFavorite': isFavorite,
      'password': password,
      'isOptap': isOptap,
    };
  }
}
