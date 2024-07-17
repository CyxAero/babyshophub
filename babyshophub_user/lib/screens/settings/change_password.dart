import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/title_appbar.dart';
import 'package:BabyShopHub/models/user_model.dart';

class ChangePassword extends StatefulWidget {
  final UserModel user;

  const ChangePassword({super.key, required this.user});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController txtCurrentPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const TitleAppbar(title: "Change Password"),
      body:   SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 20),
          child: Column(
            children: [

              
              TextField(
                 
                controller: txtCurrentPassword, 
                obscureText: showCurrentPassword,
                decoration: const InputDecoration(
                labelText: "Current Password",
                hintText: "*********",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                )

              ),

               TextField(
                controller: txtNewPassword,
                obscureText: showNewPassword,
                decoration: const InputDecoration(
                labelText: "New Password",
                hintText: "*********",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                )

              ),
              const SizedBox(height: 15,),
              
               TextField(
                controller:  txtConfirmPassword , 
                obscureText: showConfirmPassword ,
                decoration: const InputDecoration(
                labelText: "Confirm Password",
                hintText: "*********",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                )

              ),
             
             const SizedBox(height: 35,),

               ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(22),
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.green  ,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Change',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.black2,
                                ),
                      ),
                    ),
                

            ],
            ),
        ),
        ),

    );
  }
}
