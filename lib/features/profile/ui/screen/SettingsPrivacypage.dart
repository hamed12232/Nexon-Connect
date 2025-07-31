import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexon/core/Components/firebase_notification.dart';
import 'package:nexon/core/helper/services_helper.dart';
import 'package:nexon/core/style/style.dart';
import 'package:nexon/core/style/theme/theme_cubit.dart';
import 'package:nexon/features/auth/ui/screen/AuthScreen.dart';
import 'package:nexon/features/profile/ui/widget/PrivacyPolicyScreen.dart';
import 'package:nexon/features/profile/ui/widget/SupportAndHelpScreen.dart';
import 'package:nexon/features/profile/ui/widget/accountSection.dart';
import 'package:nexon/features/profile/ui/widget/changePassword.dart';

class SettingsPrivacyPage extends StatefulWidget {
  const SettingsPrivacyPage({
    super.key,
    required this.imgurl,
    required this.name,
    required this.email,
  });
  static const String routeName = "/settings";
  final String imgurl;
  final String name;
  final String email;

  @override
  State<SettingsPrivacyPage> createState() => _SettingsPrivacyPageState();
}

class _SettingsPrivacyPageState extends State<SettingsPrivacyPage> {
  bool notificationsEnabled = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  final Color backgroundColor = const Color(0xFFF7F7F7);
  final Color textColor = Colors.black87;
  final Color secondaryTextColor = Colors.grey[600]!;
  final Color dividerColor = Colors.grey[300]!;
  FirebaseNotification firebaseNotification = FirebaseNotification();

  @override
  void initState() {
    super.initState();
    firebaseNotification.getNotificationSetting().then((value) {
      setState(() {
        notificationsEnabled = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings & Privacy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ComplateProfileScreen.routeName);
            },
            child: _buildAccountSection(),
          ),
          _buildDivider(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Changepassword.routeName,
                arguments: widget.email,
              );
            },
            child: _buildSimpleTile(Icons.lock_outline, "Change Password"),
          ),
          _buildSectionTitle("PREFERENCES"),
          _buildSwitchTile("Notifications", notificationsEnabled, (
            value,
          ) async {
            setState(() => notificationsEnabled = value);
            await firebaseNotification.saveNotificationSetting(value);
            firebaseNotification.handleForeground();

            log("Notifications turned ${value ? "on" : "off"} by user");
          }),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final themeCubit = ThemeCubit.get(context);
              final isDark = themeCubit.isDarkMode;
              return _buildSwitchTile("Dark Mode", isDark, (value) async {
                await themeCubit.selectThemeMode(
                  value ? ThemeModeState.dark : ThemeModeState.light,
                );
              });
            },
          ),
          _buildSectionTitle("SUPPORT & ABOUT"),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PrivacyPolicyScreen.routeName);
            },
            child: _buildSimpleTile(
              Icons.privacy_tip_outlined,
              "Privacy Policy",
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ContactSupportScreen.routeName);
            },
            child: _buildSimpleTile(Icons.help_outline, "Help & Support"),
          ),
          Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Icon(
                  Icons.warning,
                  color: ColorsTheme.loginGradientEnd,
                ),
                title: Text(
                  "Delete Account",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text(
                            "Are you sure you want to delete your account?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                ServicesHelper().deleteAccount(
                                  auth.currentUser!,
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AuthScreen.routeName,
                                  (route) => false,
                                );
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.delete_forever,
                    size: 25,
                    color: Colors.red,
                  ),
                ),
              ),
              _buildDivider(),
            ],
          ),
          const SizedBox(height: 30),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(widget.imgurl),
        radius: 30,
      ),
      title: Text(
        widget.name,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "@${widget.name}",
        style: TextStyle(color: secondaryTextColor),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: dividerColor);
  }

  Widget _buildSimpleTile(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Icon(icon, color: ColorsTheme.loginGradientEnd),
          title: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ColorsTheme.loginGradientEnd,
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 0, 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          ServicesHelper().signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AuthScreen.routeName,
            (route) => false,
          );
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          "Log Out",
          style: TextStyle(color: Colors.red, fontSize: 15),
        ),
      ),
    );
  }
}
