// pages/EditInformationPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EditInformationPage extends StatefulWidget {
  const EditInformationPage({super.key, required String name, required String email, required String phone, required String birthDate, required String gender, required String profilePicture});

  @override
  State<EditInformationPage> createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  File? _imageFile;
  final picker = ImagePicker();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  String? selectedGender;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor:const Color.fromARGB(255, 207, 221, 192),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a photo"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  bool _isEmailValid(String email) {
    RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }

  bool _isPhoneValid(String phone) {
    return phone.startsWith('+') && phone.length > 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 221, 192),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Edit Information', style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 70, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: InkWell(
                      onTap: _showImagePickerOptions,
                      child: const CircleAvatar(
                        backgroundColor:  Color.fromARGB(255, 101, 130, 105),
                        radius: 20,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildTextField("First Name", firstNameController),
              const SizedBox(height: 10),
              _buildTextField("Last Name", lastNameController),
              const SizedBox(height: 10),
              _buildTextField("User Name", userNameController),
              const SizedBox(height: 10),
              _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress, validator: (value) {
                if (!_isEmailValid(value!)) return "Enter a valid email";
                return null;
              }),
              const SizedBox(height: 10),
              _buildTextField("Phone Number", phoneController, keyboardType: TextInputType.phone, validator: (value) {
                if (!_isPhoneValid(value!)) return "Phone must start with '+'";
                return null;
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(birthDateController),
                      child: AbsorbPointer(
                        child: _buildTextField("Birth Date", birthDateController),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Gender",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                onChanged: (value) => setState(() => selectedGender = value),
                validator: (value) => value == null ? "Please select gender" : null,
              ),
              const SizedBox(height: 20),
            const SizedBox(height: 30),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 101, 130, 105),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      // اجمع البيانات
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String userName = userNameController.text;
      String email = emailController.text;
      String phone = phoneController.text;
      String birthDate = birthDateController.text;
      String gender = selectedGender ?? '';

      try {
        var response = await http.post(
          Uri.parse('http://192.168.43.191:5260/api/Owners'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": "$firstName $lastName",
            "description": userName,
            "location": phone,
            "category": gender,
            "avilableNumber": 0,
            "startDate": birthDate,
            "endtDate": birthDate,
            "cost": 0,
            "discount": 0
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context, {
            "firstName": firstName,
            "lastName": lastName,
            "userName": userName,
            "email": email,
            "phone": phone,
            "birthDate": birthDate,
            "gender": gender,
            "imagePath": _imageFile?.path
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send data to server')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  },
  child: const Text("Done", style: TextStyle(color: Colors.white, fontSize: 18)),
),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
