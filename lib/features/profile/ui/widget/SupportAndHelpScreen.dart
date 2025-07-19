// ignore: file_names
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});
  static const routeName = '/contact-support';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you need further assistance, please contact us directly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.email),
              ),
              title: Text(' Email: hamedahmed143022@privacymanager.com'),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.phone),
              ),
              title: Text(' Phone: +20 1143290484'),
            ),
          ],
        ),
      ),
    );
  }
}
