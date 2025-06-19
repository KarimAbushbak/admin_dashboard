class Company {
  final String id;
  final String username;
  final String companyName;
  final String password;
  final String phone;
  final String address;
  final String? companyPaymentLink;

  Company({
    required this.id,
    required this.username,
    required this.companyName,
    required this.password,
    required this.phone,
    required this.address,
    this.companyPaymentLink,
  });

  factory Company.fromMap(String id, Map<String, dynamic> data) {
    return Company(
      id: id,
      username: data['username'] ?? '',
      companyName: data['companyName'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      companyPaymentLink: data['companyPaymentLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'companyName': companyName,
      'password': password,
      'phone': phone,
      'address': address,
      if (companyPaymentLink != null) 'companyPaymentLink': companyPaymentLink,
    };
  }
}
