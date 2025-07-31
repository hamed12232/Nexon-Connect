import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexon/core/Components/OnBackgroundFunction.dart';
import 'package:nexon/core/Components/firebase_notification.dart';
import 'package:nexon/core/Components/local_notification.dart';
import 'package:nexon/core/helper/cache_helper.dart';
import 'package:nexon/core/style/theme/theme_cubit.dart';
import 'package:nexon/core/style/theme/theme_data.dart';
import 'package:nexon/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:nexon/features/Post/logic/cubit/post_cubit/post_cubit.dart';
import 'package:nexon/features/auth/logic/Cubit/auth_cubit.dart' show AuthCubit;
import 'package:nexon/features/auth/ui/screen/AuthScreen.dart';
import 'package:nexon/core/routing/NavigationRoutes.dart';
import 'package:nexon/features/home/ui/screen/HomeScreen.dart';
import 'package:nexon/firebase_options.dart';
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
    FirebaseNotification().initNotification(),
    CachHelper().init(),
  ]);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => PostCubit()),
        BlocProvider(create: (_) => ChatCubit()),
        BlocProvider.value(value: themeCubit),
        //Use BlocProvider.value() when you need to reuse an existing instance
        //Don't create multiple instances of the same BloC when you need shared state
      ],
      child: Nexon(),
    ),
  );
}

class Nexon extends StatelessWidget {
  Nexon({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeMode = ThemeCubit.get(context).getTheme();
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,

            themeMode: themeMode,
            initialRoute: user != null
                ? HomeScreen.routeName
                : AuthScreen.routeName,
            onGenerateRoute: NavigationRoutes.generateRoute,
          ),
        );
      },
    );
  }
}
