import 'package:flutter/material.dart';
import '../config/app_settings.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Help & Support', style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Frequently Asked Questions',
            items: [
              {
                'question': 'How do I create an account?',
                'answer': 'To create an account, tap the "Sign Up" button on the login screen and follow the prompts to enter your email, password, and other required information.'
              },
              {
                'question': 'How do I reset my password?',
                'answer': 'To reset your password, go to the login screen and tap "Forgot Password". Enter your email address, and we\'ll send you instructions to reset your password.'
              },
              {
                'question': 'How do I download movies?',
                'answer': 'To download a movie, go to the movie details page and tap the "Download" button. Make sure you have enough storage space on your device.'
              },
              {
                'question': 'How do I cancel my subscription?',
                'answer': 'To cancel your subscription, go to the Settings screen, tap on "Subscription", and then select "Cancel Subscription". Follow the prompts to complete the cancellation process.'
              },
            ],
          ),
          _buildSection(
            title: 'Contact Us',
            items: [
              {
                'question': 'Email',
                'answer': 'support@movieapp.com'
              },
              {
                'question': 'Phone',
                'answer': '+1 (123) 456-7890'
              },
              {
                'question': 'Live Chat',
                'answer': 'Start a live chat session with our support team.'
              },
            ],
          ),
          _buildSection(
            title: 'Troubleshooting',
            items: [
              {
                'question': 'Playback issues',
                'answer': 'If you\'re experiencing playback issues, try clearing your app cache, checking your internet connection, or reinstalling the app.'
              },
              {
                'question': 'Account issues',
                'answer': 'For account-related problems, please contact our support team via email or live chat.'
              },
              {
                'question': 'Billing issues',
                'answer': 'If you have questions about billing, please review your subscription details in the app or contact our support team.'
              },
              {
                'question': 'App crashes',
                'answer': 'If the app is crashing, try updating to the latest version, clearing the app cache, or reinstalling the app.'
              },
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement live chat functionality
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Live Chat'),
                content: Text('Live chat feature coming soon!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.chat),
        tooltip: 'Start Live Chat',
      ),
    );
  }

  Widget _buildSection({required String title, required List<Map<String, String>> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => ExpansionTile(
          title: Text(item['question']!),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item['answer']!),
            ),
          ],
        )),
        Divider(),
      ],
    );
  }
}

