// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_short.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductShort _$ProductShortFromJson(Map<String, dynamic> json) => ProductShort(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$ProductShortToJson(ProductShort instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
    };
