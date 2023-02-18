class Product {
  String name;
  bool isBuy;
  String? id;

  Product({required this.name, required this.isBuy});

  factory Product.fromJson(Map<String, dynamic> json)=>Product(name: json['name'], isBuy: json['isBuy']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'isBuy': isBuy,
      };
}
