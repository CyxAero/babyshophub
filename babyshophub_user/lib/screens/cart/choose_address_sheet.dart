import 'package:BabyShopHub/models/order_model.dart';
import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/providers/cart_provider.dart';
import 'package:BabyShopHub/providers/user_provider.dart';
import 'package:BabyShopHub/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressSelectionSheet extends StatelessWidget {
  const AddressSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final addresses = userProvider.user?.addresses ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Shipping Address',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return AddressCard(
                  address: addresses[index],
                  onTap: () =>
                      _handleAddressSelection(context, addresses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddressSelection(BuildContext context, Address address) {
    Navigator.pop(context); // Close the bottom sheet
    _showConfirmationDialog(context, address);
  }

  void _showConfirmationDialog(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: Text(
              'Ship to: ${address.toMap()}\n\nProceed with payment?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => _processPayment(context, address),
            ),
          ],
        );
      },
    );
  }

  void _processPayment(BuildContext context, Address address) async {
    Navigator.pop(context); // Close the confirmation dialog

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderService = OrderService();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Process mock payment
      bool paymentSuccess = await MockPaymentService.processPayment(
        amount: cartProvider.totalAmount,
      );

      if (paymentSuccess) {
        // Create order
        final order = OrderModel(
          userId: userProvider.user!.userId,
          items: cartProvider.items.values.toList(),
          total: cartProvider.totalAmount,
          shippingAddress: address,
          status: OrderStatus.processing,
          createdAt: DateTime.now(),
        );

        await orderService.createOrder(order);

        // Update product stock
        await orderService
            .updateProductStock(cartProvider.items.values.toList());

        // Clear cart
        await cartProvider.clear();

        // Hide loading indicator
        Navigator.of(context).pop();

        // Show success message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully!')),
        );
        Navigator.of(context).pushReplacementNamed('/order-confirmation');
      } else {
        // Hide loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed. Please try again.')),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onTap;

  const AddressCard({super.key, required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Card(
      child: ListTile(
        title: Text(user!.email),
        subtitle: Text(address.toMap() as String),
        onTap: onTap,
      ),
    );
  }
}