// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String,
      json['price'] as int,
      (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      json['thumbnail'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'thumbnail': instance.thumbnail,
      'images': instance.images,
    };
