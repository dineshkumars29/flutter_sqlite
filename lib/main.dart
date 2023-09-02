import 'package:flutter/material.dart';
import 'package:sqlight/database/dbHelper.dart';
import 'package:sqlight/model/dish.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String? name, description;
  double? price;

  createData() async {
    setState(() {
      var dbHelper = DbHelper();
      var dish = Dish(name, description, price);
      dbHelper.createDishData(dish);
    });
  }

  readData() {
    var dbHelper = DbHelper();
    Future<Dish> dish = dbHelper.readDishData(name);
    // ignore: avoid_print
    dish.then((value) => print(value.name));
  }

  updateData() {
    setState(() {
      var dbHelper = DbHelper();
      var dish = Dish(name, description, price);
      dbHelper.updateDishData(dish);
    });
  }

  deleteData() {
    setState(() {
      var dbHelper = DbHelper();
      //var dish = Dish(name, description, price);
      dbHelper.deleteDishData(name);
    });
  }

  Future<List<Dish>> getAllDishData() async {
    var dbHelper = DbHelper();
    Future<List<Dish>> dishes = dbHelper.getAllDatasFromSql();
    return dishes;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text("Name"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Description"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: descriptionController,
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Price"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: priceController,
                  onChanged: (value) {
                    price = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => createData(),
                      child: const Text("Create")),
                  ElevatedButton(
                      onPressed: () => readData(), child: const Text("Read")),
                  ElevatedButton(
                      onPressed: () => updateData(),
                      child: const Text("Update")),
                  ElevatedButton(
                      onPressed: () => deleteData(),
                      child: const Text("Delete")),
                ],
              ),
              FutureBuilder<List<Dish>>(
                future: getAllDishData(),
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                  child: Text("${snapshot.data?[index].name}")),
                              Expanded(
                                  child: Text(
                                      "${snapshot.data?[index].description}")),
                              Expanded(
                                  child:
                                      Text("${snapshot.data?[index].price}")),
                            ],
                          );
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
