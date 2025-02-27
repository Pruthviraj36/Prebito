// profile.dart
class Profile {
  final int? id;
  final String name;
  final String email;
  final String mobileNumber;
  final int age;
  final String location;
  final String gender;
  final String hobbies;
  final String imagePath;
  final String dateOfBirth;
  final String password;
  final bool isFavorite;

  Profile({
    this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.age,
    required this.location,
    required this.gender,
    required this.hobbies,
    required this.imagePath,
    required this.dateOfBirth,
    required this.password,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'age': age,
      'location': location,
      'gender': gender,
      'hobbies': hobbies,
      'imagePath': imagePath,
      'dateOfBirth': dateOfBirth,
      'password': password,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      age: map['age'],
      location: map['location'],
      gender: map['gender'],
      hobbies: map['hobbies'],
      imagePath: map['imagePath'],
      dateOfBirth: map['dateOfBirth'] ?? "", // Ensure it's always a String
      password: map['password'],
      isFavorite: (map['isFavorite'] ?? 0) == 1,
    );
  }
}