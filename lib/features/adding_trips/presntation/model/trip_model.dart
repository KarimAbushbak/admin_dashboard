class Trip {
  final String from;
  final String to;
  final String date;
  final String timeLeave;
  final String timeArrive;
  final int seats;
  final double price;
  final String? companyId;
  final String? id;

  Trip({
    required this.from,
    required this.to,
    required this.date,
    required this.timeLeave,
    required this.timeArrive,
    required this.seats,
    required this.price,
    this.companyId,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'date': date,
      'timeLeave': timeLeave,
      'timeArrive': timeArrive,
      'seats': seats,
      'price': price,
      'companyId': companyId,
      'id': id,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      date: map['date'] ?? '',
      timeLeave: map['timeLeave'] ?? '',
      timeArrive: map['timeArrive'] ?? '',
      seats: map['seats'] ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      companyId: map['companyId'],
      id: map['id'],
    );
  }
}
