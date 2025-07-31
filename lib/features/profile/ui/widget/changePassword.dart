import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nexon/core/Components/Snak_bar.dart';
import 'package:nexon/core/helper/services_helper.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key, required this.email});
  static const String routeName = "/changepassword";
  final String email;

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: SvgPicture.asset(
                "assets/images/reset_password.svg",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            _buildEmailTextField(
              context,
              _oldpasswordController,
              "Old Password",
            ),
            const SizedBox(height: 20),
            _buildEmailTextField(
              context,
              _newpasswordController,
              "New Password",
            ),
            const SizedBox(height: 30),
            _buildSendPasswordButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSendPasswordButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 43,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextButton(
        onPressed: () async {
          bool success = await ServicesHelper().changePassword(
            widget.email,
            _oldpasswordController.text.trim(),
            _newpasswordController.text.trim(),
          );

          if (success) {
            showInSnackBar("Password Changed Successfully", context);
          } else {
            showInSnackBar(
              "Failed to change password. Check old password.",
              context,
            );
          }
        },
        child: Text(
          'Confirm',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  _buildEmailTextField(
    BuildContext context,
    TextEditingController textController,
    String password,
  ) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: textController,
        style: TextStyle(
          fontSize: 15.0,
          color: theme.textTheme.titleLarge?.color,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: password,
          hintStyle: TextStyle(
            fontSize: 15.0,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        maxLines: null,
      ),
    );
  }
}
