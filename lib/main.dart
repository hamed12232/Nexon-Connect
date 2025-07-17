import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/Components/firebase_local_notification.dart';
import 'package:myapp/core/Components/local_notification.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/Post/logic/cubit/post_cubit/post_cubit.dart';
import 'package:myapp/features/auth/logic/Cubit/auth_cubit.dart' show AuthCubit;
import 'package:myapp/features/auth/ui/screen/AuthScreen.dart';
import 'package:myapp/core/routing/NavigationRoutes.dart';
import 'package:myapp/features/home/ui/screen/HomeScreen.dart';
import 'package:myapp/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://phjbtfqjmlkwoooavnfb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBoamJ0ZnFqbWxrd29vb2F2bmZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NzkwODgsImV4cCI6MjA2NjA1NTA4OH0.SbVH4Dw2z3fJ7_Tv02fODxnAPeJgqpB4j4rJCxMah8g',
  );
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  await Future.wait([
    LocalNotification().init(),
     FirebaseLocalNotification().initNotification()
  ]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => PostCubit()),
        BlocProvider(create: (_) => ChatCubit())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final MaterialColor colorCustom = MaterialColor(0xff651CE5, color);
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: "Sans serif",
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: user != null ? HomeScreen.routeName : AuthScreen.routeName,
      onGenerateRoute: NavigationRoutes.generateRoute,
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(102, 28, 229, .1),
  100: Color.fromRGBO(102, 28, 229, .2),
  200: Color.fromRGBO(102, 28, 229, .3),
  300: Color.fromRGBO(102, 28, 229, .4),
  400: Color.fromRGBO(102, 28, 229, .5),
  500: Color.fromRGBO(102, 28, 229, .6),
  600: Color.fromRGBO(102, 28, 229, .7),
  700: Color.fromRGBO(102, 28, 229, .8),
  800: Color.fromRGBO(102, 28, 229, .9),
  900: Color.fromRGBO(102, 28, 229, 1),
};
