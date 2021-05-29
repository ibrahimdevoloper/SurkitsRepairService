class TextPair {
  String _enTxt;
  String _arTxt;

  TextPair(String enTxt, String arTxt):this._arTxt=arTxt,this._enTxt=enTxt;

  String get arTxt => _arTxt;

  set arTxt(String value) {
    _arTxt = value;
  }

  String get enTxt => _enTxt;

  set enTxt(String value) {
    _enTxt = value;
  }
}