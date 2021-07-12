import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/utilities/constants.dart';

class SearchStudents extends StatefulWidget {
  const SearchStudents({Key? key}) : super(key: key);

  @override
  _SearchStudentsState createState() => _SearchStudentsState();
}

class _SearchStudentsState extends State<SearchStudents> {
  Widget _appBarTitle = new Text(
    'search',
    style: TextStyle(fontSize: 14, color: Colors.white),
  );
  Icon _searchIcon = new Icon(Icons.search);

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<Student> names = [];
  List<Student> filteredNames = [];
  List<Student>? students;

  /// listeners to textEditing-----
  _SearchStudentsState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this._getNames();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryLight,
        iconTheme: IconThemeData(color: Colors.black),
        title: _appBarTitle,
        leading: new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ),
      body: Container(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<Student> tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .name!
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }

    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(filteredNames[index].name!),
          subtitle: Text(filteredNames[index].number!),
          trailing: Text(filteredNames[index].section!),
          leading: Image.asset('assets/images/user.png'),
        );
      },
    );
  }

  void _getNames() async {
    Provider.of<StudentProvider>(context, listen: false).getAllStudents();
    students = Provider.of<StudentProvider>(context, listen: false).allStudents;

    List<Student> tempList = [];

    students!.forEach((element) {
      tempList.add(element);
    });
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
