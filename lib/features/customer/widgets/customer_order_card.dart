import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/utils.dart'; // Ensure utils are exported/usable
import '../models/customer_order_model.dart';
import '../pages/customer_order_detail_page.dart';  // Will be created

class CustomerOrderCard extends StatelessWidget {
  final CustomerOrderModel order;
  final VoidCallback? onTap;

  const CustomerOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case CustomerOrderStatus.preparing:
        statusColor = Colors.orange;
        statusIcon = Icons.inventory_2_outlined; // Cube icon
        break;
      case CustomerOrderStatus.delivering:
        statusColor = AppTheme.primaryColor;
        statusIcon = Icons.access_time; // Clock icon
        break;
      case CustomerOrderStatus.completed:
        statusColor = Colors.grey;
        statusIcon = Icons.check_circle_outline;
        break;
      case CustomerOrderStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerOrderDetailPage(order: order),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.restaurantName,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      order.time,
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Items list
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${item.name}',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                )),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[800], height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      order.statusText,
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (order.driver != null && order.status == CustomerOrderStatus.delivering)
                       Padding(
                         padding: const EdgeInsets.only(left: 4),
                         child: Text(
                           '• ${order.driver!.name}',
                           style: GoogleFonts.inter(
                             color: Colors.grey,
                             fontSize: 14,
                           ),
                         ),
                       ),
                    const Spacer(),
                    Text(
                      AppUtils.formatCurrency(order.totalAmount),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                // Show "See details" button look-alike if designed (screenshot 1 has a button)
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF383838),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Дэлгэрэнгүй харах',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
