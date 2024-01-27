import 'package:chatease/components/chat_bubble.dart';
import 'package:chatease/components/my_textfield.dart';
import 'package:chatease/services/auth/auth_service.dart';
import 'package:chatease/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService=ChatService();
  final AuthService _authService=AuthService();

  FocusNode myfocusNode=FocusNode();

  @override
  void initState(){
    super.initState();

    myfocusNode.addListener(() {
      if(myfocusNode.hasFocus){
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
  void dispose(){
    myfocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.grey,
        // elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList()
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderID=_authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.receiverID, senderID),
        builder: (context, snapshot) {

          if(snapshot.hasError){
            return const Text("Error",);
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading...");
          }

          return ListView(
            controller: _scrollController,
            children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList() ,
          );
        },
    );
  }

  //build meassage item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic> data =doc.data() as Map<String,dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
                message: data["message"],
                isCurrentUser: isCurrentUser
            ),
          ],
        ));
  }

  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20,left: 5,right: 8,top: 15),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                controller: _messageController,
                hintText: "Type a message",
                obscureText: false,
                //focusNode: myfocusNode,
              )
          ),

          Container(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
