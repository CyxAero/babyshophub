import 'dart:io';

import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductBottomSheet extends StatefulWidget {
  const AddProductBottomSheet({super.key});

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _images = []; // Initialize the _images list
  final List<String> _categories = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  bool get _isFormValid =>
      _formKey.currentState?.validate() ??
      false && _images.isNotEmpty && _categories.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
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
                        maxLines: 3,
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
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AppBar(
          title: Text(
            'New Product',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        Divider(height: 1, color: Colors.grey[400]),
      ],
    );
  }

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
          fillColor: Theme.of(context).colorScheme.surface.withAlpha(223),
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
          top: 4,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _removeImage(image),
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
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.add_photo_alternate,
          size: 40,
          color: Colors.grey[600],
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
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._categories.map(
              (category) => Chip(
                labelPadding: const EdgeInsets.all(16),
                label: Text(category),
                onDeleted: () => _removeCategory(category),
              ),
            ),
          ],
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
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

  Widget _buildSaveButton() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _isFormValid ? _saveProduct : null,
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.titleMedium,
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

  void _saveProduct() {
    if (_formKey.currentState!.validate() &&
        _images.isNotEmpty &&
        _categories.isNotEmpty) {
      // TODO: Implement save logic
      Navigator.of(context).pop();
    }
  }
}
