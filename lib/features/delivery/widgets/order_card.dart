import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/utils.dart';
import '../models/order_model.dart';
import '../pages/order_detail_page.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onAccept;

  const OrderCard({
    super.key,
    required this.order,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: InkWell(
        onTap: order.status == OrderStatus.inProgress
            ? () {
                // Navigate to order detail page for in-progress orders
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailPage(order: order),
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distance and Time
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.successColor,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    AppUtils.formatDistance(order.distanceInKm),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    order.time,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Address
              Text(
                order.address,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Price and Accept Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppUtils.formatCurrency(order.price),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (onAccept != null && order.status == OrderStatus.available)
                    ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingL,
                          vertical: AppTheme.spacingS,
                        ),
                      ),
                      child: const Text('Хүлээн авах'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
