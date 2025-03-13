import 'dart:convert';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

// import 'package:mat_app/widget_tree.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mat_app/profile.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'authentication.dart';

import 'package:mat_app/login_screen.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
      ),
    ),
  );

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
          home: HomePage(onSignOut: () {
            Auth().signOut();
          }),
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for contrast
      appBar: AppBar(
        title: const Text('Matrimony App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onSignOut,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  image: NetworkImage(
                    Auth().currentUser?.photoURL ?? 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      Auth().currentUser?.photoURL ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Auth().currentUser?.displayName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Auth().currentUser?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement settings page
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement help & support page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? const HomeScreenContent()
          : _getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'Add Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return const AddProfilePage();
      case 2:
        return const FavoritesPage();
      case 3:
        return const AboutPage();
      default:
        return const HomeScreenContent();
    }
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final profileManager = Provider.of<ProfileManager>(context);
    final profiles = profileManager.profiles;

    // Show loading indicator while profiles are being loaded
    if (profileManager.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Ensure profiles are not null
    final males = profiles.where((p) => p.gender == 'Male').length;
    final females = profiles.where((p) => p.gender == 'Female').length;
    final totalProfiles = profiles.length;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🔹 Glass Card for Stats & Gender Chart
            GlassContainer(
              child: SizedBox(
                width: double.infinity,
                // ✅ Ensures it takes full width without infinite constraints
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // ✅ Prevents infinite height issue
                    children: [
                      Text(
                        'Total Profiles: $totalProfiles',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // ✅ Wrap Pie Chart in ConstrainedBox to prevent infinite layout issues
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 150,
                          // ✅ Ensures PieChart gets a fixed width
                          maxHeight:
                              150, // ✅ Ensures PieChart gets a fixed height
                        ),
                        child: _buildGenderChart(males, females),
                      ),

                      const SizedBox(height: 10),
                      _buildLegendRow(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Display Profile Cards
            profiles.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return ProfileCard(
                        profile: profile,
                        onTap: () {
                          // Implement tap action
                        },
                        onEdit: () {
                          // Implement edit action
                        },
                        onDelete: () {
                          // Implement delete action
                        },
                        onToggleFavorite: () {
                          profileManager.toggleFavorite(profile);
                        },
                        onToggleOptap: () {
                          // Implement optap toggle action
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No profiles found!",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderChart(int males, int females) {
    if (males == 0 && females == 0) {
      return const Text(
        "No gender data available",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      );
    }

    return SizedBox(
      width: 150, // ✅ Explicit width
      height: 150, // ✅ Explicit height
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: males.toDouble(),
              color: Colors.blue,
              title: '$males',
              radius: 40,
            ),
            PieChartSectionData(
              value: females.toDouble(),
              color: Colors.pink,
              title: '$females',
              radius: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.blue, 'Male'),
        const SizedBox(width: 20),
        _buildLegendItem(Colors.pink, 'Female'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;

  const GlassContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate a finite width based on the device width.
    final width = MediaQuery.of(context).size.width * 0.9;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          width: width,
          // Adding a minimum height helps avoid unbounded constraints.
          constraints: const BoxConstraints(
            minHeight: 100,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  AddProfilePageState createState() => AddProfilePageState();
}

class AddProfilePageState extends State<AddProfilePage> {
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

  List<String> cities = ["Wankaner", "Morbi", "Ahmedabad", "Rajkot", "Kutch"];
  List<String> hobbyOptions = ["Reading", "Traveling", "Cooking", "Sports"];

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // More aggressive compression settings
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          imageFile.absolute.path,
          imageFile.absolute.path + '_compressed.jpg',
          quality: 20, // Even more reduced quality for smaller size
          minWidth: 400, // Further reduced maximum width
          minHeight: 400, // Further reduced maximum height
          rotate: 0,
          keepExif: false, // Remove EXIF data to reduce size
          format: CompressFormat.jpeg,
        );
        
        // Hide loading indicator
        Navigator.pop(context);

        if (compressedImage != null) {
          final compressedFile = File(compressedImage.path);
          List<int> imageBytes = await compressedFile.readAsBytes();
          
          // Check if the compressed image is still too large (e.g., > 500KB)
          if (imageBytes.length > 512 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image is still too large. Please choose a smaller image.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          String base64Image = base64Encode(imageBytes);
          setState(() {
            imageUrl = base64Image;
            _profileImage = compressedFile;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to compress image. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading indicator if it's still showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;
      });
    }
  }

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
      if (_profileImage == null && imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a profile image')),
        );
        return;
      }

      try {
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
          dateOfBirth: dateOfBirth!.toIso8601String(),
        );

        await Provider.of<ProfileManager>(context, listen: false).addProfile(newProfile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Added Successfully')),
        );

        // Navigate back to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(onSignOut: () { Auth().signOut(); })),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add profile: $e')),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name is required';
                  }
                  if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                    return 'Only alphabetic characters and spaces are allowed';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => fullName = value.trim()),
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Email Address', prefixIcon: Icon(Icons.email)),
                onChanged: (value) =>
                    setState(() => email = value.trim().toLowerCase()),
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone)),
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
                decoration: const InputDecoration(labelText: 'City'),
                items: cities
                    .map((city) =>
                        DropdownMenuItem(value: city, child: Text(city)))
                    .toList(),
                onChanged: (value) => setState(() => city = value!),
                validator: (value) =>
                    value == null || value.isEmpty ? 'City is required' : null,
              ),
              const SizedBox(height: 15),
              const Text('Date of Birth:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
              const SizedBox(height: 20),
              const Text('Gender:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              const Text('Hobbies:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                decoration: const InputDecoration(
                    labelText: 'Password', prefixIcon: Icon(Icons.lock)),
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
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock)),
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

  Widget _buildGenderChart(int males, int females) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: males.toDouble(),
            color: Colors.blue,
            title: '$males',
            radius: 40,
          ),
          PieChartSectionData(
            value: females.toDouble(),
            color: Colors.pink,
            title: '$females',
            radius: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Profiles')),
      body: Column(
        children: [
          Consumer<ProfileManager>(
            builder: (context, manager, _) {
              final males =
                  manager.profiles.where((p) => p.gender == 'Male').length;
              final females =
                  manager.profiles.where((p) => p.gender == 'Female').length;

              return Container(
                height: 200,
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Gender Distribution',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: _buildGenderChart(males, females)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegend(Colors.blue, 'Male ($males)'),
                                  SizedBox(height: 8),
                                  _buildLegend(
                                      Colors.pink, 'Female ($females)'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
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
                final filteredProfiles = _filterAndSortProfiles(profileManager.profiles);
                print("Filtered Profiles: ${filteredProfiles.length}"); // Log filtered profiles

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Set to 1 for larger cards
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9, // Adjust height/width ratio to make cards bigger
                  ),
                  itemCount: filteredProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = filteredProfiles[index];
                    return ProfileCard(
                      profile: profile,
                      onTap: () {
                        // Implement tap action
                      },
                      onEdit: () {
                        // Implement edit action
                      },
                      onDelete: () {
                        // Implement delete action
                      },
                      onToggleFavorite: () {
                        profileManager.toggleFavorite(profile);
                      },
                      onToggleOptap: () {
                        // Implement optap toggle action
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
          crossAxisCount: 1, // Keep it as 2 for a 2-column layout
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85, // Increase this to make cards taller
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final profile = favorites[index];
          return ProfileCard(
            profile: profile,
            onTap: () {
              // Implement tap action
            },
            onEdit: () {
              // Implement edit action
            },
            onDelete: () {
              // Implement delete action
            },
            onToggleFavorite: () {
              profileManager.toggleFavorite(profile);
            },
            onToggleOptap: () {
              // Implement optap toggle action
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
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleOptap;

  const ProfileCard({
    Key? key,
    required this.profile,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
    required this.onToggleOptap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: profile.imageUrl.isNotEmpty
                        ? NetworkImage(profile.imageUrl)
                        : null,
                    child: profile.imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          profile.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: profile.isFavorite ? Colors.red : null,
                        ),
                        onPressed: onToggleFavorite,
                      ),
                      IconButton(
                        icon: Icon(
                          profile.isOptap
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: profile.isOptap ? Colors.blue : Colors.grey,
                        ),
                        onPressed: onToggleOptap,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
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
  final ApiService _apiService = ApiService();
  List<Profile> _profiles = [];
  List<Profile> _favorites = [];
  bool _isLoading = false;

  List<Profile> get profiles => _profiles;
  List<Profile> get favorites => _favorites;
  bool get isLoading => _isLoading;

  ProfileManager() {
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profiles = await _apiService.getProfiles();
      _favorites = await _apiService.getFavorites();
    } catch (e) {
      print('Error loading profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProfile(Profile profile) async {
    try {
      await _apiService.addProfile(profile);
      await _loadProfiles();
    } catch (e) {
      print('Error adding profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(Profile oldProfile, Profile newProfile) async {
    try {
      await _apiService.updateProfile(newProfile);
      await _loadProfiles();
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      await _apiService.deleteProfile(id);
      await _loadProfiles();
    } catch (e) {
      print('Error deleting profile: $e');
      rethrow;
    }
  }

  Future<void> toggleFavorite(Profile profile) async {
    try {
      await _apiService.toggleFavorite(profile);
      await _loadProfiles();
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  Future<void> toggleOptap(Profile profile) async {
    try {
      await _apiService.toggleOptap(profile);
      await _loadProfiles();
    } catch (e) {
      print('Error toggling optap: $e');
      rethrow;
    }
  }

  bool isFavorite(Profile profile) {
    return _favorites.any((p) => p.email == profile.email);
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeScreenContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProfilePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Auth().currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      user?.photoURL ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18),
                        onPressed: () {
                          // TODO: Implement profile picture change
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileSection(
              'Personal Information',
              [
                _buildInfoRow('Name', user?.displayName ?? 'Not set'),
                _buildInfoRow('Email', user?.email ?? 'Not set'),
                _buildInfoRow('Phone', user?.phoneNumber ?? 'Not set'),
              ],
            ),
            const SizedBox(height: 24),
            _buildProfileSection(
              'Account Settings',
              [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement password change
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement notification settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement privacy settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
