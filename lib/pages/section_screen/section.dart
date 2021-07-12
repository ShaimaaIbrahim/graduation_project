import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/Prescence_provider.dart';
import 'package:untitled2/utilities/constants.dart';

import 'components/section_list_item.dart';

class SectionsScreen extends StatefulWidget {
  static String routeName = '/sections';

  List<String>? sections;
  String? department;

  SectionsScreen({this.sections, this.department});

  @override
  _SectionsScreenState createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  @override
  void initState() {
    Provider.of<PrecenceProvider>(context, listen: false)
        .getFiteredLecturers(widget.sections![0], widget.department!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('All Sections', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: primaryDark),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.sections!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<PrecenceProvider>(context, listen: false)
                        .getFiteredLecturers(
                            widget.sections![index], widget.department!);

                    ///sleep----
                    sleep(Duration(seconds: 1));
                  },
                  child: SectionListItem(
                    sectionName: widget.sections![index],
                    color: primaryDark,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
