import 'package:flutter/material.dart';

class ManageFlower extends StatefulWidget {
  static const screenName = "/mange_flower";

  // const ManageFlower({Key? key}) : super(key: key);
  const ManageFlower({Key? key}) : super(key: key);

  @override
  State<ManageFlower> createState() => _ManageFlowerState();
}

class _ManageFlowerState extends State<ManageFlower> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final priceController = TextEditingController();

  final imageUrlController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ManageFlower'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add new flower'),
              SizedBox(
                height: 32,
              ),
              Text('Title'),
              TextField(
                decoration: InputDecoration(hintText: 'Enter the title'),
                controller: titleController,
              ),
              SizedBox(
                height: 16,
              ),
              Text('Description'),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Enter the description'),
              ),
              SizedBox(
                height: 16,
              ),
              Text('Price'),
              TextField(
                decoration: InputDecoration(hintText: 'Enter the price'),
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 16,
              ),
              Text('Image URL'),
              TextField(
                decoration: InputDecoration(hintText: 'Enter the image URL'),
                controller: imageUrlController,
                keyboardType: TextInputType.url,
              ),
              SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  print('Add Flower, Title > ${titleController.text}');
                  print(
                      'Add Flower, Description > ${descriptionController.text}');
                  print('Add Flower, Price > ${priceController.text}');
                  print('Add Flower, Image URL> ${imageUrlController.text}');
                },
                child: Text('press'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
