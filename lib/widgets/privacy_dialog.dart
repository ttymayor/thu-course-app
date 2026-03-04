import 'package:flutter/material.dart';

void showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Privacy Policy'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'THU Course App respects your privacy. This policy explains how we handle your information.\n',
            ),
            _SectionTitle('Authentication'),
            Text(
              'We use Firebase Authentication with Google Sign-In. Only your email address is used to verify that you are a Tunghai University member (@go.thu.edu.tw or @thu.edu.tw). We do not store your Google password.\n',
            ),
            _SectionTitle('Data Collection'),
            Text(
              'We collect minimal data necessary for the app to function:\n'
              '- Email address (for THU domain verification)\n'
              '- Display name and profile photo (from your Google account)\n'
              '- Course selections you make within the app\n',
            ),
            _SectionTitle('Data Storage'),
            Text(
              'Authentication state is managed by Firebase and stored locally on your device. Course data is fetched from university sources and cached locally.\n',
            ),
            _SectionTitle('Third-Party Services'),
            Text(
              'This app uses Google Sign-In and Firebase, which are governed by Google\'s Privacy Policy.\n',
            ),
            _SectionTitle('Data Deletion'),
            Text(
              'You can sign out at any time from Settings. This clears your local session. To delete your Firebase account data, contact the app maintainer.',
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
