import 'package:flutter/material.dart';
import './themes/theme.dart'; // Import your custom theme
import 'screens/dashboard_screen.dart';
import 'widgets/take_charge_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academate',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // Use custom theme here
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/take_charge_detail': (context) => const TakeChargeDetail(),
      },
    );
  }

}

// import 'package:flutter/material.dart';
// import './themes/theme.dart'; // Import your custom theme
// import '../lib/routes/app_router.dart'; // Import the router configuration

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Academate',
//       debugShowCheckedModeBanner: false,
//       theme: appTheme, // Use your existing custom theme
//       routerConfig: AppRouter.router, // Use GoRouter configuration
//     );
//   }
// }
