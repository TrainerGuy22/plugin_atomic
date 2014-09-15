part of atomicbot;

StreamController messageStream = new StreamController.broadcast();
Stream get messageEvent => messageStream.stream;

Map<dynamic, StreamController> commandsStream = {};

void reply(event, String message, [bool prefix = false, String prefixContent = "AtomicBot"]) {
  bot.message(event['network'], event['target'], (prefix ? "[${Color.BLUE}${prefixContent}${Color.RESET}] " : "") + "${event['from']}: " + message);
}

Stream command(String name) {
  if(commandsStream.containsKey(name))
    return commandsStream[name].stream;
  
  StreamController commandStream = new StreamController();
  commandsStream[name] = commandStream;
  return commandStream.stream;
}

void init(port) {
  bot = new APIConnector(port);
  print("[AtomicBot] Started.");
  
  bot.handleEvent((event) {
    if(event['event'] == "message") {
      messageStream.add(event);
    } else if(event['event'] == "command" && commandsStream.containsKey(event['command'] as String)) {
      commandsStream[event['command'] as String].add(event);
    }
  });
}
