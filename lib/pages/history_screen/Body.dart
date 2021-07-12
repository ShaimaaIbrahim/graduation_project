import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/HistoryProvider.dart';
import 'package:untitled2/widgets/CardLecture.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  void _build(BuildContext context) {
    Provider.of<HistoryProvider>(context).getStudentHistoryLecturers();
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
        child: Consumer<HistoryProvider>(
          builder: (context, provider, child) {
            Widget content = Center(child: Text('No History'));

            if (provider.myHistoryLectures.length > 0) {
              content = Container(
                child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: List.generate(provider.myHistoryLectures.length,
                        (index) {
                      return CardLecture(
                        visible: false,
                        lecture: provider.myHistoryLectures[index],
                      );
                    })),
              );
            } else if (provider.isLoading) {
              content = Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
                onRefresh: provider.getStudentHistoryLecturers, child: content);
          },
        ),
      ),
    );
  }
}
