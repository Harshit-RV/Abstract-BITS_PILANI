import 'package:abstract_curiousity/Features/HomePage/homepage.dart';
import 'package:abstract_curiousity/Features/Profile/bloc/profile_bloc.dart';
import 'package:abstract_curiousity/Features/Profile/services/profile_repository.dart';
import 'package:abstract_curiousity/Features/UserRegisteration/screens/login_google.dart';
import 'package:abstract_curiousity/Features/UserRegisteration/services/auth_repository.dart';
import 'package:abstract_curiousity/Features/UserRegisteration/services/bloc/auth_bloc.dart';
import 'package:abstract_curiousity/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (BuildContext context) => ProfileBloc(
                profileRepository:
                    RepositoryProvider.of<ProfileRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(primary: Colors.black),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.grey,
              ),
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
              if (snapshot.hasData) {
                return const HomePage();
              }
              // Otherwise, they're not signed in. Show the sign in page.
              return const LandingPage();
            },
          ),
        ),
      ),
    );
  }
}

//TODO : remove prestige points reduction, add prestige points increase only
//higher the points : assign medal or something

