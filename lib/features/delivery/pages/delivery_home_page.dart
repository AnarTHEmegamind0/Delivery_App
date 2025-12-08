import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/constants.dart';
import '../providers/driver_provider.dart';
import '../providers/earnings_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/earnings_display.dart';
import '../widgets/order_card.dart';
import '../widgets/status_toggle.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({super.key});

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EarningsProvider>().fetchEarnings();
      context.read<OrderProvider>().refreshAllOrders();
      context.read<DriverProvider>().fetchProfile();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Earnings Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppTheme.radiusXL),
                  bottomRight: Radius.circular(AppTheme.radiusXL),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  children: [
                    // Earnings Display
                    Consumer<EarningsProvider>(
                      builder: (context, earningsProvider, child) {
                        return EarningsDisplay(
                          amount: earningsProvider.dailyEarnings,
                          label: AppConstants.todayEarnings,
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Online Status Toggle
                    Consumer<DriverProvider>(
                      builder: (context, driverProvider, child) {
                        return StatusToggle(
                          isOnline: driverProvider.isOnline,
                          onChanged: (_) => driverProvider.toggleOnlineStatus(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Tabs
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: AppConstants.waiting),
                  Tab(text: AppConstants.inProgress),
                  Tab(text: AppConstants.completed),
                ],
              ),
            ),
            
            // Tab Views
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Available Orders
                      _buildOrderList(
                        orderProvider.availableOrders,
                        showAcceptButton: true,
                      ),
                      
                      // In Progress Orders
                      _buildOrderList(orderProvider.inProgressOrders),
                      
                      // Completed Orders
                      _buildOrderList(orderProvider.completedOrders),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List orders, {bool showAcceptButton = false}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Захиалга байхгүй байна',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OrderProvider>().refreshAllOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onAccept: showAcceptButton
                ? () => context.read<OrderProvider>().acceptOrder(order.id)
                : null,
          );
        },
      ),
    );
  }
}
