import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;
  final List<dynamic> wishlist;
  final List<dynamic> notifications; // <-- use plural

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
    required this.wishlist,
    this.notifications = const [],
  });

  // Convert User to Map
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
      'wishlist': wishlist,
      'notifications': notifications, // <-- use plural
    };
  }

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: map['cart'] != null
          ? List<Map<String, dynamic>>.from(
              (map['cart'] as List).map(
                (x) => Map<String, dynamic>.from(x),
              ),
            )
          : [],
      wishlist: map['wishlist'] != null
          ? List<dynamic>.from(map['wishlist'])
          : [],
      notifications: map['notifications'] != null
          ? List<Map<String, dynamic>>.from(
              (map['notifications'] as List).map(
                (x) => Map<String, dynamic>.from(x),
              ),
            )
          : [],
    );
  }

  // Convert User to JSON string
  String toJson() => json.encode(toMap());

  // Create User from JSON string
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
    List<dynamic>? wishlist,
    List<dynamic>? notifications, // <-- use plural
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
      wishlist: wishlist ?? this.wishlist,
      notifications: notifications ?? this.notifications, // <-- use plural
    );
  }
}
