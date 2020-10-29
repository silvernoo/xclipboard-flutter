class Target {
  String address;
  String group;
  String key;

  String get rawAddress => "$address?group=$group";

  Target(this.address, this.group, this.key);
}
