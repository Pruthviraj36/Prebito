// screens/favorite_user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class FavoriteUserScreen extends StatelessWidget {
  const FavoriteUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Users'),
      ),
      body: ListView.builder(
        itemCount: userProvider.favoriteUsers.length,
        itemBuilder: (context, index) {
          final user = userProvider.favoriteUsers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(user.fullName),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.green,
                ),
                onPressed: () {
                  userProvider.toggleFavorite(user);
                },
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/userDetail',
                  arguments: user,
                );
              },
            ),
          );
        },
      ),
    );
  }
}