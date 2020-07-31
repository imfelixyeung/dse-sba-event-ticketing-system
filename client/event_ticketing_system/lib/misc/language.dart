class Language {
  String value;
  String displayName;
  Language(this.value, this.displayName);
}

class Languages {
  static Language enGB = Language('en-gb', 'English (United Kingdom)');
  static Language zhHK = Language('zh-hk', '繁體中文');
  static Language zhCN = Language('zh-cn', '中文');
}
