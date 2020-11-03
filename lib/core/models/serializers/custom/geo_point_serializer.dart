import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeoPointSerializer implements PrimitiveSerializer<GeoPoint> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([GeoPoint]);
  @override
  final String wireName = 'GeoPoint';

  @override
  Object serialize(Serializers serializers, GeoPoint geoPoint, {FullType specifiedType: FullType.unspecified}) {
    return geoPoint;
  }

  @override
  GeoPoint deserialize(Serializers serializers, Object serialized, {FullType specifiedType: FullType.unspecified}) {
    return serialized as GeoPoint;
  }
}
