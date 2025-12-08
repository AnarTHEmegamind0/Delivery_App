import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/constants.dart';
import '../providers/driver_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/profile_info_card.dart';
import 'rating_detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverProvider>().fetchProfile();
      context.read<RatingProvider>().fetchRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.settings),
      ),
      body: Consumer<DriverProvider>(
        builder: (context, driverProvider, child) {
          if (driverProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (driverProvider.profile == null) {
            return const Center(child: Text('Мэдээлэл олдсонгүй'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Info Card
                ProfileInfoCard(profile: driverProvider.profile!),
                
                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.star,
                  title: AppConstants.myRating,
                  subtitle: Consumer<RatingProvider>(
                    builder: (context, ratingProvider, child) {
                      if (ratingProvider.ratings != null) {
                        return Text(
                          '${ratingProvider.averageRating.toStringAsFixed(1)} од • ${ratingProvider.totalReviews} ${AppConstants.reviews}',
                        );
                      }
                      return const Text('');
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RatingDetailPage(),
                      ),
                    );
                  },
                ),
                
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: AppConstants.withdraw,
                  onTap: () {
                    // Navigate to earnings/withdrawal page
                  },
                ),
                
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return _buildSwitchMenuItem(
                      context,
                      icon: Icons.dark_mode,
                      title: AppConstants.darkMode,
                      value: themeProvider.isDarkMode,
                      onChanged: (value) => themeProvider.toggleTheme(),
                    );
                  },
                ),
                
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: AppConstants.help,
                  onTap: () {
                    // Navigate to help page
                  },
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Handle logout
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingM,
                        ),
                        side: BorderSide(color: AppTheme.errorColor),
                        foregroundColor: AppTheme.errorColor,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Гарах'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }
}
