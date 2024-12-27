// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
 const RegisterScreen({Key? key}) : super(key: key);

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
     ),
     body: Padding(
       padding: const EdgeInsets.all(20.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text(
             'Register',
             style: TextStyle(
               color: Colors.white,
               fontSize: 32,
               fontWeight: FontWeight.bold,
             ),
           ),
           const SizedBox(height: 30),
           _buildTextField('Enter Email'),
           const SizedBox(height: 15),
           _buildTextField('Create Username'),
           const SizedBox(height: 15),
           _buildTextField('Create Password', isPassword: true),
           const SizedBox(height: 15),
           _buildTextField('Confirm Password', isPassword: true),
           const SizedBox(height: 30),
           ElevatedButton(
             onPressed: () {},
             style: ElevatedButton.styleFrom(
               backgroundColor: const Color(0xFF006D5B),
               minimumSize: const Size(double.infinity, 50),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
               ),
             ),
             child: const Text('Register'),
           ),
           const SizedBox(height: 20),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text(
                 'Have an account? ',
                 style: TextStyle(color: Colors.white),
               ),
               TextButton(
                 onPressed: () => Navigator.pushNamed(context, '/login'),
                 child: const Text(
                   'Login here',
                   style: TextStyle(color: Color(0xFF006D5B)),
                 ),
               ),
             ],
           ),
         ],
       ),
     ),
   );
 }

 Widget _buildTextField(String hint, {bool isPassword = false}) {
   return TextField(
     obscureText: isPassword,
     style: const TextStyle(color: Colors.white),
     decoration: InputDecoration(
       hintText: hint,
       hintStyle: TextStyle(color: Colors.grey[600]),
       filled: true,
       fillColor: Colors.grey[900],
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(8),
         borderSide: BorderSide.none,
       ),
       suffixIcon: isPassword
           ? Icon(Icons.visibility_off, color: Colors.grey[600])
           : null,
     ),
   );
 }
}