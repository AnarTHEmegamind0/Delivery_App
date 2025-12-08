import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_theme.dart';
import '../../../../features/customer/models/customer_order_model.dart';

class RatingBottomSheet extends StatefulWidget {
  final CustomerDriverInfo driver;

  const RatingBottomSheet({
    super.key, 
    required this.driver,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Жолоочид үнэлгээ өгнө үү',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          
          // Driver Avatar
           Container(
             width: 80,
             height: 80,
             decoration: BoxDecoration(
               color: const Color(0xFF383838),
               shape: BoxShape.circle,
             ),
             child: const Icon(Icons.person, size: 40, color: Colors.grey),
           ),
           const SizedBox(height: 16),
           Text(
             widget.driver.name,
             style: GoogleFonts.inter(
               color: Colors.white,
               fontSize: 18,
               fontWeight: FontWeight.w600,
             ),
           ),
           Text(
             widget.driver.vehiclePlate,
             style: GoogleFonts.inter(
               color: Colors.grey,
               fontSize: 14,
             ),
           ),
           const SizedBox(height: 32),
           
           // Rating Stars
           Align(
             alignment: Alignment.centerLeft,
             child: Text('Үйлчилгээний чанар', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
           ),
           const SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: List.generate(5, (index) {
               return IconButton(
                 onPressed: () {
                   setState(() {
                     _selectedRating = index + 1;
                   });
                 },
                 icon: Icon(
                   index < _selectedRating ? Icons.star : Icons.star_border,
                   color: index < _selectedRating ? const Color(0xFFFFD600) : Colors.grey,
                   size: 32,
                 ),
                 padding: EdgeInsets.zero,
               );
             }),
           ),
           
           const SizedBox(height: 24),
           
           // Friendly scale (visual match)
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('Найрсаг байдал', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
               Row(
                 children: [
                   const Icon(Icons.sentiment_satisfied, color: AppTheme.primaryColor, size: 16),
                   const SizedBox(width: 4),
                   Text('3/5', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                 ],
               )
             ],
           ),
           const SizedBox(height: 8),
           LinearProgressIndicator(
             value: 0.6,
             backgroundColor: const Color(0xFF2C2C2C),
             valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
           ),

          const SizedBox(height: 24),
          
          // Comment Field
          TextField(
            controller: _commentController,
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Сэтгэгдэл үлдээх...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              counterText: '0/150',
              counterStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Үнэлгээ илгээгдлээ!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF383838), // Disabled look initially like screenshot, or active
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Илгээх',
                style: GoogleFonts.inter(
                  color: Colors.grey, // Screenshot shows dark button with grey text, implying inactive or dark theme active
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
