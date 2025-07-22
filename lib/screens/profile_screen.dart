import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String citizenId;
  final String region;

  const ProfileScreen({
    Key? key,
    this.citizenId = '****1234',
    this.region = 'Kuala Lumpur',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Verified Identity Card
            Card(
              color: Colors.green[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
              margin: EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[100],
                      radius: 28,
                      child: Icon(Icons.verified, color: Colors.green, size: 32),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Verified Citizen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              SizedBox(width: 8),
                              Chip(label: Text('Verified'), backgroundColor: Colors.green[200]),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text('Citizen ID: $citizenId', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 2),
                          Text('Region: $region', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Placeholder for additional profile info or actions
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.person, color: purple),
                title: Text('Your Name'),
                subtitle: Text('Edit profile info coming soon...'),
              ),
            ),
            SizedBox(height: 24),
            // Add more profile actions here (e.g., logout, settings)
          ],
        ),
      ),
    );
  }
} 