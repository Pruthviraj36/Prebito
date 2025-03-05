import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_app/widget_tree.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mat_app/profile.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'authentication.dart';
import 'login_screen.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileManager()),
      ],
      child: const SafeArea(
        child: MatrimonyApp(),
      ),
    ),
  );
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.indigo,
      colorScheme: const ColorScheme.light(
        primary: Colors.indigo,
        secondary: Colors.teal,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: TextStyle(color: Colors.grey.shade800),
        displayLarge: const TextStyle(color: Colors.indigo),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // color: Colors.white,
        ),
      ));

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    colorScheme: const ColorScheme.dark(
      primary: Colors.indigo,
      secondary: Colors.teal,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge: TextStyle(color: Colors.grey.shade300),
      displayLarge: TextStyle(color: Colors.indigo.shade200),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade800,
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MatrimonyApp extends StatelessWidget {
  const MatrimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Forever Matrimony',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const WidgetTree(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;

  const HomePage({super.key, required this.onSignOut});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  File? _profileImage;
  int _selectedIndex = 0; // Index for bottom navigation bar

  // List of pages to display in the bottom navigation bar
  final List<Widget> _pages = [
    SwipeCardScreen(), // Swipeable card screen for browsing profiles
    const AddProfilePage(),
    const FavoritesPage(),
    const AboutPage(),
  ];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Soul Bridge',
              textStyle: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 20,
                child: _profileImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _profileImage!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : user?.email != null
                        ? Text(
                            user!.email![0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.pinkAccent),
                          )
                        : const Icon(Icons.person, color: Colors.pinkAccent),
              ),
              onSelected: (String value) {
                if (value == 'logout') {
                  setState(() {
                    widget.onSignOut();
                  });
                } else if (value == 'dark_mode') {
                  setState(() {
                    themeProvider.toggleTheme(!themeProvider.isDarkMode);
                  });
                } else if (value == 'upload_photo') {
                  _pickImage();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'dark_mode',
                    child: Text('Toggle Dark Mode'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'upload_photo',
                    child: Text('Upload Profile Photo'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class SwipeCardScreen extends StatefulWidget {
  const SwipeCardScreen({super.key});

  @override
  SwipeCardScreenState createState() => SwipeCardScreenState();
}

class SwipeCardScreenState extends State<SwipeCardScreen> {
  int currentIndex = 0;
  late ProfileManager _profileManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileManager = Provider.of<ProfileManager>(context);
  }

  void _swipeCard(bool like) {
    setState(() {
      if (currentIndex < _profileManager.profiles.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profiles = _profileManager.profiles;

    if (profiles.isEmpty) {
      return const Center(child: Text('No profiles available'));
    }

    final profile = profiles[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: profile.imageUrl.isNotEmpty
                ? Image.network(
                    profile.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child:
                        const Icon(Icons.person, size: 150, color: Colors.grey),
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Dismissible(
            key: ValueKey(profile),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              _swipeCard(
                  direction == DismissDirection.endToStart ? false : true);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profile.imageUrl.isNotEmpty
                        ? Image.network(profile.imageUrl,
                            fit: BoxFit.cover,
                            height: 350,
                            width: double.infinity)
                        : Container(
                            height: 350,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person,
                                size: 150, color: Colors.grey),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            '${profile.name}, ${profile.age}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            profile.location,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () => _swipeCard(false),
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.close, color: Colors.red, size: 30),
                ),
                const SizedBox(width: 30),
                FloatingActionButton(
                  onPressed: () {
                    _profileManager.toggleFavorite(profile);
                    _swipeCard(true);
                  },
                  backgroundColor: Colors.black,
                  child:
                      const Icon(Icons.favorite, color: Colors.pink, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  AddProfilePageState createState() => AddProfilePageState();
}

class AddProfilePageState extends State<AddProfilePage> with ProfileValidationMixin {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String imageUrl = '';
  String fullName = '';
  String email = '';
  String mobileNumber = '';
  DateTime? dateOfBirth;
  String city = '';
  String gender = '';
  List<String> hobbies = [];
  String password = '';
  String confirmPassword = '';

  // After
  List<String> cities = ["Wankaner", "Morbi", "Ahmedabad", "Rajkot", "Kutch"];
  List<String> hobbyOptions = ["Reading", "Traveling", "Cooking", "Sports"];

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     File profileImage = File(pickedFile.path);
  //
  //     try {
  //       String uploadedUrl = await _uploadImage(profileImage); // ✅ Pass the File
  //       setState(() {
  //         imageUrl = uploadedUrl; // Store the uploaded image URL
  //       });
  //     } catch (e) {
  //       print('Image upload failed: $e');
  //     }
  //   }
  // }

  Future<String> _uploadImage(File profileImage) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://67c589e1351c081993fa6ae6.mockapi.io/users'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('image', profileImage.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return jsonDecode(
          responseBody)['imageUrl']; // ✅ Return the uploaded image URL
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;
      });
    }
  }

  @override
  bool isValidAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return false;
    final age = calculateAge(dateOfBirth);
    return age >= 18 && age < 80;
  }

  @override
  int calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  // Future<void> _uploadImage() async {
  //   if (_profileImage == null) return;
  //
  //   final response = await http.post(
  //       Uri.parse('https://67c589e1351c081993fa6ae6.mockapi.io/users'),
  //       body: {'imageUrl': _profileImage});
  // }

  Future<void> addUser() async {
    if (_formKey.currentState!.validate()) {
      if (dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid Date of Birth')),
        );
        return;
      }
      if (gender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
      if (!isValidAge(dateOfBirth)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Age must be between 18 and 80. Current age: ${calculateAge(dateOfBirth!)}',
            ),
          ),
        );
        return;
      }

      // Ensure _profileImage is not null before calling _uploadImage
      if (_profileImage == null && imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a profile image')));
        return;
      }

      try {
        // Pass _profileImage to _uploadImage
        String uploadedUrl = await _uploadImage(_profileImage!);
        setState(() {
          imageUrl = uploadedUrl; // Store the uploaded image URL
        });

        final newProfile = Profile(
          name: fullName,
          email: email,
          mobileNumber: mobileNumber,
          age: calculateAge(dateOfBirth!),
          location: city,
          gender: gender,
          hobbies: hobbies.join(', '),
          password: password,
          imageUrl: imageUrl,
          dateOfBirth:
              dateOfBirth != null ? dateOfBirth!.toIso8601String() : '',
        );

        Provider.of<ProfileManager>(context, listen: false)
            .addProfile(newProfile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Added Successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Open a dialog or text field to input the URL
                      _showUrlInputDialog();
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl) // Use NetworkImage for URL
                          : null,
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Profile Photo URL'),
                  onChanged: (value) => setState(() => imageUrl = value.trim()),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  inputFormatters: [AlphabeticInputFormatter()],
                  // Add this line
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full Name is required';
                    }
                    if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                      return 'Only alphabetic characters and spaces are allowed';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {
                    fullName = value.trim();
                  }),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (value.contains(RegExp(r'[A-Z]'))) {
                      return 'No uppercase letters are allowed';
                    }
                    if (value.contains(RegExp(r'[!#$%^&*(),?":{}|<>]'))) {
                      return "No special characters except '@', '.', '_', and '-' are allowed";
                    }
                    final allowedDomains = [
                      'gmail.com',
                      'hotmail.com',
                      'yahoo.com',
                      'outlook.com'
                    ];
                    if (!allowedDomains
                        .any((domain) => value.endsWith('@$domain'))) {
                      return 'Email must end with "@gmail.com", "@hotmail.com", "@outlook.com", or "@yahoo.com"';
                    }
                    final emailRegex =
                        RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {
                    email = value.trim().toLowerCase();
                  }),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  // Add this line
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile Number is required';
                    }
                    if (RegExp(r'[^0-9]').hasMatch(value)) {
                      return 'Only numbers are allowed';
                    }
                    if (value.length != 10) {
                      return 'Mobile Number must be 10 digits';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {
                    mobileNumber = value.trim();
                  }),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'City'),
                  items: cities
                      .map((city) =>
                          DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                  onChanged: (value) => setState(() => city = value!),
                  validator: (value) => value == null || value.isEmpty
                      ? 'City is required'
                      : null,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Date of Birth:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    dateOfBirth == null
                        ? 'Select Date of Birth'
                        : DateFormat('dd/MM/yyyy').format(dateOfBirth!),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                if (dateOfBirth != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Age: ${calculateAge(dateOfBirth!)} years',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Gender:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (value) =>
                            setState(() => gender = value as String),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (value) =>
                            setState(() => gender = value as String),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Hobbies:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Wrap(
                  spacing: 10,
                  children: hobbyOptions.map((hobby) {
                    return ChoiceChip(
                      label: Text(hobby),
                      selected: hobbies.contains(hobby),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            hobbies.add(hobby);
                          } else {
                            hobbies.remove(hobby);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain at least one digit (0-9)';
                    }
                    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      return 'Password must contain at least one special character';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => password = value),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) =>
                      value != password ? 'Passwords do not match' : null,
                  onChanged: (value) => setState(() => confirmPassword = value),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: addUser,
                    child: const Text('Add Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUrlInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Image URL'),
          content: TextField(
            onChanged: (value) => setState(() => imageUrl = value.trim()),
            decoration: const InputDecoration(
                hintText: 'https://example.com/image.jpg'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  const EditProfilePage({required this.profile, super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> with ProfileValidationMixin {
  final _formKey = GlobalKey<FormState>();

  late String fullName;
  late String email;
  late String mobileNumber;
  DateTime? dateOfBirth;
  late String city;
  late String gender;
  List<String> hobbies = [];
  String password = '';
  String confirmPassword = '';

  List<String> cities = ["Wankaner", "Morbi", "Ahmedabad", "Rajkot", "Kutch"];
  List<String> hobbyOptions = ["Reading", "Traveling", "Cooking", "Sports"];

  @override
  void initState() {
    super.initState();
    fullName = widget.profile.name;
    email = widget.profile.email;
    password = widget.profile.password;
    confirmPassword = widget.profile.password;
    mobileNumber = widget.profile.mobileNumber;
    dateOfBirth = widget.profile.dateOfBirth.isNotEmpty
        ? DateTime.parse(widget.profile.dateOfBirth)
        : null;
    city = widget.profile.location;
    gender = widget.profile.gender;
    hobbies = widget.profile.hobbies.split(', '); // Convert string to list
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          dateOfBirth ?? DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;
      });
    }
  }

  void updateUser() {
    if (_formKey.currentState!.validate()) {
      if (dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid Date of Birth')),
        );
        return;
      }
      if (gender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
      if (!isValidAge(dateOfBirth)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Age must be between 18 and 80. Current age: ${calculateAge(dateOfBirth!)}',
            ),
          ),
        );
        return;
      }

      final updatedProfile = Profile(
        name: fullName,
        email: email,
        mobileNumber: mobileNumber,
        age: calculateAge(dateOfBirth!),
        location: city,
        gender: gender,
        hobbies: hobbies.join(', '),
        // Convert list to string
        imageUrl: widget.profile.imageUrl,
        dateOfBirth: dateOfBirth != null ? dateOfBirth!.toIso8601String() : '',
        password: password.isNotEmpty ? password : widget.profile.password,
      );

      Provider.of<ProfileManager>(context, listen: false)
          .updateProfile(widget.profile, updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated Successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: fullName,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Full Name is required'
                      : RegExp(r'[^a-zA-Z\s]').hasMatch(value)
                          ? 'Only alphabetic characters and spaces are allowed'
                          : null,
                  onChanged: (value) => setState(() => fullName = value.trim()),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    return emailRegex.hasMatch(value)
                        ? null
                        : 'Enter valid email';
                  },
                  onChanged: (value) =>
                      setState(() => email = value.trim().toLowerCase()),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: mobileNumber,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile Number is required';
                    }
                    if (RegExp(r'[^0-9]').hasMatch(value)) {
                      return 'Only numbers are allowed';
                    }
                    if (value.length != 10) {
                      return 'Mobile Number must be 10 digits';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      setState(() => mobileNumber = value.trim()),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: city,
                  decoration: const InputDecoration(labelText: 'City'),
                  items: cities
                      .map((city) =>
                          DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'City is required'
                      : null,
                  onChanged: (value) => setState(() => city = value!),
                ),
                const SizedBox(height: 15),
                const Text('Date of Birth:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    dateOfBirth == null
                        ? 'Select Date of Birth'
                        : DateFormat('dd/MM/yyyy').format(dateOfBirth!),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                if (dateOfBirth != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Age: ${calculateAge(dateOfBirth!)} years',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700)),
                  ),
                const SizedBox(height: 20),
                const Text('Gender:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Hobbies:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Wrap(
                  spacing: 10,
                  children: hobbyOptions.map((hobby) {
                    return ChoiceChip(
                      label: Text(hobby),
                      selected: hobbies.contains(hobby),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            hobbies.add(hobby);
                          } else {
                            hobbies.remove(hobby);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : null,
                  onChanged: (value) => setState(() => password = value),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) =>
                      value != password ? 'Passwords do not match' : null,
                  onChanged: (value) => setState(() => confirmPassword = value),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: updateUser,
                    child: const Text('Update Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrowseProfilesPage extends StatefulWidget {
  const BrowseProfilesPage({super.key});

  @override
  BrowseProfilesPageState createState() => BrowseProfilesPageState();
}

class BrowseProfilesPageState extends State<BrowseProfilesPage> {
  String _searchQuery = '';
  String _sortBy = 'name';
  final TextEditingController _searchController = TextEditingController();

  List<Profile> _filterAndSortProfiles(List<Profile> profiles) {
    List<Profile> filtered = profiles.where((profile) {
      return profile.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          profile.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'age':
        filtered.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 'location':
        filtered.sort((a, b) => a.location.compareTo(b.location));
        break;
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Profiles')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name or location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _sortBy,
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                DropdownMenuItem(value: 'age', child: Text('Sort by Age')),
                DropdownMenuItem(
                    value: 'location', child: Text('Sort by Location')),
              ],
              onChanged: (value) => setState(() => _sortBy = value!),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final profileManager = Provider.of<ProfileManager>(context);
                final filteredProfiles =
                    _filterAndSortProfiles(profileManager.profiles);
                print(
                    "Filtered Profiles: ${filteredProfiles.length}"); // Log filtered profiles

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = filteredProfiles[index];
                    return ProfileCard(
                      profile: profile,
                      isFavorite: profileManager.isFavorite(profile),
                      onFavoriteToggle: () {
                        profileManager.toggleFavorite(profile);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileManager = Provider.of<ProfileManager>(context);
    final favorites = profileManager.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet!'))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final profile = favorites[index];
                return ProfileCard(
                  profile: profile,
                  isFavorite: profileManager.isFavorite(profile),
                  onFavoriteToggle: () {
                    profileManager.toggleFavorite(profile);
                  },
                );
              },
            ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Forever Matrimony',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Meet Our Team'),
              _buildCard([
                _buildTextRow(
                    'Developed by:', 'Chauhan Pruthviraj (23010101046)'),
                _buildTextRow('Mentored by:',
                    "Prof. Mehul Bhundiya, School of Computer Science"),
              ]),
              _buildSectionTitle('About ASWDC'),
              _buildCard([
                Text(
                  'ASWDC is an Application, Software, and Website Development Center at Darshan University...',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              ]),
              _buildSectionTitle('Contact'),
              _buildCard([
                _buildIconText(Icons.email, '23010101046@darshan.ac.in'),
                _buildIconText(Icons.phone, '+91-9054652854'),
                _buildIconText(Icons.language, 'www.cosmos.com'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProfileCard({
    required this.profile,
    required this.isFavorite,
    this.onFavoriteToggle,
    super.key,
  });

  String truncateName(String name, {int maxLength = 20}) {
    final nameWithoutSpaces = name.replaceAll(' ', '');
    if (nameWithoutSpaces.length <= maxLength) {
      return name;
    }

    String truncatedName = '';
    int charCount = 0;
    for (var word in name.split(' ')) {
      if (charCount + word.length > maxLength) {
        break;
      }
      truncatedName += '$word ';
      charCount += word.length;
    }

    return '${truncatedName.trim()}...';
  }

  @override
  Widget build(BuildContext context) {
    final truncatedName = truncateName(profile.name);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDetailPage(profile: profile),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: profile.imageUrl.isNotEmpty
                  ? Image.network(
                      // Use Image.network for URL
                      profile.imageUrl,
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person,
                          size: 60, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    truncatedName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${profile.age} | ${profile.location}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: onFavoriteToggle,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(profile: profile),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Text(
                                    "Delete Profile?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this profile? This action cannot be undone.",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Provider.of<ProfileManager>(context,
                                                listen: false)
                                            .deleteProfile(
                                                profile.id.toString());
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: Text(
                                        "Delete",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailPage extends StatefulWidget {
  final Profile profile;

  const ProfileDetailPage({required this.profile, super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile.name),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ProfileManager>(context).isFavorite(widget.profile)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              Provider.of<ProfileManager>(context, listen: false)
                  .toggleFavorite(widget.profile);
              setState(() {}); // Refresh the UI
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.profile.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        // Use Image.network for URL
                        widget.profile.imageUrl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 150,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Name", widget.profile.name),
            _buildDetailRow("Email", widget.profile.email),
            _buildDetailRow("Mobile Number", widget.profile.mobileNumber),
            _buildDetailRow(
              "Date of Birth",
              widget.profile.dateOfBirth.isNotEmpty
                  ? DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(widget.profile.dateOfBirth))
                  : 'Not specified',
            ),
            _buildDetailRow("Age", "${widget.profile.age} years"),
            _buildDetailRow("Location", widget.profile.location),
            _buildDetailRow("Gender", widget.profile.gender),
            _buildDetailRow(
              "Hobbies",
              widget.profile.hobbies.isNotEmpty
                  ? widget.profile.hobbies.split("").join(", ")
                  : "No hobbies specified",
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                onPressed: () {
                  Provider.of<ProfileManager>(context, listen: false)
                      .toggleFavorite(widget.profile);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Provider.of<ProfileManager>(context)
                                .isFavorite(widget.profile)
                            ? 'Added to Favorites'
                            : 'Removed from Favorites',
                      ),
                    ),
                  );
                  setState(() {}); // Refresh the UI
                },
                icon: Icon(
                  Provider.of<ProfileManager>(context)
                          .isFavorite(widget.profile)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                label: Text(
                  Provider.of<ProfileManager>(context)
                          .isFavorite(widget.profile)
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class ProfileRepository {
  static final List<Profile> profiles = [];
  static final List<Profile> favorites = [];

  static void toggleFavorite(Profile profile) {
    if (favorites.contains(profile)) {
      favorites.remove(profile);
    } else {
      favorites.add(profile);
    }
  }

  static void updateProfile(Profile oldProfile, Profile newProfile) {
    final profileIndex = profiles.indexOf(oldProfile);
    if (profileIndex != -1) {
      profiles[profileIndex] = newProfile;
    }

    final favIndex = favorites.indexOf(oldProfile);
    if (favIndex != -1) {
      favorites[favIndex] = newProfile;
    }
  }

  static void deleteProfile(Profile profile) {
    profiles.remove(profile);
    favorites.remove(profile);
  }
}

mixin ProfileValidationMixin {
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full Name is required';
    }
    if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
      return 'Only alphabetic characters and spaces are allowed';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile Number is required';
    }
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    if (value.length != 10) {
      return 'Mobile Number must be 10 digits';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  bool isValidAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return false;
    final age = calculateAge(dateOfBirth);
    return age >= 18 && age < 80;
  }

  int calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }
}

class ProfileManager extends ChangeNotifier {
  final List<Profile> _profiles = [];
  final List<Profile> _favorites = [];
  final ApiService _apiService = ApiService();

  List<Profile> get profiles => List.unmodifiable(_profiles);

  List<Profile> get favorites => List.unmodifiable(_favorites);

  ProfileManager() {
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    _profiles.clear();
    final profiles = await _apiService.getProfiles();
    print("Profiles Loaded: ${profiles.length}");
    _profiles.addAll(profiles);
    notifyListeners();
  }

  Future<void> addProfile(Profile profile) async {
    await _apiService.addProfile(profile);
    _loadProfiles();
  }

  Future<void> updateProfile(Profile oldProfile, Profile newProfile) async {
    await _apiService.updateProfile(newProfile);
    _loadProfiles();
  }

  Future<void> deleteProfile(String id) async {
    await _apiService.deleteProfile(id);
    _loadProfiles();
  }

  bool isFavorite(Profile profile) {
    return _profiles.firstWhere((p) => p.id == profile.id).isFavorite;
  }

  Future<void> toggleFavorite(Profile profile) async {
    await _apiService.toggleFavorite(profile);
    _loadProfiles();
  }
}

class AlphabeticInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^[a-zA-Z\s]*$');
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
