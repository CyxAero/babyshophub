import 'package:BabyShopHub/models/cart_item_model.dart';
import 'package:BabyShopHub/providers/cart_provider.dart';
import 'package:BabyShopHub/screens/cart/checkout_page.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:BabyShopHub/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(
        height: 60,
        title: "Your cart",
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final cartItem = cart.items.values.toList()[index];
                        return _buildCartItemCard(context, cartItem, cart);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomSection(context, cart),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartItem cartItem,
    CartProvider cart,
  ) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cartItem.product.images.first,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        context,
                        icon: UniconsLine.minus,
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            cart.removeSingleItem(cartItem.product.productId);
                          }
                        },
                      ),
                      // const SizedBox(width: 4),

                      // *Quantity input
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${cartItem.quantity}',
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // const SizedBox(width: 4),
                      _buildQuantityButton(
                        context,
                        icon: UniconsLine.plus,
                        onPressed: () {
                          if (cartItem.quantity < cartItem.product.stock) {
                            cart.addItem(cartItem.product, cartItem.quantity);
                          }
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            _showRemoveDialog(context, cartItem, cart),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        iconSize: 20,
        backgroundColor: icon == UniconsLine.minus
            ? Theme.of(context).colorScheme.error.withOpacity(0.1)
            : Theme.of(context).colorScheme.lightGreen.withOpacity(0.1),
      ),
      color: icon == UniconsLine.minus
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.lightGreen,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }

  Widget _buildBottomSection(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                'Checkout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(
      BuildContext context, CartItem cartItem, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text(
          'Are you sure you want to remove this item from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.black2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              cart.removeItem(cartItem.product.productId);
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Remove',
              style: TextStyle(
                color: Theme.of(context).colorScheme.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
