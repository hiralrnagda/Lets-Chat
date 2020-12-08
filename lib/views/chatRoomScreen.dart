import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      margin: EdgeInsets.only(bottom: 5,top:5),
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
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Let's Chat",style: GoogleFonts.lato(fontSize: 20,color: Colors.deepOrangeAccent),),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(child: chatRoomList()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
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
  
    double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    double distanceInKm = distanceInMeters/1000;
    String x = distanceInKm.truncate().toString();
    String d = x + " Km apart";

    
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.orangeAccent.shade100,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.orangeAccent,
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                textAlign: TextAlign.center,
                style: simpleTextStyle(),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              width: 100,
            ),
            Text(
              d,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),

          ],
        ),
      ),
    );
  }
}
