import 'package:hive/hive.dart';

import '../domain/user_alias.dart';

class AliasHive {
  static const String boxName = 'alias_hive_box';

  final Box<UserAlias> _aliasHiveBox;

  AliasHive._(Box<UserAlias> aliasHiveBox) : _aliasHiveBox = aliasHiveBox;

  static Future<AliasHive> factory() async {
    Hive.registerAdapter(UserAliasAdapter());

    final box = await Hive.openBox<UserAlias>(boxName);
    return AliasHive._(box);
  }

  Future<void> addUserAlias(UserAlias alias) async {
    await _aliasHiveBox.put(alias.id, alias);
  }

  Future<List<UserAlias>> getUserAliases() async {
    return _aliasHiveBox.values.toList();
  }

  Future<bool> delete(String id) async {
    await _aliasHiveBox.delete(id);
    return !_aliasHiveBox.containsKey(id);
  }
}

class UserAliasAdapter extends TypeAdapter<UserAlias> {
  @override
  int get typeId => 123;

  @override
  UserAlias read(BinaryReader reader) {
    return UserAlias.fromJson(Map.from(reader.readMap()));
  }

  @override
  void write(BinaryWriter writer, UserAlias obj) {
    writer.writeMap(obj.toJson());
  }
}
