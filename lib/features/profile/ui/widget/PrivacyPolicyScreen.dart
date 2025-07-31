import 'package:flutter/material.dart';
import 'package:nexon/features/profile/ui/widget/SupportAndHelpScreen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  static const routeName = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: theme.cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: July 26, 2025',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            _buildPrivacyItem(
              context: context,
              icon: Icons.shield_outlined,
              title: 'Data Collection',
              description:
                  'We collect information you provide directly, automatically, and from other sources.',
            ),
            const SizedBox(height: 15),
            _buildPrivacyItem(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Data Use',
              description:
                  'We use your data to provide, improve, and personalize our services, and for...',
            ),
            const SizedBox(height: 15),
            _buildPrivacyItem(
              context: context,
              icon: Icons.person_outline,
              title: 'User Rights',
              description:
                  'You have rights regarding your data, including access, correction, and deletion.',
            ),
            const Spacer(),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.dividerColor.withOpacity(
              theme.brightness == Brightness.dark ? 0.2 : 0.7,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.iconTheme.color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "I Agree",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: theme.dividerColor),
              backgroundColor: theme.scaffoldBackgroundColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ContactSupportScreen.routeName);
            },
            child: Text(
              "Need Help",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
