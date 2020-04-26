import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xclipboard/util/model.dart';

class Store {
  static const ADDRESS = "__ADDRESS__";
  static const KEY = "__KEY__";
  static const USER = "__USER__";

  static save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

class DataSet {
  StreamController<ServerInfo> serverInfoController = StreamController();
}

class DataManager extends DataSet {
  save(ServerInfo info) async {
    await Store.save(Store.ADDRESS, info.address);
    await Store.save(Store.KEY, info.key);
    await Store.save(Store.USER, info.user);
    serverInfoController.add(info);
  }
}

DataManager dataManager = DataManager();
