import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/pages/chat_page/chat_group_screen.dart';
import 'package:untitled2/pages/collegues_screen/ColleguesScreen.dart';
import 'package:untitled2/pages/edit_profile/EditProfileScreen.dart';
import 'package:untitled2/pages/history_screen/StudentHistoryScreen.dart';
import 'package:untitled2/pages/intro_screen/intro_screen_component.dart';
import 'package:untitled2/pages/notification_screen/notification_page.dart';
import 'package:untitled2/provider/StudentMainScreenProvider.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/utilities/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Drawer(
      child: Consumer<StudentMainScreenProvider>(
          builder: (context, provider, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryLight),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/user.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(provider.Me.name!),
                  SizedBox(
                    height: 7,
                  ),
                  Text(provider.Me.number!),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditProfileScreen(me: provider.Me)));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('My Colleagues'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ColleguesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Group Chatting'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GroupChat(me: provider.Me)));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('My History'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            StudentHistoryScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => NotificationPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.forward),
              title: Text('LogOut'),
              onTap: () {
                Provider.of<StudentProvider>(context).signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => IntroScreen()));
              },
            ),
          ],
        );
      }),
    );
  }
}

void _build(BuildContext context) {
  Provider.of<StudentMainScreenProvider>(context).getMyInfo();
}
