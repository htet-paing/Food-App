import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String id;
  String name;
  String category;
  String image;
  List subIngredients;
  Timestamp createdAt;
  Timestamp updatedAt;

  Food({this.id, this.name, this.category, this.image, this.subIngredients, this.createdAt, this.updatedAt});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      image: json['image'],
      subIngredients: json['subIngredients'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'category': category,
      'image': image,
      'subIngredients': subIngredients,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

}