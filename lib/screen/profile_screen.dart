import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample user data (can be replaced with real data)
  final String userName = "Alvin Astara";

  // Method to show edit photo dialog
  void _showEditPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Profile Picture'),
        content: Text('Feature to upload or select image would go here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add image upload logic here in a real app
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile picture updated!')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Navigate to a blank page based on menu title
  void _navigateToPage(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text('Content for $title goes here')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wooden background from new design
        Image.asset(
          'assets/profile.png',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                // Profile Photo Section (from old design, adjusted for new theme)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            Colors.blueGrey, // Placeholder, can use real image
                        child:
                            Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: Colors
                                .green[700]), // Earthy green from new design
                        onPressed: _showEditPhotoDialog,
                      ),
                    ],
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Matches new design's text color
                  ),
                ),
                SizedBox(height: 20),
                // Menu Section (from old design, with new styling)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown[100], // Beige card from new design
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: [
                        _buildMenuItem(Icons.edit, 'Edit Profile Name',
                            () => _navigateToPage('Edit Profile Name')),
                        _buildMenuItem(Icons.save_alt, 'Saved Products',
                            () => _navigateToPage('Saved Products')),
                        _buildMenuItem(Icons.lock, 'Change Password',
                            () => _navigateToPage('Change Password')),
                        _buildMenuItem(Icons.email, 'Change Email Address',
                            () => _navigateToPage('Change Email Address')),
                        _buildMenuItem(Icons.settings, 'Settings',
                            () => _navigateToPage('Settings')),
                        _buildMenuItem(Icons.tune, 'Preferences',
                            () => _navigateToPage('Preferences')),
                        _buildLogoutItem(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Reusable ListTile for menu items (from old design, styled for new theme)
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]), // Earthy green icons
      title: Text(
        title,
        style:
            TextStyle(color: Colors.black87), // Dark text for beige background
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.green[700]),
      onTap: onTap,
    );
  }

  // Special ListTile for Logout (from old design, with new color)
  Widget _buildLogoutItem() {
    return ListTile(
      leading: Icon(Icons.exit_to_app,
          color: Colors.red[700]), // Red from old design, adjusted
      title: Text(
        'Logout',
        style: TextStyle(color: Colors.red[700]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.red[700]),
      onTap: () {
        // Add logout logic here (e.g., clear auth state)
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/startup',
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out!')),
        );
      },
    );
  }
}
