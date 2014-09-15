part of atomicbot;

class Storage {
  final File file;
  
  Map<String, dynamic> json = {};
  
  Storage(this.file) {
    load();
    new Timer.periodic(new Duration(seconds: 1), (timer) {
      _save();
    });
  }
  
  void load() {
    if (!file.existsSync()) {
      return;
    }
    
    var content = file.readAsStringSync();
    json = JSON.decode(content);
  }
  
  void _save() {
    file.writeAsStringSync(JSON.encode(json));
  }
  
  dynamic get(String key, [dynamic defaultValue]) => json.containsKey(key) ? json[key] : defaultValue;
  
  void set(String key, dynamic value) {
    json[key] = value;
  }
  
  Map<String, dynamic> get map => new Map.from(json);
}