import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AddAddressSheet extends StatefulWidget {
  const AddAddressSheet({super.key});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Form(
              child: Column(
                children: [
                  _buildTextField(
                    "Name",
                    icon: const Icon(UniconsLine.user),
                  ),
                  _buildTextField(
                    "Phone Number",
                    icon: const Icon(UniconsLine.phone),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Street",
                          icon: const Icon(UniconsLine.sign_alt),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          "City",
                          icon: const Icon(UniconsLine.location_arrow_alt),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "State",
                          icon: const Icon(UniconsLine.map),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          "Postal Code",
                          icon: const Icon(UniconsLine.mailbox),
                        ),
                      ),
                    ],
                  ),
                  _buildTextField(
                    "Country",
                    icon: const Icon(UniconsLine.globe),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  // *MARK: Header
  Widget _buildHeader() {
    return Column(
      children: [
        AppBar(
          title: Text(
            "Add Address",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 30,
        ),
        const SizedBox(height: 8),
        Divider(height: 1.5, color: Colors.grey[600]),
      ],
    );
  }

  // *TextField widgets
  Widget _buildTextField(
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    Icon? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        // controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withAlpha(200),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // *MARK: Bottom Button
  Widget _buildBottomButton() {
    return Column(
      children: [
        Divider(height: 1.5, color: Colors.grey[600]),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? _addAddress : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Add Address',
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

  void _addAddress() {
    // Add address logic here
  }
}