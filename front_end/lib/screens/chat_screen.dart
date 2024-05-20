import 'package:flutter/material.dart';
import 'package:front_end/controller/message_controller.dart';
import 'package:front_end/models/chat_message.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageController _messageController =
      MessageController(baseUrl: "http://192.168.1.11:8080");
  final TextEditingController _messageTextField = TextEditingController();
  final TextEditingController _usernameTextField = TextEditingController();

  late Future<List<ChatMessage>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureMessages = _messageController.getMessages();
  }

  void _sendMessage() async {
    if (_messageTextField.text.isEmpty || _usernameTextField.text.isEmpty)
      return;

    await _messageController.sendMessages(
        _usernameTextField.text, _messageTextField.text);
    setState(() {
      _futureMessages = _messageController.getMessages();
    });
    _messageTextField.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public Chat"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: FutureBuilder<List<ChatMessage>>(
                  future: _futureMessages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No Messages"),
                      );
                    }

                    List<ChatMessage> messages = snapshot.data!;
                    Map<DateTime, List<ChatMessage>> groupedMessages =
                        groupMessagesByDate(messages);
                    return ListView(
                        children: groupedMessages.entries.map((entry) {
                      DateTime date = entry.key;
                      List<ChatMessage> messagesForDate = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: Text(
                              formatDate(date),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: messagesForDate.map((message) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 6.0,
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    message.username,
                                                    textAlign: TextAlign.left,
                                                  )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 4.0),
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(16),
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          16),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          16))),
                                                  child: Text(
                                                    message.message,
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 1,
                                          ),
                                          Text(
                                            formatTime(message.timestamp),
                                            style:
                                                const TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      )
                                    ]),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList());
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            _buildMessageInputField()
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey[200],
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                controller: _usernameTextField,
                decoration: const InputDecoration(
                    hintText: "Nama", border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 9,
              child: TextField(
                controller: _messageTextField,
                decoration: const InputDecoration(
                    hintText: "Type Your Message...",
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send))
          ],
        ));
  }
}

Map<DateTime, List<ChatMessage>> groupMessagesByDate(
    List<ChatMessage> messages) {
  Map<DateTime, List<ChatMessage>> groupedMessages = {};

  for (ChatMessage message in messages) {
    DateTime date = DateTime(
        message.timestamp.year, message.timestamp.month, message.timestamp.day);
    if (groupedMessages.containsKey(date)) {
      groupedMessages[date]!.add(message);
    } else {
      groupedMessages[date] = [message];
    }
  }

  return groupedMessages;
}

bool isSameDay(DateTime time1, DateTime time2) {
  return time1.year == time2.year &&
      time1.month == time2.month &&
      time1.day == time2.day;
}

String formatDate(DateTime date) {
  return DateFormat("EEEE, MMMM d, y").format(date);
}

String formatTime(DateTime time) {
  return DateFormat("HH:MM").format(time);
}
