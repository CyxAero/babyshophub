import 'package:BabyShopHub/screens/address/address_widgets/single_address.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BabyShopHub/screens/address/add_new_address.dart';
import 'package:BabyShopHub/models/user_model.dart';

class UserAddressScreen extends StatelessWidget {
  final UserModel? user;

  const UserAddressScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewAddressesScreen(user: user)));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: const BasicAppBar(
        height: 100,
        title: "Shipping Addresses",
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 2, left: 12, right: 12),
          child: Column(
            children: [
              SingleAddress(
                selectedAddress: false,
              ),
              SingleAddress(
                selectedAddress: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
