import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String username;
  
  const ProfileScreen({
    super.key,
    required this.username,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isEditing = false;
  
  // Add controllers for all fields
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _selectedGender;
  String? _selectedZodiac;
  String? _selectedHoroscope;
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://676f7adfb353db80c322d0f3.mockapi.io/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        final user = users.firstWhere(
          (user) => user['username'] == widget.username,
          orElse: () => null,
        );

        if (mounted) {
          setState(() {
            userData = user;
            _aboutController.text = user?['about'] ?? '';
            _interestController.text = user?['interest'] ?? '';
            _displayNameController.text = user?['displayName'] ?? '';
            _birthdayController.text = user?['birthday'] ?? '';
            _heightController.text = user?['height'] ?? '';
            _weightController.text = user?['weight'] ?? '';
            _selectedGender = user?['gender'];
            _selectedZodiac = user?['zodiac'];
            _selectedHoroscope = user?['horoscope'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')),
        );
      }
    }
  }

  Future<void> _updateUserData() async {
    if (userData == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('https://676f7adfb353db80c322d0f3.mockapi.io/users/${userData!['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          ...userData!,
          'about': _aboutController.text,
          'interest': _interestController.text,
          'displayName': _displayNameController.text,
          'birthday': _birthdayController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'gender': _selectedGender,
          'zodiac': _selectedZodiac,
          'horoscope': _selectedHoroscope,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        await _fetchUserData();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isEditing = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage.path;
      });
      print('Selected image path: $_selectedImage');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? labelText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: const Color(0xFF262626),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hintText, style: TextStyle(color: Colors.grey[600])),
          isExpanded: true,
          dropdownColor: const Color(0xFF262626),
          style: const TextStyle(color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '@${widget.username}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          if (isEditing)
            TextButton(
              onPressed: _updateUserData,
              child: const Text(
                'Save & Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF262626),
                        borderRadius: BorderRadius.circular(10),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(File(_selectedImage!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 80,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userData?['displayName'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // About Section with Edit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isEditing)
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                          ),
                        if (isEditing)
                          TextButton(
                            onPressed: _updateUserData,
                            child: const Text(
                              'Save & Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (isEditing)
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A1A),
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Add image',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Expanded Edit Form
                    if (isEditing || userData?['about'] != null) ...[
                      if (!isEditing && userData?['about'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            userData!['about']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      if (isEditing) ...[
                        _buildTextField(
                          controller: _displayNameController,
                          hintText: 'Enter name',
                          labelText: 'Display name',
                        ),
                        _buildDropdownField(
                          hintText: 'Select Gender',
                          value: _selectedGender,
                          items: const ['Male', 'Female', 'Other'],
                          onChanged: (value) => setState(() => _selectedGender = value),
                        ),
                        _buildTextField(
                          controller: _birthdayController,
                          hintText: 'DD-MM-YYYY',
                          labelText: 'Birthday',
                        ),
                        _buildDropdownField(
                          hintText: 'Select Horoscope',
                          value: _selectedHoroscope,
                          items: const ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
                                     'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'],
                          onChanged: (value) => setState(() => _selectedHoroscope = value),
                        ),
                        _buildDropdownField(
                          hintText: 'Select Zodiac',
                          value: _selectedZodiac,
                          items: const ['Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake',
                                     'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig'],
                          onChanged: (value) => setState(() => _selectedZodiac = value),
                        ),
                        _buildTextField(
                          controller: _heightController,
                          hintText: 'Add height',
                          labelText: 'Height',
                        ),
                        _buildTextField(
                          controller: _weightController,
                          hintText: 'Add weight',
                          labelText: 'Weight',
                        ),
                        _buildTextField(
                          controller: _aboutController,
                          hintText: 'Add in your about...',
                          labelText: 'About',
                        ),
                      ],
                    ] else
                      Text(
                        'Add in your about to help others know you better',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Interest Section
                    const Text(
                      'Interest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isEditing)
                      _buildTextField(
                        controller: _interestController,
                        hintText: 'Add in your interests...',
                      )
                    else
                      Text(
                        userData?['interest'] ?? 'Add in your interest to find a better match',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _interestController.dispose();
    _displayNameController.dispose();
    _birthdayController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}