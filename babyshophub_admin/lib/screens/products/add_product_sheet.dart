import 'dart:io';
import 'package:babyshophub_admin/models/product_model.dart';
import 'package:babyshophub_admin/services/product_service.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:babyshophub_admin/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddProductBottomSheet extends StatefulWidget {
  final VoidCallback onProductAdded;
  final ProductModel? initialProduct;

  const AddProductBottomSheet({
    super.key,
    required this.onProductAdded,
    this.initialProduct,
  });

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _images = [];
  final List<String> _categories = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  initState() {
    super.initState();

    bool hasValues = widget.initialProduct != null;

    if (hasValues) {
      _nameController.text = widget.initialProduct!.name;
      _descriptionController.text = widget.initialProduct!.description;
      _priceController.text = widget.initialProduct!.price.toString();
      _stockController.text = widget.initialProduct!.stock.toString();

      _images.addAll(
          widget.initialProduct!.images.map((url) => XFile(url)).toList());
      _categories.addAll(widget.initialProduct!.categories);
    }
  }

  bool get _isFormValid =>
      (_formKey.currentState?.validate() ?? false) &&
      _images.isNotEmpty &&
      _categories.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Name', _nameController),
                    _buildTextField(
                      'Description',
                      _descriptionController,
                      maxLines: 4,
                    ),
                    _buildImagesSection(),
                    _buildCategoriesSection(),
                    _buildTextField(
                      'Stock',
                      _stockController,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      'Price',
                      _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildSaveButton(),
      ],
    );
  }

  // MARK: Header
  Widget _buildHeader() {
    return Column(
      children: [
        AppBar(
          title: Text(
            'New Product',
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

  // MARK: Text Field
  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
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

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._images.map((image) => _buildImagePreview(image)),
            _buildAddImageButton(),
          ],
        ),
        if (_images.isEmpty)
          Text(
            'Please add at least one image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.red,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  // MARK: Image Preview
  Widget _buildImagePreview(XFile image) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.beige,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(image.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: InkWell(
            onTap: () => _removeImage(image),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.red.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _addImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF0E3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.add_photo_alternate,
          size: 40,
          color: Theme.of(context).colorScheme.black1,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            ..._categories.map(
              (category) => Chip(
                // labelPadding: const EdgeInsets.all(2),
                label: Text(category),
                onDeleted: () => _removeCategory(category),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAddCategoryButton(),
        if (_categories.isEmpty)
          Text(
            'Please add at least one category',
            style: TextStyle(color: Theme.of(context).colorScheme.red),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAddCategoryButton() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surface.withAlpha(223),
        labelText: 'Add category',
      ),
      items: ['Toys and games', 'Furniture', 'Electronics', 'Clothing']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null && !_categories.contains(newValue)) {
          setState(() {
            _categories.add(newValue);
          });
        }
      },
    );
  }

  // MARK: Save Button
  Widget _buildSaveButton() {
    return Column(
      children: [
        Divider(height: 1.5, color: Colors.grey[600]),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.pastelBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _isFormValid ? _saveProduct : null,
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  void _removeImage(XFile image) {
    setState(() {
      _images.remove(image);
    });
  }

  void _removeCategory(String category) {
    setState(() {
      _categories.remove(category);
    });
  }

  // void _saveProduct() {
  //   if (_formKey.currentState!.validate() &&
  //       _images.isNotEmpty &&
  //       _categories.isNotEmpty) {
  //     // TODO: Implement save logic
  //     Navigator.of(context).pop();
  //   }
  // }

  // MARK: Save Product
  void _saveProduct() async {
    if (_formKey.currentState!.validate() &&
        _images.isNotEmpty &&
        _categories.isNotEmpty) {
      final productService = ProductService();
      final List<String> imageUrls = [];

      for (var image in _images) {
        try {
          final url = await productService.uploadImage(File(image.path));
          imageUrls.add(url);
        } catch (e) {
          Logger().e("Failed to upload image: $e");
          CustomSnackBar.showCustomSnackbar(
            context,
            'Failed to upload image. Please try again.',
            true,
          );
          return; // Exit the function if any image upload fails
        }
      }

      // Log the price input for debugging
      Logger().d("Price input: ${_priceController.text}");

      // Trim and sanitize the price input
      String priceInput = _priceController.text.trim();
      double? parsedPrice = double.tryParse(priceInput);

      if (parsedPrice == null) {
        CustomSnackBar.showCustomSnackbar(
          context,
          'Invalid price. Please enter a valid number.',
          true,
        );
        return; // Exit if the price is not valid
      }

      final product = ProductModel(
        productId: '',
        name: _nameController.text,
        description: _descriptionController.text,
        price: parsedPrice,
        images: imageUrls,
        categories: _categories,
        stock: int.tryParse(_stockController.text) ?? 0,
      );

      if (mounted) {
        try {
          await productService.addProduct(product);
          widget.onProductAdded(); // Trigger a refresh
          CustomSnackBar.showCustomSnackbar(
            context,
            'Product added successfully!',
            false,
          );
          Navigator.of(context).pop(); // Close the bottom sheet
        } catch (e) {
          Logger().e("Failed to add product: $e");
          CustomSnackBar.showCustomSnackbar(
            context,
            'Failed to add product. Please try again.',
            true,
          );
        }
      } else {
        CustomSnackBar.showCustomSnackbar(
          context,
          'Please complete all fields and add at least one image and category.',
          true,
        );
      }
    }
  }
}
