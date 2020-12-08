import 'dart:io';

import 'package:br/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'helpers/contact_helper.dart';

class DrawerTeste extends StatefulWidget {
  @override
  _DrawerTesteState createState() => _DrawerTesteState();
}

class _DrawerTesteState extends State<DrawerTeste> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();
  String _img;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drawer Teste")),
      body: Center(
        child: GestureDetector(
          child: CircleAvatar(
            backgroundColor: Colors.pink,
            radius: 60,
            backgroundImage: (_img != null
                ? FileImage(File(_img))
                : AssetImage("assets/images/user-circle-solid.png")),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color:  Colors.blue
                    ),
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.blue
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.camera,
                    size: 20,
                    color: Colors.white,
                  ),
                )),
          ),
          onTap: () {
            ImagePicker.pickImage(source: ImageSource.camera).then((file) {
              setState(() {
                if (file == null) return;
                _img = file.path;
              });
            });
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("af"),),
              onTap: () {
                _showContactPage();
              },
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(contacts[index].img))
                          : AssetImage("images/person.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "Ana",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "email",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "telefone",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContact().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
