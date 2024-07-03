import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;
  String? username; // Username attribute
  String? profileImage;
  List<Address>? addresses;
  List<PaymentMethod>? paymentMethods;
  bool isAdmin;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.username,
    this.profileImage,
    this.addresses,
    this.paymentMethods,
    required this.isAdmin,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      username: data['username'], // Fetch username from Firestore
      profileImage: data['profileImage'],
      addresses: data['addresses'] != null
          ? (data['addresses'] as List)
              .map((item) => Address.fromMap(item))
              .toList()
          : null,
      paymentMethods: data['paymentMethods'] != null
          ? (data['paymentMethods'] as List)
              .map((item) => PaymentMethod.fromMap(item))
              .toList()
          : null,
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'username': username, // Add username to Firestore
      'profileImage': profileImage,
      'addresses': addresses?.map((e) => e.toMap()).toList(),
      'paymentMethods': paymentMethods?.map((e) => e.toMap()).toList(),
      'isAdmin': isAdmin,
    };
  }
}

class Address {
  String street;
  String city;
  String state;
  String postalCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      postalCode: data['postalCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
  }
}

class PaymentMethod {
  String cardNumber;
  String expiryDate;
  String cardHolderName;

  PaymentMethod({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> data) {
    return PaymentMethod(
      cardNumber: data['cardNumber'] ?? '',
      expiryDate: data['expiryDate'] ?? '',
      cardHolderName: data['cardHolderName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
    };
  }
}
