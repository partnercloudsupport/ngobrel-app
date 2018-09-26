library ngobrel_app.chat_list;

import 'dart:math';
import 'package:flutter/material.dart';
import 'chat-screen-page.dart';
import 'db.dart';
import 'utils.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => new _ChatListState();
}

class _ChatListState extends State<ChatList> {

  Widget _buildChatList() {
    return
      DatabaseList(
        query: 'select * from chat_list order by updated_at desc',
        itemBuilder: (BuildContext context, Map entry, int i) {
          return _buildRow(context, entry, i);
        },
      );
  }

  String _getInitial(String name) {
    String result = "";
    var words = name.split(" ");
    for (int i = 0; i < max(2, words.length); i ++) {
      result = result + words[i].substring(0, 1).toUpperCase();
    }
    return result;
  }

  Widget _getAvatar(dynamic avatar, String name) {
    if (avatar == null) {
      return CircleAvatar(
        child: Text(_getInitial(name)),
      );
    } else {
      return CircleAvatar(
          backgroundImage: MemoryImage(avatar)
      );
    }
  }

  Widget _buildRow(BuildContext context, Map entry, int index) {
    return GestureDetector(
      child: Column(
        children: [
          ListTile(
            title: Text(entry['title'], style: TextStyle(fontWeight: FontWeight.bold),),
            trailing:
              entry['notification'] > 0 ?
                Text(Utils.dateFormat(entry['updated_at'])) :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                  Text(Utils.dateFormat(entry['updated_at'])),
                  Icon(Icons.volume_off)
                ],),
            subtitle: Text(entry['excerpt'], overflow: TextOverflow.ellipsis,),
            leading: _getAvatar(entry['avatar'], entry['title']),
          ),

        Divider()]
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreenPage(chatWith: entry)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     return _buildChatList();
  }
}