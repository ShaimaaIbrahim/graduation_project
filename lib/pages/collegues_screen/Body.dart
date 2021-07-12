import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/ColleguesProvider.dart';
import 'package:untitled2/provider/StudentMainScreenProvider.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: SingleChildScrollView(
        child: Consumer<ColleguesProvider>(
          builder: (context, stdData, child) {
            Widget content = Center(child: Text('No Collegues'));
            if (stdData.myCollegues.length > 0) {
              content = Center(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: ListView.builder(
                      itemCount: stdData.myCollegues.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            stdData.navigateToSingleChat(
                                stdData.myCollegues[index], context);
                          },
                          child: ListTile(
                            title: Text(
                                stdData.myCollegues[index].name.toString()),
                            subtitle: Text(stdData.myCollegues[index].number!),
                            leading: Image.asset('assets/images/user.png'),
                            trailing: Text(stdData.myCollegues[index].section!),
                          ),
                        );
                      }),
                ),
              );
            } else if (stdData.isLoading) {
              content = Center(
                child: Container(
                    color: Colors.white, child: CircularProgressIndicator()),
              );
            }
            return RefreshIndicator(
                onRefresh: stdData.getMyCollegues, child: content);
          },
        ),
      ),
    );
  }
}

void _build(BuildContext context) {
  Provider.of<ColleguesProvider>(context, listen: false).getMyCollegues();
  Provider.of<StudentMainScreenProvider>(context, listen: false).getMyInfo();
}
