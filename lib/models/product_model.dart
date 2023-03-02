class Product {
  final int id;
  final String title;
  final String price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image,
      required this.rating});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as int,
        title: json['title'] as String,
        price: json['price'].toString(),
        description: json['description'] as String,
        category: json['category'] as String,
        image: json['image'] as String,
        rating: Rating.fromJson(json['rating']));
  }

  factory Product.fromDatabaseJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as int,
        title: json['title'] as String,
        price: json['price'].toString(),
        description: json['description'] as String,
        category: json['category'] as String,
        image: json['image'] as String,
        rating: Rating.fromDatabaseJson(json['rate'],json['count'])
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
      'rate': rating.rate,
      'count': rating.count,
    };
  }
}

class Rating {
  String rate;
  int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(rate: json['rate'].toString(), count: json['count']);
  }

  factory Rating.fromDatabaseJson(rate,count) {
    return Rating(rate: rate.toString(), count: int.parse(count));
  }

}
