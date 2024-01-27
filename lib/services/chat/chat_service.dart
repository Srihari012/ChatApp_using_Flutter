import 'package:chatease/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{

  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  //user stream
  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return  _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user=doc.data();

        return user;
      }).toList();
    });
  }

  //send message
Future<void> sendMessage(String receiverID,message) async{
    //user info
    final String currentUserID=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();

    //new message
    Message newMessage=Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp
    );

    //chat room ID for two users
    List<String> ids=[currentUserID,receiverID];
    ids.sort();
    String chatRoomID=ids.join('_');

    //get message
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());
}

  //receive meassage
  Stream<QuerySnapshot> getMessage(String userID,otherUserID){
    List<String> ids=[userID,otherUserID];
    ids.sort();
    String chatRoomID=ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp",descending: false)
        .snapshots();
  }

}