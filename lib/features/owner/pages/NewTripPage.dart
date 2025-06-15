// pages/NewTripPage.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class NewTripPage extends StatefulWidget {
  const NewTripPage({super.key});

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController availableNumberController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  List<XFile> imageFiles = [];

  final String token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJtb2hhbWVkYXphbHk3NzJAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiI4ZTA0OTA5NS01NzY4LTQyN2QtYWNmNy02NjU0ZGMxMmFlMGYiLCJqdGkiOiIyMmZkZGY3Mi04ODczLTRjNzEtYjAwMi0wZmNmZjRkYTg1MWEiLCJVc2VyVHlwZSI6Ik93bmVyIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiT3duZXIiLCJleHAiOjE3NDkzOTg2NzUsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NDY5NTAiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjU1NTU1In0._8aSMXMaFmrw5wU1SjY2ybGnnqNA0znKNEe0_p9-xmc";

  String? selectedCategory;
  final List<String> categories = [
    "Leisure Tourism",
    "Cultural & Historical Tourism",
    "Medical Tourism",
    "Adventure & Eco Tourism",
    "Shopping Tourism",
    "Religious Tourism",
    "Business & MICE Tourism",
  ];

  Future<void> pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        imageFiles = pickedImages;
      });
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      controller.text = selectedDate.toIso8601String();
    }
  }

  Future<void> sendTripToServer() async {
    final uri = Uri.parse('http://20.74.208.111:5260/api/Owners/AddDestinationWithImages');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = token;
    request.headers['accept'] = '*/*';

    request.fields['Name'] = nameController.text;
    request.fields['Description'] = descriptionController.text;
    request.fields['Location'] = locationController.text;
    request.fields['Category'] = selectedCategory ?? '';
    request.fields['AvailableNumber'] = int.parse(availableNumberController.text).toString();
    request.fields['StartDate'] = startDateController.text.endsWith('Z') 
        ? startDateController.text 
        : '${startDateController.text}Z';
    request.fields['EndDate'] = endDateController.text.endsWith('Z') 
        ? endDateController.text 
        : '${endDateController.text}Z';
    request.fields['Discount'] = (discountController.text.isEmpty 
        ? 0.0 
        : double.parse(discountController.text)).toString();
    request.fields['Cost'] = double.parse(costController.text).toString();

    List<String> failedImages = [];
    for (var xfile in imageFiles) {
      final file = File(xfile.path);
      if (await file.exists()) {
        final multipartFile = await http.MultipartFile.fromPath(
          'ImageData',
          xfile.path,
          contentType: MediaType('image', xfile.path.split('.').last),
        );
        request.files.add(multipartFile);
      } else {
        failedImages.add(xfile.path);
      }
    }

    if (failedImages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Skipping unavailable images: ${failedImages.join(', ')}")),
      );
    }

    if (request.files.isEmpty && imageFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid images to upload")),
      );
      return;
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(responseBody);
      final newTrip = {
        'title': nameController.text,
        'location': locationController.text,
        'description': descriptionController.text,
        'category': selectedCategory,
        'cost': double.parse(costController.text),
        'availableNumber': int.parse(availableNumberController.text),
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'discount': discountController.text.isEmpty ? 0.0 : double.parse(discountController.text),
        'imageData': List<String>.from(responseData['imageUrls'] ?? []),
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip added successfully")),
      );
      Navigator.pop(context, newTrip);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add trip. Status: ${response.statusCode}, Body: $responseBody")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Trip"),
        backgroundColor: const Color.fromARGB(255, 101, 130, 105),
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTextField("Name", nameController),
                buildTextField("Description", descriptionController),
                buildTextField("Location", locationController),
                buildTextField("Available Number", availableNumberController,
                    keyboardType: TextInputType.number),
                buildTextField("Cost", costController,
                    keyboardType: TextInputType.number),
                buildTextField("Discount", discountController,
                    keyboardType: TextInputType.number),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(startDateController),
                        child: buildTextField("Start Date", startDateController,
                            enabled: false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(endDateController),
                        child: buildTextField("End Date", endDateController,
                            enabled: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Category:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: const Text("Select a category"),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select a category";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (imageFiles.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageFiles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.file(
                            File(imageFiles[index].path),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("Image not available"),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Text("No images selected"),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: pickMultipleImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Select Multiple Images"),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendTripToServer();
                          }
                        },
                        child: const Text("Add Trip"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType = TextInputType.text, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          if (label == "Available Number" || label == "Cost" || label == "Discount") {
            if (double.tryParse(value) == null) {
              return "Please enter a valid number for $label";
            }
          }
          return null;
        },
      ),
    );
  }
}