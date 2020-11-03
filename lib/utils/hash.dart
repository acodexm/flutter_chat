import 'package:hashids2/hashids2.dart';

String getHash(List<String> list, String salt) {
  final hashids = HashIds();
  var hashList = list.map((e) => e.hashCode).toList();
  hashList.sort();
  hashids.salt = salt;
  return hashids.encodeList(hashList);
}
