// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_short.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductShort _$ProductShortFromJson(Map<String, dynamic> json) => ProductShort(
      json['id'] as int,
      json['title'] as String,
      json['price'] as int,
      json['thumbnail'] as String,
    );

Map<String, dynamic> _$ProductShortToJson(ProductShort instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'thumbnail': instance.thumbnail,
    };
