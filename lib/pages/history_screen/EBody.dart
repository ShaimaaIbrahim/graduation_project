import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/HistoryProvider.dart';
import 'package:untitled2/widgets/CardLecture.dart';

class EBody extends StatelessWidget {
  const EBody({Key key}) : super(key: key);

  void _build(BuildContext context) {
    Provider.of<HistoryProvider>(context, listen: false)
        .getDoctorHistoryLecturers();
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
            Widget content = Center(
              child: CircularProgressIndicator(),
            );
            if (provider.docHistoryLectures.length > 0) {
              content = Container(
                child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: List.generate(provider.docHistoryLectures.length,
                        (index) {
                      return CardLecture(
                        visible: false,
                        lecture: provider.docHistoryLectures[index],
                      );
                    })),
              );
            } else if (provider.docHistoryLectures.length == 0) {
              content = Center(child: Text('No History'));
            }
            return RefreshIndicator(
                onRefresh: provider.getDoctorHistoryLecturers, child: content);
          },
        ),
      ),
    );
  }
}
