class Country {
  int _id;
  String _code, _name, _region;
  bool _is_fav = false;
  Country(this._id, this._code, this._name, this._region);

  set id(int id) {
    this._id = id;
  }

  set code(String code) {
    this._code = code;
  }

  set name(String s) {
    this._name = s;
  }

  set region(String s) {
    this._region = s;
  }

  set fav(bool f) {
    this._is_fav = f;
  }

  int get id => this._id;

  String get code => this._code;

  String get name => this._name;

  String get region => this._region;

  bool get fav => this._is_fav;

  getData() {
    return {
      "id" : this._id,
      "code": this._code,
      "name": this._name,
      "region": this._region,
      "fav": this._is_fav
    };
  }
}
