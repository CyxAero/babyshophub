import 'package:BabyShopHub/screens/Payment/payment_widgets/header_label.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int value = 0;
  final paymentLabels = [
    'Credit Card / Debit Card',
    'Cash on Delivery',
    'Paypal',
    'Google Wallet',
  ];
  final paymentIcons = [
    Icons.credit_card,
    Icons.money_off,
    Icons.payment,
    Icons.account_balance_wallet,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(
        height: 75,
        title: "Payment Methods",
      ),
      body: Column(
        children: [
          const HeaderLabel(headerText: 'Choose your Payment Method'),
          Expanded(
            child: ListView.separated(
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value = i!),
                  ),
                  title: Text(
                    paymentLabels[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  trailing: Icon(
                    paymentIcons[index],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Color.fromARGB(255, 176, 198, 209),
                );
              },
            ),
          ),
          
          SizedBox(
            
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                elevation: 0,
                backgroundColor:  const Color(0xFFfd6f3e),
                minimumSize: const Size(350, 50),
              ),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 200,),
        ],
      ),
    );
  }
}
