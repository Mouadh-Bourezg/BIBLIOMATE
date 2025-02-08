import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './HomePage.dart';
import './SearchPage.dart';
import './uploadDocument.dart';
import './documentPage.dart';
import './myProfilePage.dart';
import './styles.dart';
import './SignInPage.dart';
import './services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dependency_injection.dart';
import 'pages/First_page.dart';

void main() async {  // Make main async
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  
  // Recover session if it exists
  final savedSession = await SupabaseService.restoreSession();
  if (savedSession != null) {
    await Supabase.instance.client.auth.recoverSession(savedSession);
  }
  
  DependencyInjection.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: SupabaseService.isSignedIn ? const MainPage() : const FirstPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    uploadDocumentPage(),
    documentPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return SignInPage();
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
