import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageTeste extends StatefulWidget {
  @override
  _ImageTesteState createState() => _ImageTesteState();
}

//https://i.imgur.com/BoN9kdC.png //'https://www.woolha.com/media/2020/03/eevee.png'
class _ImageTesteState extends State<ImageTeste> {
  File _image;
  String _imagepath;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imagepath != null
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(File(_imagepath)),
                    )
                  : CircleAvatar(
                      radius: 80,
                      backgroundImage: _image != null
                          ? FileImage(_image)
                          : NetworkImage(
                              'https://www.woolha.com/media/2020/03/eevee.png'),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () {
                      PickImage();
                    },
                    child: Text("Pick Image")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () {
                      SaveImage(_image.path);
                    },
                    child: Text("Save")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void PickImage() async {
    //gallery
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image as File;
    });
  }

  void SaveImage(path) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    saveimage.setString("imagepath", path);
  }

  void loadImage() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveimage.getString("imagepath");
    });
  }
}
