import 'package:BabyShopHub/theme/theme_provider.dart';
import 'package:BabyShopHub/widgets/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return RoundedContainer(
      width: double.infinity,
      showBorder: true,
      padding: const EdgeInsets.all(16),
      backgroundColor:
          selectedAddress ? Colors.blue.withOpacity(0.5) : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.blue
          : isDarkMode
              ? Colors.grey[800]!.withOpacity(0.7)
              : const Color(0xFFF2F7EB),
      isDarkMode: isDarkMode,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                selectedAddress ? Icons.done_rounded : null,
                color: selectedAddress
                    ? isDarkMode
                        ? Colors.white
                        : Colors.white
                    : null,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "John Doe",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge ,
              ),
              const SizedBox(height: 2,),
              const Text(
                "(+123) 456 7890",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2,),
              const Text(
                '82356 Timmy Coves, South Liana, Kaine, 87665, USA',
                softWrap: true,
              ),
              
            ],
          )
        ],
      ),
    );
  }
}
