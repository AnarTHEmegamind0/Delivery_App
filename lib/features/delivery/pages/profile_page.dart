import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/design_system/design_system.dart';
import '../../../core/utils.dart';
import '../providers/driver_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/theme_provider.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Consumer<DriverProvider>(
        builder: (context, driverProvider, child) {
          if (driverProvider.isLoading) {
            return _buildLoadingState(isDark);
          }

          if (driverProvider.profile == null) {
            return _buildErrorState(isDark);
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildProfileHeader(context, driverProvider, isDark),
              ),
              SliverToBoxAdapter(
                child: _buildStatsGrid(context, driverProvider, isDark),
              ),
              SliverToBoxAdapter(
                child: _buildSettingsSection(context, isDark),
              ),
              SliverToBoxAdapter(
                child: _buildVehicleCard(context, driverProvider, isDark),
              ),
              SliverToBoxAdapter(
                child: _buildLogoutSection(context, isDark),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenInset,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxxl),
            ShimmerSkeleton.circle(size: 100),
            const SizedBox(height: AppSpacing.lg),
            ShimmerSkeleton.text(width: 150),
            const SizedBox(height: AppSpacing.sm),
            ShimmerSkeleton.text(width: 100),
            const SizedBox(height: AppSpacing.xxxl),
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : AppSpacing.sm,
                      right: index == 2 ? 0 : AppSpacing.sm,
                    ),
                    child: ShimmerSkeleton.rect(height: 100, radius: AppSpacing.radiusLg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightBorderSubtle,
              borderRadius: AppSpacing.borderRadiusFull,
            ),
            child: Icon(
              Icons.person_off_outlined,
              size: 40,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Мэдээлэл олдсонгүй',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedButton(
            label: 'Дахин оролдох',
            onPressed: () => context.read<DriverProvider>().fetchProfile(),
            size: AnimatedButtonSize.medium,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, DriverProvider driverProvider, bool isDark) {
    final profile = driverProvider.profile!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark
                ? AppColors.primaryGreen.withOpacity(0.15)
                : AppColors.primaryGreen.withOpacity(0.08),
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.screenInset,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    'Профайл',
                    style: AppTypography.h3.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => HapticFeedback.lightImpact(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: AppSpacing.borderRadiusMd,
                        boxShadow: AppShadows.sm(isDark: isDark),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        size: 20,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.heroGradient,
                      boxShadow: profile.isOnline
                          ? AppShadows.glow(AppColors.primaryGreen)
                          : AppShadows.md(isDark: isDark),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      ),
                      child: profile.profileImageUrl != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: profile.profileImageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _buildAvatarPlaceholder(isDark),
                                errorWidget: (context, url, error) => _buildAvatarPlaceholder(isDark),
                              ),
                            )
                          : _buildAvatarPlaceholder(isDark),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        driverProvider.toggleOnlineStatus();
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: profile.isOnline
                              ? AppColors.primaryGreen
                              : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.darkCard : AppColors.lightCard,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          profile.isOnline ? Icons.check : Icons.close,
                          size: 14,
                          color: profile.isOnline
                              ? Colors.white
                              : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                profile.name,
                style: AppTypography.h2.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppUtils.formatPhoneNumber(profile.phone),
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              StatusChip(
                label: profile.isOnline ? 'Онлайн' : 'Оффлайн',
                type: profile.isOnline ? StatusType.success : StatusType.neutral,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.person_rounded,
        size: 48,
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, DriverProvider driverProvider, bool isDark) {
    final profile = driverProvider.profile!;

    return Padding(
      padding: AppSpacing.screenInset,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_shipping_outlined,
              label: 'Хүргэлт',
              value: '${profile.totalDeliveries}',
              color: AppColors.primaryGreen,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatCard(
              icon: Icons.star_rounded,
              label: 'Үнэлгээ',
              value: profile.rating.toStringAsFixed(1),
              color: Colors.amber,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatCard(
              icon: Icons.reviews_outlined,
              label: 'Сэтгэгдэл',
              value: '${profile.totalReviews}',
              color: AppColors.info,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: AppShadows.sm(isDark: isDark),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, bool isDark) {
    return Padding(
      padding: AppSpacing.screenInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Тохиргоо',
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Consumer<RatingProvider>(
            builder: (context, ratingProvider, child) {
              final subtitleText = ratingProvider.ratings != null
                  ? '${ratingProvider.averageRating.toStringAsFixed(1)} од • ${ratingProvider.totalReviews} сэтгэгдэл'
                  : 'Дэлгэрэнгүй харах';
              return _buildSettingsCard(
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                title: 'Миний үнэлгээ',
                subtitle: subtitleText,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RatingDetailPage()),
                  );
                },
                isDark: isDark,
              );
            },
          ),
          _buildSettingsCard(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.primaryGreen,
            title: 'Орлого татах',
            subtitle: 'Банкны данс руу шилжүүлэх',
            onTap: () => HapticFeedback.lightImpact(),
            isDark: isDark,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildThemeToggleCard(
                isDarkMode: themeProvider.isDarkMode,
                onToggle: () {
                  HapticFeedback.mediumImpact();
                  themeProvider.toggleTheme();
                },
                isDark: isDark,
              );
            },
          ),
          _buildSettingsCard(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.info,
            title: 'Тусламж',
            subtitle: 'Түгээмэл асуултууд',
            onTap: () => HapticFeedback.lightImpact(),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: AppShadows.xs(isDark: isDark),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggleCard({
    required bool isDarkMode,
    required VoidCallback onToggle,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: AppShadows.xs(isDark: isDark),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.indigo.withOpacity(0.15)
                    : Colors.amber.withOpacity(0.15),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(
                isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDarkMode ? Colors.indigo : Colors.amber,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Харанхуй горим',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    isDarkMode ? 'Идэвхтэй' : 'Идэвхгүй',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDarkMode,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.primaryGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, DriverProvider driverProvider, bool isDark) {
    final profile = driverProvider.profile!;

    return Padding(
      padding: AppSpacing.screenInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Тээврийн хэрэгсэл',
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark
                      ? AppColors.primaryGreen.withOpacity(0.15)
                      : AppColors.primaryGreen.withOpacity(0.08),
                  isDark
                      ? AppColors.primaryGreen.withOpacity(0.05)
                      : AppColors.primaryGreen.withOpacity(0.02),
                ],
              ),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: isDark
                    ? AppColors.primaryGreen.withOpacity(0.2)
                    : AppColors.primaryGreen.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: AppSpacing.borderRadiusMd,
                    boxShadow: AppShadows.sm(isDark: isDark),
                  ),
                  child: const Icon(
                    Icons.two_wheeler_outlined,
                    size: 32,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.vehicleType ?? 'Мотоцикл',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        profile.vehicleNumber,
                        style: AppTypography.h3.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, bool isDark) {
    return Padding(
      padding: AppSpacing.screenInset,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          AnimatedButton(
            label: 'Гарах',
            onPressed: () => _showLogoutConfirmation(context, isDark),
            variant: AnimatedButtonVariant.danger,
            size: AnimatedButtonSize.large,
            icon: Icons.logout_rounded,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isDark) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 32),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Гарах уу?',
              style: AppTypography.h3.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Та системээс гарахдаа итгэлтэй байна уу?',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: AnimatedButton(
                    label: 'Үгүй',
                    onPressed: () => Navigator.pop(context),
                    variant: AnimatedButtonVariant.secondary,
                    size: AnimatedButtonSize.large,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AnimatedButton(
                    label: 'Тийм',
                    onPressed: () => Navigator.pop(context),
                    variant: AnimatedButtonVariant.danger,
                    size: AnimatedButtonSize.large,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
