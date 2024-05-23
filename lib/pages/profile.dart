import 'dart:io';
import 'package:DumendenNav/widgets/edit_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadImage();
    _populateTextFields();
  }

  File? _userImageFile;
  final _myBox = Hive.box('box');
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> _loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/user_image.jpg';
    print(imagePath);
    final File imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      setState(() {
        _userImageFile = imageFile;
      });
    }
  }

  void _populateTextFields() {
    // Retrieve values from Hive and set them to the controllers
    nameController.text = _myBox.get('name', defaultValue: '');
    ageController.text = _myBox.get('age', defaultValue: '');
    emailController.text = _myBox.get('email', defaultValue: '');
  }

  Widget _buildUserImage() {
    return _userImageFile == null
        ? Placeholder() // Placeholder for when no image is selected
        : Image.file(_userImageFile!); // Display the selected image
  }

  Future<void> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/user_image.jpg';
    await image.copy(imagePath);
    setState(() {
      _userImageFile = image;
    });
  }

  // //veri yazma örneği
  // void writeData() {
  //   _myBox.put('name', "Tayfun");
  // }

  // //veri okuma örneği
  // void readData() {
  //   print(_myBox.get('name'));
  // }

  // //veri silme örneği
  // void deleteData() {
  //   _myBox.delete('name');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                _myBox.put('name', nameController.text);
                _myBox.put('age', ageController.text);
                _myBox.put('email', emailController.text);
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(60, 50),
                elevation: 3,
              ),
              icon: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: const Text(
                  "Kişisel Bilgiler",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "",
                widget: Column(
                  children: [
                    _buildUserImage(),
                    TextButton(
                      onPressed: () async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File selectedImage = File(image.path);
                          _saveImage(selectedImage);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text("Fotoğraf Yükle"),
                    )
                  ],
                ),
              ),
              EditItem(
                title: "",
                widget: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'İsim')),
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextField(
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Yaş')),
                title: "",
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email')),
                title: "",
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
