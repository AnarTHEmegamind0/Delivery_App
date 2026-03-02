import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/design_system/design_system.dart';
import '../../../core/constants.dart';
import '../providers/driver_provider.dart';
import '../providers/earnings_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/pinterest_order_card.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({super.key});

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(_onScroll);

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EarningsProvider>().fetchEarnings();
      context.read<OrderProvider>().refreshAllOrders();
      context.read<DriverProvider>().fetchProfile();
    });
  }

  void _onScroll() {
    final isCollapsed = _scrollController.offset > 100;
    if (isCollapsed != _isHeaderCollapsed) {
      setState(() => _isHeaderCollapsed = isCollapsed);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Hero earnings section
              SliverToBoxAdapter(
                child: _buildHeroSection(isDark),
              ),

              // Quick stats row
              SliverToBoxAdapter(
                child: _buildQuickStats(isDark),
              ),

              // Sticky tab bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  tabBar: _buildTabBar(isDark),
                  isDark: isDark,
                ),
              ),
            ];
          },
          body: Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              return TabBarView(
                controller: _tabController,
                children: [
                  // Available Orders
                  _buildOrderList(
                    orderProvider.availableOrders,
                    orderProvider.isLoading,
                    showAcceptButton: true,
                    isDark: isDark,
                  ),

                  // In Progress Orders
                  _buildOrderList(
                    orderProvider.inProgressOrders,
                    orderProvider.isLoading,
                    isDark: isDark,
                  ),

                  // Completed Orders
                  _buildOrderList(
                    orderProvider.completedOrders,
                    orderProvider.isLoading,
                    isDark: isDark,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: AppShadows.glow(AppColors.primaryGreen),
      ),
      child: Consumer<EarningsProvider>(
        builder: (context, earningsProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Өнөөдрийн орлого',
                        style: AppTypography.label.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      earningsProvider.isLoading
                          ? ShimmerSkeleton.text(width: 150, height: 40)
                          : Text(
                              '₮${_formatNumber(earningsProvider.todayEarnings)}',
                              style: AppTypography.hero.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                  Consumer<DriverProvider>(
                    builder: (context, driverProvider, child) {
                      final isOnline = driverProvider.isOnline;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          driverProvider.toggleOnlineStatus();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.2),
                            borderRadius: AppSpacing.borderRadiusFull,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isOnline ? Colors.white : Colors.white54,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                isOnline ? 'Онлайн' : 'Оффлайн',
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Goal progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Өдрийн зорилго',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '${((earningsProvider.todayEarnings / 100000) * 100).clamp(0, 100).toInt()}%',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: AppSpacing.borderRadiusFull,
                    child: LinearProgressIndicator(
                      value: (earningsProvider.todayEarnings / 100000).clamp(0, 1),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      final parts = value.toStringAsFixed(0).split('');
      final buffer = StringBuffer();
      for (int i = 0; i < parts.length; i++) {
        if (i > 0 && (parts.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(parts[i]);
      }
      return buffer.toString();
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildQuickStats(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Боломжтой',
                  value: '${orderProvider.availableOrders.length}',
                  color: AppColors.primaryGreen,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'Хүргэж байна',
                  value: '${orderProvider.inProgressOrders.length}',
                  color: AppColors.info,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle_outline,
                  label: 'Дууссан',
                  value: '${orderProvider.completedOrders.length}',
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  Widget _buildTabBar(bool isDark) {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primaryGreen,
      unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      indicatorColor: AppColors.primaryGreen,
      indicatorWeight: 3,
      labelStyle: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTypography.label,
      tabs: const [
        Tab(text: 'Боломжтой'),
        Tab(text: 'Хүргэж байна'),
        Tab(text: 'Дууссан'),
      ],
    );
  }

  Widget _buildOrderList(
    List orders,
    bool isLoading, {
    bool showAcceptButton = false,
    required bool isDark,
  }) {
    if (isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: ShimmerOrderCard(),
        ),
      );
    }

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Захиалга байхгүй байна',
              style: AppTypography.bodyLarge.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OrderProvider>().refreshAllOrders(),
      color: AppColors.primaryGreen,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xxxl),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return PinterestOrderCard(
            order: order,
            index: index,
            onAccept: showAcceptButton
                ? () {
                    HapticFeedback.mediumImpact();
                    context.read<OrderProvider>().acceptOrder(order.id);
                  }
                : null,
          );
        },
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;
  final bool isDark;

  _StickyTabBarDelegate({required this.tabBar, required this.isDark});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
