import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:BabyShopHub/widgets/custom_textfield.dart';
import 'package:BabyShopHub/models/user_model.dart';
import 'package:flutter/material.dart';

class AddNewAddressesScreen extends StatelessWidget {
  final UserModel? user;

  const AddNewAddressesScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(
        height: 75,
        title: "Add NewAddress",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            child: Column(
              children: [
                CustomTextField(
                  prefixIcon: Icons.person,
                  labelText: "Name",
                  keyboardType: TextInputType.name,
                  hintText: user?.username ?? 'User',
                ),
                const SizedBox(
                  height: 16,
                ),
                const CustomTextField(
                  prefixIcon: Icons.call,
                  labelText: "Phone Number",
                  keyboardType: TextInputType.number,
                  hintText: "(+234) 01-67900",
                ),
                 const SizedBox(
                  height: 16,
                ),
                 const Row(
                  children: [
                     Expanded(
                       child: CustomTextField(
                                         prefixIcon: Icons.home_work_outlined,
                                         labelText: "street",
                                         keyboardType: TextInputType.number,
                                         hintText: "4, Apartment, suite",
                                       ),
                     ),
                       SizedBox(
                  width: 16,
                ),
                 Expanded(
                   child: CustomTextField(
                    prefixIcon: Icons.code,
                    labelText: "Postal Code",
                    keyboardType: TextInputType.number,
                    hintText: "10****",
                                   ),
                 ),
                  ],
                ),
                  const SizedBox(
                  height: 16,
                ),
                const Row(
                  children: [
                     Expanded(
                       child: CustomTextField(
                                         prefixIcon: Icons.business_outlined,
                                         labelText: "City",
                                         keyboardType: TextInputType.streetAddress,
                                         hintText: "Ikeja",
                                       ),
                     ),
                       SizedBox(
                  width: 16,
                ),
                 Expanded(
                   child: CustomTextField(
                    prefixIcon: Icons.local_activity,
                    labelText: "State",
                    keyboardType: TextInputType.number,
                    hintText: "Lagos",
                                   ),
                 ),
                  ],
                ),
                 const SizedBox(
                  height: 16,
                ),
                 const CustomTextField(
                    prefixIcon: Icons.language_outlined,
                    labelText: "Country",
                    keyboardType: TextInputType.number,
                    hintText: "Nigeria",
                                   ),
                 const SizedBox(
                  height: 75,
                ),
                SizedBox( width: double.infinity, height: 50,  child: ElevatedButton(onPressed: (){}, child: const Text("Save")),)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
