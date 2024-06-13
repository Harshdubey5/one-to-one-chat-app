import 'package:chat/auth/auth_services.dart';
import 'package:chat/chat/chat_services.dart';
import 'package:chat/widgets/chatbubble.dart';
import 'package:chat/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // focus node for textfield
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Text('error');
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          // return list view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            isCurrentUser: isCurrentUser,
          )
        ],
      ),
    );
  }

  // message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: MyTextField(
              controller: _messageController,
              hintText: 'Type a message',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              // margin: const EdgeInsets.only(right: 30),
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
