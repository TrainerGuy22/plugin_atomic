library atomicbot;

import "package:polymorphic_bot/api.dart";
import "package:irc/irc.dart" show Color;

import "dart:async";
import "dart:io";
import "dart:convert";

part "util.dart";
part "storage.dart";

APIConnector bot;

Storage notice = new Storage(new File("atomicbot/notice.json"));

main(List<String> args, port) {
  init(port);
  
  messageEvent.listen((event) {
    String from = event['from'];
    event['target'] = from;
    
    if(notice.map.containsKey(from)) {
      List<String> messages = notice.get(from);
      for(String message in messages) {
        reply(event, message, true, "Notifications");
      }
      
      notice.json.remove(from);
    }
  });
  
  command("mustache").listen((event) {
    reply(event, "http://mustachify.me/?src=${Uri.encodeComponent(event['args'][0])}");
  });
  
  command("notify").listen((event) {
    List<String> args = event['args'] as List<String>;
    String user = args[0];
    String message = args.sublist(1).join(" ");
    
    List<String> messages = <String>[];
    if(notice.map.containsKey(user)) {
      messages.addAll(notice.get(user, <String>[]) as List<String>);
    }
    
    messages.add("${Color.RED}Message from ${event['from']}:${Color.RESET} ${message}");
    notice.set(user, messages);
  });
}
