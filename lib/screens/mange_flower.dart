import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/flowers.dart';
import '../providers/flower.dart';

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
    final flowersProvider = Provider.of<Flowers>(context);

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
              const Text('Add new flower'),
              const SizedBox(
                height: 32,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter the title'),
                controller: titleController..text = 'My Flower',
              ),
              Text('Title'),
              const SizedBox(
                height: 16,
              ),
              const Text('Description'),
              TextField(
                controller: descriptionController..text = 'My lovely flower',
                decoration:
                    const InputDecoration(hintText: 'Enter the description'),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('Price'),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter the price'),
                controller: priceController..text = "56.63",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('Image URL'),
              TextField(
                decoration:
                    const InputDecoration(hintText: 'Enter the image URL'),
                controller: imageUrlController
                  ..text =
                      "https://images.pexels.com/photos/1167050/pexels-photo-1167050.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                keyboardType: TextInputType.url,
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  print('Add Flower, Title > ${titleController.text}');
                  print(
                      'Add Flower, Description > ${descriptionController.text}');
                  print('Add Flower, Price > ${priceController.text}');
                  print('Add Flower, Image URL> ${imageUrlController.text}');

                  flowersProvider.addFlower(
                    Flower(
                        id: "",
                        title: titleController.text,
                        description: descriptionController.text,
                        imageUrl: imageUrlController.text,
                        price: double.parse(priceController.text),
                        isFavorite: false),
                  );
                },
                child: const Text('Add Flower'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
