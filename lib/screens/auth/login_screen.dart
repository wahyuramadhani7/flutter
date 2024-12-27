// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/register_screen.dart';

class LoginScreen extends StatelessWidget {
 const LoginScreen({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0,
     ),
     body: Padding(
       padding: const EdgeInsets.all(20.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text(
             'Login',
             style: TextStyle(
               color: Colors.white,
               fontSize: 32,
               fontWeight: FontWeight.bold,
             ),
           ),
           const SizedBox(height: 30),
           TextField(
             style: const TextStyle(color: Colors.white),
             decoration: InputDecoration(
               hintText: 'Enter Username/Email',
               hintStyle: TextStyle(color: Colors.grey[600]),
               filled: true,
               fillColor: Colors.grey[900],
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(8),
                 borderSide: BorderSide.none,
               ),
             ),
           ),
           const SizedBox(height: 20),
           TextField(
             obscureText: true,
             style: const TextStyle(color: Colors.white),
             decoration: InputDecoration(
               hintText: 'Enter Password',
               hintStyle: TextStyle(color: Colors.grey[600]),
               filled: true,
               fillColor: Colors.grey[900],
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(8),
                 borderSide: BorderSide.none,
               ),
               suffixIcon: Icon(Icons.visibility_off, color: Colors.grey[600]),
             ),
           ),
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
             child: const Text('Login'),
           ),
           const SizedBox(height: 20),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text(
                 'No account? ',
                 style: TextStyle(color: Colors.white),
               ),
               TextButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const RegisterScreen()),
                   );
                 },
                 child: const Text(
                   'Register here',
                   style: TextStyle(color: Color(0xFF006D5B)),
                 ),
               )
             ],
           ),
         ],
       ),
     ),
   );
 }
}