import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'info_response.g.dart';

abstract class InfoResponse implements Built<InfoResponse, InfoResponseBuilder> {
  @nullable
  String get id;

  @nullable
  String get title;

  @nullable
  String get description;

  @nullable
  DateTime get startAt;

  @nullable
  DateTime get endAt;

  @nullable
  String get photoURL;

  @nullable
  String get shareLink;

  InfoResponse._();

  static Serializer<InfoResponse> get serializer => _$infoResponseSerializer;

  factory InfoResponse([void Function(InfoResponseBuilder) updates]) = _$InfoResponse;
}
