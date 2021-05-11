import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/contacts_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/notification_plugin.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/widgets/chat_card.dart';
import 'package:chatapp/widgets/recent_messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/general_provider.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  PageController _controller;
  int _pageIndex = 0;
  Future<void> _initiliazing;

  void openContactsScreen(){
    Navigator.pushNamed(context, ContactsScreen.routeName);
  }

  void createGroup(){

  }
  
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = PageController(
      initialPage: 0,
    );
    _initiliazing = context.read<GeneralProvider>().initializeAppData();
    super.initState();
  }
  
  @override
  void dispose() {
    _controller.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      Provider.of<GeneralProvider>(context, listen: false).disconnectSocket();
    }
    else if(state == AppLifecycleState.resumed){
      Provider.of<GeneralProvider>(context, listen: false).connectSocket();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          'ChatApp',
          style: kAppbarTitleStyle
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

            },
          ),
          PopupMenuButton(
            onSelected: (key){
              switch(kMainScreenDropdownValues[key]){
                case 0: Navigator.pushNamed(context, ProfileScreen.routeName);
              }
            },
            itemBuilder: (BuildContext context){
              return kMainScreenDropdownValues.keys.map((key){
                return PopupMenuItem(
                  value: key,
                  child: Text(key),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            TextButton(
              onPressed: (){
                User.logout().then((value){
                  Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                });
              },
              child: Text(
                'Logout'
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: kMainScreenFloatingActionButtonIcons[_pageIndex],
        backgroundColor: kPrimaryColor,
        onPressed: (){
          switch(_pageIndex){
            case 0: return openContactsScreen();
            case 1: return createGroup();
          }
        },
      ),
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return CircularProgressIndicator();
          }
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: kPrimaryColor,
                child: Row(
                  children: [
                    ...['Direct Messages', 'Groups'].asMap().entries.map((section){
                      return TextButton(
                        onPressed: (){
                          setState(() {
                            _controller.animateToPage(section.key, duration:  Duration(milliseconds: 250), curve: Curves.easeOut,);
                            _pageIndex = section.key;
                          });
                        },
                        child: Text(
                          section.value,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (int index){
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  children: [
                    RecentMessages(),
                    Container(),
                  ],
                ),
              ),
            ],
          );
        },
        future: _initiliazing,
      ),
    );
  }
}




