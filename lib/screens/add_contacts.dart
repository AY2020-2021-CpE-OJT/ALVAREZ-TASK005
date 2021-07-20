import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:updated_app/screens/contacts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 172.27.176.1:3000/quotes/
class ContactData {
  final String lastName;
  final String firstName;
  final List<String> phoneNumbers;

  ContactData(this.lastName, this.firstName, this.phoneNumbers);
}

class AddContacts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  int key = 0, checkAdd = 0, listNumber = 1, _count = 1;
  String val = '';
  RegExp digitValidator = RegExp("[0-9]+");

  bool isANumber = true;
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  List<TextEditingController> _numberController = <TextEditingController>[
    TextEditingController()
  ];

  List<ContactData> contactsAppend = <ContactData>[];
  String _typeSelected = '';
  @override
  void initState() {
    // TODO: implem
    //ent initState
    super.initState();
    _fnameController = TextEditingController();
    _lnameController = TextEditingController();
  }

  Widget _buildContactType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title
              ? Colors.green
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Contact'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _fnameController,
              decoration: InputDecoration(
                hintText: 'First Name',
                prefixIcon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            TextFormField(
              controller: _lnameController,
              decoration: InputDecoration(
                hintText: 'Last Name',
                prefixIcon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 20),
            Text("Contact Number/s: $listNumber",
                style: TextStyle(color: Color(0xFF5B3415))),
            SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: _count,
                  itemBuilder: (context, index) {
                    return _row(index, context);
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildContactType('Work'),
                  SizedBox(width: 1),
                  _buildContactType('Family'),
                  SizedBox(width: 1),
                  _buildContactType('Friends'),
                  SizedBox(width: 1),
                  _buildContactType('Others'),
                  SizedBox(width: 1),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                child: Text(
                  'Save Contact',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  saveContact();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CheckScreen(contacts: contactsAppend)),
                      (_) => false);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(20)),
              ),
            )
          ],
        ),
      ),
    );
  }

  _row(int key, context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            controller: _numberController[
                key], //_numberController[0] != _numberController[1]
            textCapitalization: TextCapitalization.sentences,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple,
                  ),
                ),
                // errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorText: isANumber ? null : "Please enter a number",
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                labelText: 'Phone number'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: 24,
            height: 24,
            child: _addRemoveButton(key == checkAdd, key),
          ),
        ),
      ],
    );
  }

  void saveContact() {
    List<String> number = <String>[];
    for (int i = 0; i < _count; i++) {
      number.add(_numberController[i].text);
    }
    List<String> reversedpnums = number.reversed.toList();

    setState(() {
      contactsAppend.insert(
          0,
          ContactData(
              _lnameController.text, _fnameController.text, reversedpnums));
    });
    print('Status Append Contacts [Success]');
  }

  Widget _addRemoveButton(bool isTrue, int index) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (isTrue) {
          setState(() {
            _count++;
            checkAdd++;
            listNumber++;
            _numberController.insert(0, TextEditingController());
          });
        } else {
          setState(() {
            _count--;
            checkAdd--;
            listNumber--;
            _numberController.removeAt(index);
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: (isTrue) ? Colors.purple : Colors.pink,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          (isTrue) ? Icons.add : Icons.remove,
          color: Colors.white70,
        ),
      ),
    );
  }
}

class CheckScreen extends StatelessWidget {
  final List<ContactData> contacts;

  const CheckScreen({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<http.Response> createContact(
        String fname, String lname, List pnums) {
      return http.post(
        Uri.parse('https://kisi-api.herokuapp.com/contacts/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone_numbers': pnums,
          'first_name': fname,
          'last_name': lname,
        }),
      );
    }

    List<int> listNumbers = [];
    for (int i = 0; i < contacts[0].phoneNumbers.length; i++) {
      listNumbers.add(i + 1);
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Summary of Contacts')),
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            createContact(contacts[index].firstName, contacts[index].lastName,
                contacts[index].phoneNumbers);
            return Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Text('Create Successfull',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 38)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('First Name: ',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      Text('${contacts[index].firstName}',
                          style: TextStyle(
                              color: Colors.deepOrangeAccent, fontSize: 30),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Last Name: ',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      Text('${contacts[index].lastName}',
                          style: TextStyle(
                              color: Colors.deepOrangeAccent, fontSize: 30),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('Contact Numbers/s:  ',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      listNumbers.length,
                      (index) {
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Phone #' +
                                    listNumbers[index].toString() +
                                    ':\t\t' +
                                    contacts[0].phoneNumbers[index].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Contacts()),
                (_) => false);
          },
          icon: Icon(Icons.done_all),
          label: Text("Done"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
