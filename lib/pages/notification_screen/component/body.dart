import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/pages/notification_screen/component/notification_list_item.dart';
import 'package:untitled2/provider/NotificationProvider.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Consumer<NotificationProvider>(
      builder: (context, notiData, child) {
        Widget content = Center(
          child: Container(child: Text('No Notifications')),
        );

        if (notiData.myNotifications.length > 0) {
          content = Center(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: notiData.myNotifications.length,
                  itemBuilder: (BuildContext context, index) {
                    return NotificationListItem(
                        lecture: notiData.myNotifications[index]);
                  }),
            ),
          );
        } else if (notiData.isLoading) {
          content =
              Center(child: Container(child: CircularProgressIndicator()));
        }
        return RefreshIndicator(
            onRefresh: notiData.getStudentNotifications, child: content);
      },
    );
  }

  void _build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false)
        .getStudentNotifications();
  }
}
