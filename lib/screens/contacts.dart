import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:updated_app/screens/LoginSignup.dart';
import 'package:updated_app/screens/update_contacts.dart';

import 'add_contacts.dart';

class Contacts extends StatefulWidget {
  static const String id = "Contacts";
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List users = [];

  @override
  void initState() {
    super.initState();
    this.fetchUser();
  }

  final String apiUrlget = "https://kisi-api.herokuapp.com/contacts";
  List<dynamic> _users = [];
  fetchUser() async {
    var result = await http.get(Uri.parse(apiUrlget));
    setState(() {
      _users = jsonDecode(result.body);
    });
    print(
        "Status Code [" + result.statusCode.toString() + "]: All Data Fetched");
  }

  String _name(dynamic user) {
    return user['first_name'] + " " + user['last_name'];
  }

  String _phonenum(dynamic user) {
    return user['phone_numbers'][0];
  }

  Future<http.Response> deleteContact(String id) {
    print("Status [Deleted]: [" + id + "]");
    return http.delete(
        Uri.parse('https://kisi-api.herokuapp.com/contacts/delete/' + id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Contacts"),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove("token");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()),
                  (_) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          builder: (context, snapshot) {
            return _users.length != 0
                ? RefreshIndicator(
                    child: ListView.builder(
                        padding: EdgeInsets.all(12.0),
                        itemCount: _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(_users[index].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.delete_forever,
                                        color: Colors.pink),
                                    Text("Delete",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.pink))
                                  ]),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onDismissed: (direction) {
                              String id = _users[index]['_id'].toString();
                              String userDeleted =
                                  _users[index]['first_name'].toString();
                              deleteContact(id);
                              setState(() {
                                _users.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$userDeleted contact deleted'),
                                ),
                              );
                            },
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm",
                                        style: TextStyle(
                                          color: Color(0xFF5B3415),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    content: const Text(
                                        "Are you sure you want to delete?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("DELETE",
                                              style: TextStyle(
                                                  color: Colors.redAccent))),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCEL",
                                            style: TextStyle(
                                                color: Color(0xFFFCC14A))),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    tileColor: index % 2 == 0
                                        ? Colors.purple.shade200
                                        : Colors.purple.shade100,
                                    title: Text(
                                      _name(_users[index]),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      _phonenum(_users[index]),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateContacts(
                                                        specificID:
                                                            _users[index]['_id']
                                                                .toString())),
                                            (_) => false);
                                      },
                                      child: const Text(
                                        'EDIT',
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      List<int> listNumbers = [];
                                      for (int i = 0;
                                          i <
                                              _users[index]['phone_numbers']
                                                  .length;
                                          i++) {
                                        listNumbers.add(i + 1);
                                      }
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: AlertDialog(
                                                  title: Text(
                                                    _name(_users[index]),
                                                    style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24),
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "Contact Number/s",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orangeAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            listNumbers.length,
                                                            (iter) {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'Phone #' +
                                                                        listNumbers[iter]
                                                                            .toString() +
                                                                        ':\t\t' +
                                                                        _users[index]['phone_numbers'][iter]
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF5B3415),
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          24, 12, 0, 0),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'OK'),
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color: Colors.purple,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  actionsPadding:
                                                      EdgeInsets.fromLTRB(
                                                          24, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    onRefresh: _getData,
                  )
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    backgroundColor: Colors.pink,
                  ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return AddContacts();
          }));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
    FlatButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LoginSection();
          }));
        },
        icon: Icon(Icons.save),
        label: Text("Logout"));
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;

    if (type == "Work") {
      color = Colors.brown;
    }
    if (type == "Family") {
      color = Colors.green;
    }
    if (type == "Friends") {
      color = Colors.teal;
    }
    return color;
  }

  Future<void> _getData() async {
    setState(() {
      fetchUser();
    });
  }
}
