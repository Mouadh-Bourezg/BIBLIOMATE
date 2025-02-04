import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'components/bottomBar.dart';
import 'styles.dart';
import 'services/documentServices.dart'; // Import the DocumentService
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class uploadDocumentPage extends StatefulWidget {
  @override
  _uploadDocumentPageState createState() => _uploadDocumentPageState();
}

class _uploadDocumentPageState extends State<uploadDocumentPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  File? _uploadedImageFile; // For the image file
  File? _uploadedPdfFile; // For the PDF file
  int _currentIndex = 2;
  bool _isUploadPressed = false;
  bool _isSubmitPressed = false;
  bool _isCategoryExpanded = false;
  final List _categories = [
    "Software Engineering",
    "Data Science",
    "Mathematics",
    "Physics",
  ];

  // Define the new color palette
  final Color _backgroundColor = Color(0xFFF5F7FA); // #f5f7fa
  final Color _primaryColor = Color(0xFF207BFF); // #207bff
  final Color _accentColor = Color(0xFF4EA5FF); // #4ea5ff

  // Initialize DocumentService
  late final DocumentService _documentService;

  @override
  void initState() {
    super.initState();
    // Initialize Supabase client and DocumentService
    _documentService = DocumentService(Supabase.instance.client);
  }

  void _pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Restrict to image files
    );

    if (result != null) {
      setState(() {
        _uploadedImageFile = File(result.files.single.path!); // Store the file
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image selected: ${result.files.single.name}"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image selected."),
        ),
      );
    }
  }

  void _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files
    );

    if (result != null) {
      setState(() {
        _uploadedPdfFile = File(result.files.single.path!); // Store the file
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PDF selected: ${result.files.single.name}"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No PDF selected."),
        ),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_uploadedPdfFile == null || _uploadedImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please upload both an image and a PDF document."),
          ),
        );
        return;
      }

      try {
        // Insert the document using DocumentService
        await _documentService.insertDocument(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageFile: _uploadedImageFile!,
          pdfFile: _uploadedPdfFile!,
          uploaderId: Supabase.instance.client.auth.currentUser?.id, // Replace with the actual user ID
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Document submitted successfully!"),
          ),
        );

        // Clear the form after submission
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategory = null;
          _uploadedImageFile = null;
          _uploadedPdfFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error submitting document: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Header
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  "Upload Document",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Add Document Title",
                            hintText: "Enter document title",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.grey),
                            floatingLabelStyle:
                            TextStyle(color: _primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a title.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Category Dropdown
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isCategoryExpanded =
                                !_isCategoryExpanded;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedCategory ?? 'Select Category',
                                    style: TextStyle(
                                      color: _selectedCategory == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    _isCategoryExpanded
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: _primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: _isCategoryExpanded
                                ? _categories.length * 50.0
                                : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                children: _categories
                                    .map((category) => RadioListTile(
                                  title: Text(category),
                                  value: category,
                                  groupValue: _selectedCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                      _isCategoryExpanded = false;
                                    });
                                  },
                                ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // Description Field
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "Add Description",
                            hintText: "Enter description",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.grey),
                            floatingLabelStyle:
                            TextStyle(color: _primaryColor),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a description.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Image Upload Button
                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => _isUploadPressed = true),
                      onTapUp: (_) {
                        setState(() => _isUploadPressed = false);
                        _pickImageFile();
                      },
                      child: AnimatedScale(
                        scale: _isUploadPressed ? 0.95 : 1.0,
                        duration: Duration(milliseconds: 100),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.upload_file),
                          label: Text(
                            _uploadedImageFile == null
                                ? "Upload Image"
                                : "Image Selected: ${_uploadedImageFile!.path.split('/').last}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: null, // Handled by GestureDetector
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // PDF Upload Button
                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => _isUploadPressed = true),
                      onTapUp: (_) {
                        setState(() => _isUploadPressed = false);
                        _pickPdfFile();
                      },
                      child: AnimatedScale(
                        scale: _isUploadPressed ? 0.95 : 1.0,
                        duration: Duration(milliseconds: 100),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.upload_file),
                          label: Text(
                            _uploadedPdfFile == null
                                ? "Upload PDF"
                                : "PDF Selected: ${_uploadedPdfFile!.path.split('/').last}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: null, // Handled by GestureDetector
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Submit Button
                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => _isSubmitPressed = true),
                      onTapUp: (_) {
                        setState(() => _isSubmitPressed = false);
                        _submitForm();
                      },
                      child: AnimatedScale(
                        scale: _isSubmitPressed ? 0.95 : 1.0,
                        duration: Duration(milliseconds: 100),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.send),
                          label: Text("SUBMIT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: null, // Handled by GestureDetector
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}