import 'dart:io';
import 'package:babyshophub_admin/models/category_model.dart';
import 'package:babyshophub_admin/models/product_model.dart';
import 'package:babyshophub_admin/services/product_service.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:babyshophub_admin/widgets/custom_snackbar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ImageItem {
  final File? file;
  final String? imageUrl;

  ImageItem({this.file, this.imageUrl});
}

class ProductBottomSheet extends StatefulWidget {
  final VoidCallback onProductAdded;
  final ProductModel? initialProduct;

  const ProductBottomSheet({
    super.key,
    required this.onProductAdded,
    this.initialProduct,
  });

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  // final List<XFile> _images = [];
  String formTitle = "New Product";
  final Set<ImageItem> _images = {};
  final Set<CategoryModel> _selectedCategories = {};
  final Set<CategoryModel> _allCategories = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();

  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.initialProduct != null) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    formTitle = "Edit Product";
    _nameController.text = widget.initialProduct!.name;
    _descriptionController.text = widget.initialProduct!.description;
    _priceController.text = widget.initialProduct!.price.toString();
    _stockController.text = widget.initialProduct!.stock.toString();
    // _images.addAll(
    //     widget.initialProduct!.images.map((url) => XFile(url)).toList());
    _images.addAll(widget.initialProduct!.images
        .map((url) => ImageItem(imageUrl: url))
        .toList());
    _loadSelectedCategories(widget.initialProduct!.categories);
  }

  Future<void> _loadCategories() async {
    final productService = ProductService();
    final categories = await productService.getCategories();
    setState(() {
      _allCategories.addAll(categories);
    });
  }

  void _loadSelectedCategories(Set<String> categoryNames) async {
    final productService = ProductService();
    final allCategories = await productService.getCategories();
    setState(() {
      _selectedCategories.addAll(
        allCategories
            .where((category) => categoryNames.contains(category.name)),
      );
    });
  }

  // bool get _isFormValid =>
  //     (_formKey.currentState?.validate() ?? false) &&
  //     _images.isNotEmpty &&
  //     _selectedCategories.isNotEmpty;

  bool get _isFormValid =>
      _isEdited &&
      (_formKey.currentState?.validate() ?? false) &&
      _images.isNotEmpty &&
      _selectedCategories.isNotEmpty;

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Name', _nameController),
                    _buildTextField('Description', _descriptionController,
                        maxLines: 4),
                    _buildImagesSection(),
                    _buildCategoriesSection(),
                    _buildTextField('Stock', _stockController,
                        keyboardType: TextInputType.number),
                    _buildTextField(
                      'Price',
                      _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
            formTitle,
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

  // MARK: Images Section
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
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  // MARK: Image Preview
  Widget _buildImagePreview(ImageItem image) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: image.file != null
                  ? FileImage(image.file!)
                  : NetworkImage(image.imageUrl!) as ImageProvider,
              fit: BoxFit.cover,
            ),
            // image: DecorationImage(
            //   image: FileImage(File(image.path)),
            //   fit: BoxFit.cover,
            // ),
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
                color: Theme.of(context).colorScheme.error.withOpacity(0.8),
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
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // MARK: Categories Section
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
            ..._selectedCategories.map(
              (category) => Chip(
                label: Text(category.name),
                onDeleted: () => _removeCategory(category),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildCategoryInput(),
        if (_selectedCategories.isEmpty)
          Text(
            'Please add at least one category',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategoryInput() {
    return TypeAheadField<CategoryModel>(
      debounceDuration: const Duration(milliseconds: 300),
      suggestionsCallback: (pattern) async {
        return _allCategories
            .where((category) =>
                category.name.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, CategoryModel suggestion) {
        return ListTile(
          title: Text(suggestion.name),
        );
      },
      emptyBuilder: (context) => ListTile(
        title: Text('Create new category "${_newCategoryController.text}"'),
        onTap: () => _createAndAddNewCategory(_newCategoryController.text),
      ),
      onSelected: (CategoryModel suggestion) {
        _addCategory(suggestion);
      },
      builder: (context, textEditingController, focusNode) {
        return TextField(
          controller: _newCategoryController,
          focusNode: _categoryFocusNode,
          decoration: InputDecoration(
            labelText: 'Add new category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withAlpha(200),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              _categoryFocusNode.requestFocus();
            }
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _createAndAddNewCategory(value);
            }
          },
        );
      },
    );
  }

  // MARK: Save Button
  Widget _buildSaveButton() {
    return Column(
      children: [
        Divider(height: 1.5, color: Colors.grey[600]),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid ? _saveProduct : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(24),
                // ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // MARK: Image Picker
  Future<void> _addImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        _images.addAll(pickedImages
            .map((xFile) => ImageItem(file: File(xFile.path)))
            .toList());
        _isEdited = true;
      });
    }
  }

  void _removeImage(ImageItem image) {
    setState(() {
      _images.remove(image);
      _isEdited = true;
    });
  }
  // Future<void> _addImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final List<XFile> images = await picker.pickMultiImage();

  //   if (images.isNotEmpty) {
  //     setState(() {
  //       _images.addAll(images);
  //     });
  //   }
  // }

  // void _removeImage(XFile image) {
  //   setState(() {
  //     _images.remove(image);
  //   });
  // }

  // MARK: Category Management
  void _addCategory(CategoryModel category) {
    if (!_selectedCategories.contains(category)) {
      setState(() {
        _selectedCategories.add(category);
        _newCategoryController.clear();
      });
    }
  }

  void _removeCategory(CategoryModel category) {
    setState(() {
      _selectedCategories.remove(category);
    });
  }

  Future<void> _createAndAddNewCategory(String categoryName) async {
    final productService = ProductService();
    final newCategory = CategoryModel(categoryId: '', name: categoryName);

    try {
      await productService.addCategory(newCategory);
      setState(() {
        _allCategories.add(newCategory);
        _selectedCategories.add(newCategory);
        _newCategoryController.clear();
      });
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showCustomSnackbar(
          context,
          'Failed to add category. Please try again.',
          true,
        );
      }
      Logger().e("Failed to add category: $e");
    }
  }

  // MARK: Save Product
  void _saveProduct() async {
    final productService = ProductService();
    final Set<String> imageUrls = {};

    for (var image in _images) {
      if (image.file != null) {
        try {
          final url = await productService.uploadImage(image.file!);
          imageUrls.add(url);
        } catch (e) {
          Logger().e("Failed to upload image: $e");
          if (!mounted) return;
          CustomSnackBar.showCustomSnackbar(
            context,
            'Failed to upload image. Please try again.',
            true,
          );
          return;
        }
      } else if (image.imageUrl != null) {
        imageUrls.add(image.imageUrl!);
      }
    }

    // for (var image in _images) {
    //   try {
    //     final url = await productService.uploadImage(File(image.path));
    //     imageUrls.add(url);
    //   } catch (e) {
    //     Logger().e("Failed to upload image: $e");
    //     if (!mounted) return;
    //     CustomSnackBar.showCustomSnackbar(
    //       context,
    //       'Failed to upload image. Please try again.',
    //       true,
    //     );
    //     return; // Exit the function if any image upload fails
    //   }
    // }

    // Log the price input for debugging
    Logger().d("Price input: ${_priceController.text}");

    // Trim and sanitize the price input
    String priceInput = _priceController.text.trim();
    double? parsedPrice = double.tryParse(priceInput);

    if (parsedPrice == null && mounted) {
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
      price: parsedPrice!,
      images: imageUrls,
      categories: _selectedCategories.map((c) => c.name).toSet(),
      stock: int.tryParse(_stockController.text) ?? 0,
    );

    try {
      await productService.addProduct(product);
      widget.onProductAdded(); // Trigger a refresh
      if (!mounted) return;
      CustomSnackBar.showCustomSnackbar(
        context,
        'Product added successfully!',
        false,
      );
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      Logger().e("Failed to add product: $e");
      if (!mounted) return;
      CustomSnackBar.showCustomSnackbar(
        context,
        'Failed to add product. Please try again.',
        true,
      );
    }
  }
}
