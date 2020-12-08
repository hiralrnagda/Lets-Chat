import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream<QuerySnapshot> chatMessageStream;
 
  double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
  

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data()["message"],
                        snapshot.data.documents[index].data()["sendByMe"] ==
                            Constants.myName);
                  },
                )
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "location" : distanceInMeters
      };

      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black12,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white54),
                        decoration: InputDecoration(
                            hintText: "Message...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.orange,),
                          
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/send.png",
                            height: 25,
                            width: 25,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          right: isSendByMe ? 0 : 15,
          left: isSendByMe ? 15 : 0),
      alignment: isSendByMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        //alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        margin:
            isSendByMe ? EdgeInsets.only(right: 30) : EdgeInsets.only(left: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [Colors.orangeAccent, Colors.orangeAccent]
                : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)),
        ),       
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
