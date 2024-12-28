// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
 final TextEditingController _aboutController = TextEditingController();
 final TextEditingController _interestController = TextEditingController();

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

 @override
 void dispose() {
   _aboutController.dispose();
   _interestController.dispose();
   super.dispose();
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
         style: const TextStyle(
           color: Colors.white,
           fontSize: 16,
         ),
       ),
       centerTitle: true,
       actions: [
         if (isEditing)
           IconButton(
             icon: const Icon(Icons.save, color: Colors.white),
             onPressed: _updateUserData,
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
                   Container(
                     width: double.infinity,
                     height: 200,
                     decoration: BoxDecoration(
                       color: const Color(0xFF262626),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Center(
                       child: Text(
                         '@${widget.username}',
                         style: const TextStyle(
                           color: Colors.white,
                           fontSize: 16,
                         ),
                       ),
                     ),
                   ),
                   const SizedBox(height: 20),
                   
                   // About Section
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text(
                         'About',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       IconButton(
                         icon: Icon(
                           isEditing ? Icons.close : Icons.edit,
                           color: Colors.white,
                           size: 20,
                         ),
                         onPressed: () {
                           setState(() {
                             isEditing = !isEditing;
                             if (!isEditing) {
                               _aboutController.text = userData?['about'] ?? '';
                               _interestController.text = userData?['interest'] ?? '';
                             }
                           });
                         },
                       ),
                     ],
                   ),
                   if (isEditing)
                     TextField(
                       controller: _aboutController,
                       style: const TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         hintText: 'Add in your about...',
                         hintStyle: TextStyle(color: Colors.grey[600]),
                         filled: true,
                         fillColor: Colors.grey[900],
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                     )
                   else
                     Text(
                       userData?['about'] ?? 'Add in your about to help others know you better',
                       style: const TextStyle(
                         color: Colors.grey,
                         fontSize: 14,
                       ),
                     ),
                   const SizedBox(height: 20),
                   
                   // Interest Section
                   const Text(
                     'Interest',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   const SizedBox(height: 10),
                   if (isEditing)
                     TextField(
                       controller: _interestController,
                       style: const TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         hintText: 'Add in your interests...',
                         hintStyle: TextStyle(color: Colors.grey[600]),
                         filled: true,
                         fillColor: Colors.grey[900],
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none,
                         ),
                       ),
                     )
                   else
                     Text(
                       userData?['interest'] ?? 'Add in your interest to find a better match',
                       style: const TextStyle(
                         color: Colors.grey,
                         fontSize: 14,
                       ),
                     ),
                 ],
               ),
             ),
           ),
   );
 }
}