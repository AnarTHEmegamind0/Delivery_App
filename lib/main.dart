import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'features/delivery/providers/driver_provider.dart';
import 'features/delivery/providers/earnings_provider.dart';
import 'features/delivery/providers/notification_provider.dart';
import 'features/delivery/providers/order_provider.dart';
import 'features/delivery/providers/rating_provider.dart';
import 'features/delivery/providers/theme_provider.dart';


import 'features/customer/providers/customer_order_provider.dart';
import 'core/main_navigation_2.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => EarningsProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => CustomerOrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Delivery App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainNavigation2(), // Switched to Customer App
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
