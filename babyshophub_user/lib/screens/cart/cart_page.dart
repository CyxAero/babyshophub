import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:BabyShopHub/widgets/custom_appbar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        height: 100,
        title: "Your Cart",
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side:
                        BorderSide(color: Theme.of(context).colorScheme.black2),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Name"),
                      Text("Price: \$10.00"),
                      SizedBox(height: 8),
                      Text("Quantity: 1"),
                      SizedBox(height: 8),
                      Text("Subtotal: \$10.00"),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 32),
            itemCount: 5,
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1.5, color: Colors.grey[600]),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Checkout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.white1,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
