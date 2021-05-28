import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5),
                      child: ChatRoomTile(
                          snapshot.data.documents[index]
                              .data()["chatroomid"]
                              .toString()
                              .replaceAll("_", "")
                              .replaceAll(Constants.myName, ""),
                          snapshot.data.documents[index].data()["chatroomid"]),
                    ),
                  );
                },
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black54,
        title: Text(
          "Firebook",
          style:
              GoogleFonts.raleway(fontSize: 40, color: Colors.lightBlueAccent,fontWeight: FontWeight.bold,),
        ),
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: Authenticate(),
                      type: PageTransitionType.bottomToTop));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(child: chatRoomList()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: SearchScreen(), 
                  type: PageTransitionType.bottomToTop));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: ConversationScreen(chatRoomId),
                type: PageTransitionType.bottomToTop));
      },
      child: Container(
        color: Colors.lightBlueAccent.shade100,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName.toUpperCase(),
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}
