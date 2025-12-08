import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/utils.dart'; // Ensure utils are exported/usable
import '../models/customer_order_model.dart';
import 'package:url_launcher/url_launcher.dart'; // For calling driver
import '../widgets/rating_bottom_sheet.dart'; 

class CustomerOrderDetailPage extends StatelessWidget {
  final CustomerOrderModel order;

  const CustomerOrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Захиалгын дэлгэрэнгүй',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Status Header based on state
            if (order.status == CustomerOrderStatus.preparing)
              _buildPreparingHeader(context)
            else if (order.status == CustomerOrderStatus.delivering)
              _buildDriverCard(context),

            const SizedBox(height: 16),
            
            // Location Card (Always shown)
            _buildLocationCard(context),
            
            const SizedBox(height: 16),
            
            // Order Items & Summary
            _buildOrderSummaryCard(context),
            
            const SizedBox(height: 24),

            // Action Button (Rating if completed)
            if (order.status == CustomerOrderStatus.completed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => RatingBottomSheet(driver: order.driver!),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD600), // Yellow for rating
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        'Жолоочид үнэлгээ өгөх',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreparingHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Хүргэж байна', // The screenshot shows "Хүргэж байна" in green even for preparing? Or implies timeline. 
                // Screenshot 3 says "Хүргэж байна" (Delivering) in green title, but status text below says "Баталгаажсан Бэлтгэж байна Хүргэж байна".
                // And huge "15 минут" time.
                // Let's match the screenshot 3 logic: Title is the active stage color.
                style: GoogleFonts.inter(
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '15 минут',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Ойролцоогоор',
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Таалгатай хүлээнэ үү',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
          // Progress Bar
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF404040),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.66, // Simulating "Preparing" stage (2/3)
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Баталгаажсан', style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 10)),
              Text('Бэлтгэж байна', style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 10)),
              Text('Хүргэж байна', style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 10)), // Active
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context) {
    if (order.driver == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Таны жолооч',
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF383838),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.driver!.name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.directions_car, color: AppTheme.primaryColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          order.driver!.vehiclePlate,
                          style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFD600), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${order.driver!.rating}',
                          style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Call Button
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(Icons.call, color: Colors.white),
                  onPressed: () {
                     launchUrl(Uri.parse('tel:${order.driver!.phoneNumber}'));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 8),
              Text(
                'Хүргэх хаяг',
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Баянзүрх дүүрэг, 15-р хороо,\nЭнхтайваны өргөн чөлөө 24,\n5-р давхар, 512 тоот', // Mock address matching screenshot
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.restaurantName,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Items
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x',
                        style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppUtils.formatCurrency(item.price),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          )),
          
          Divider(color: Colors.grey[800], height: 24),
          
          // Totals
          _buildTotalRow('Дэд дүн', AppUtils.formatCurrency(order.subtotal)),
          const SizedBox(height: 8),
          _buildTotalRow('Хүргэлтийн төлбөр', AppUtils.formatCurrency(order.deliveryFee)),
          
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Нийт',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppUtils.formatCurrency(order.totalAmount), // Example shows formatted with green color
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'mnt', // Stylized mnt/tugrik sign
                    style: GoogleFonts.inter( // Using generic font as placeholder for symbol
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
