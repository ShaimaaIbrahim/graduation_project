import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/widgets/CardSection.dart';

Widget? content;

class Body extends StatelessWidget {
  final DoctorMainScreenProvider mainScreenProvider;

  const Body({Key? key, required this.mainScreenProvider}) : super(key: key);

  void _build(context) {
    content = Center(
      child: Text('No Lectures'),
    );
    if (mainScreenProvider.mySections.length > 0) {
      content = Container(
        child: GridView.count(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children:
                List.generate(mainScreenProvider.mySections.length, (index) {
              return InkWell(
                onTap: () {
                  mainScreenProvider.navigateToLecturesForSpecificSection(
                      context, mainScreenProvider.mySections[index]);
                },
                child: CardSection(
                  index: index,
                  department: mainScreenProvider.mySections[index].department,
                  section: mainScreenProvider.mySections[index].section!,
                ),
              );
            })),
      );
    } else if (mainScreenProvider.isLoading) {
      content = Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: SingleChildScrollView(
          child: RefreshIndicator(
              onRefresh: mainScreenProvider.getOnlyMySections,
              child: content!)),
    );
  }
}
