import 'dart:async';

import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer _timer;
  bool _isSearching = false;
  List _searchResults = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search'
                        ),
                        onChanged: (String value){
                          if(_timer != null){
                            _timer.cancel();
                          }

                          if(value.isNotEmpty){
                            setState(() {
                              _isSearching = true;
                            });
                            _timer = Timer(Duration(seconds: 1), () async {
                              _searchResults = await User.findUser(value);
                              setState(() {
                                _isSearching = false;
                              });
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              _isSearching ? CircularProgressIndicator() :
              Expanded(
                child: ListView(
                  children: [
                    ..._searchResults.map((e){
                      return Text('${e['userName']} ${e['name']} ${e['surname']}');
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
