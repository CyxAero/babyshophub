import 'package:BabyShopHub/screens/user/add_new_address_sheet.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  // *MARK: Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(title: "Addresses", height: 60),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // *show add address bottom sheet
          _showAddressBottomSheet(context);
        },
        child: const Icon(UniconsLine.plus, size: 32),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              _buildAddressCard(context, false),
              _buildAddressCard(context, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, bool isDefault) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? isDefault
                ? Colors.grey[800]!.withOpacity(0.7)
                : Colors.grey[800]!.withOpacity(0.2)
            : isDefault
                ? const Color(0xFFF2F7EB)
                : const Color(0xFFF2F7EB).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 6,
            child: isDefault
                ? const Icon(UniconsLine.check)
                : const SizedBox.shrink(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "John Smith",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Opacity(
                opacity: 0.7,
                child: Text(
                  "(+234) 803 278 2389",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "23 Imaginary Road, South Lane, Maine, 102883, BD",
                style: Theme.of(context).textTheme.titleMedium,
                softWrap: true,
              )
            ],
          )
        ],
      ),
    );
  }

  // *MARK: Show addresses bottom sheet
  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      showDragHandle: true,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddAddressSheet(),
      ),
    );
  }
}
