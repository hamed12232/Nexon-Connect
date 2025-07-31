import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexon/features/Post/logic/cubit/post_cubit/post_cubit.dart';
import 'package:nexon/features/home/ui/screen/HomeScreenContent.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final user = FirebaseAuth.instance;
  @override
  void initState() {
    context.read<PostCubit>().fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenContent(user: user);
  }
}
