import 'dart:convert';

import 'package:expensetracker/expense_feature/data/model/expense_tracker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  late int dolor = 0;
  String dateTime = '';
  List<ExpenseTrackerModel> model = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController increaseAmountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late SharedPreferences _sharedPreferences;

  void getSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      dolor = _sharedPreferences.getInt('dolor') ?? 0;
      List<String>? contactListString =
      _sharedPreferences.getStringList('myData');
      if (contactListString != null) {
        model = contactListString
            .map((contact) => ExpenseTrackerModel.fromJson(json.decode(contact)))
            .toList();
      }
    });
  }

  saveModel() {
    //
    List<String> contactListString =
        model.map((contact) => jsonEncode(contact.toJson())).toList();
    _sharedPreferences.setStringList('myData', contactListString);
    //
  }



  @override
  void initState() {
    getSharedPreferences();
    super.initState();
    print(model.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        actions: const [
          Icon(
            Icons.person,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(
            width: 16,
          ),
        ],
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.deepPurple,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black.withOpacity(0.2),
        foregroundColor: Colors.white,
        onPressed: () {
          print(model.length);
          createExpense();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      minimumSize: Size(MediaQuery.of(context).size.width, 150),
                      backgroundColor: Colors.deepPurpleAccent),
                  onPressed: () {
                    increaseMoney();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "$dolor",
                            style: const TextStyle(
                                fontSize: 45, color: Colors.white),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            r"US",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            r'$',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 32,
              ),
              const Text(
                'All Expenses',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.shop,
                            color: Colors.grey[200],
                            size: 40,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "-${model[index].amount}",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  InkWell(
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      int number = int.parse(
                                          model[index].amount);
                                      setState(() {
                                        dolor += number;
                                      });
                                      model.removeAt(index);
                                      saveModel();
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'title:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Text(
                                model[index].name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'description:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Text(
                                model[index].description,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'date:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Text(
                                model[index].history,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: model.length,
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  void createExpense() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            color: Colors.deepPurpleAccent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Enter Amount',
                      filled: true,
                      fillColor: Colors.deepPurple,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16)),
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Enter Title',
                      filled: true,
                      fillColor: Colors.deepPurple,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16)),
                      prefixIcon: const Icon(
                        Icons.subtitles_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Enter description',
                      filled: true,
                      fillColor: Colors.deepPurple,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16)),
                      prefixIcon: const Icon(
                        Icons.description,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45)),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.7, 50),
                          backgroundColor: Colors.deepPurple),
                      onPressed: () {
                        int number = int.parse(amountController.text);
                        setState(() {
                          dolor -= number;
                          dateTime = DateFormat('MM/dd/yyyy - hh:mm')
                              .format(DateTime.now());
                        });
                        model.add(ExpenseTrackerModel(
                          name: nameController.text,
                          amount: amountController.text,
                          history: dateTime,
                          description: descriptionController.text,
                        ));
                        saveModel();
                        _sharedPreferences.setInt('dolor', dolor);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'add',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        });
  }

  void increaseMoney() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 200,
            color: Colors.deepPurpleAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: increaseAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.white),
                    labelText: 'Enter Amount',
                    filled: true,
                    fillColor: Colors.deepPurple,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(16)),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45)),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.7,
                                    50),
                                backgroundColor: Colors.green),
                            onPressed: () {
                              int number =
                                  int.parse(increaseAmountController.text);
                              setState(() {
                                dolor += number;
                                _sharedPreferences.setInt('dolor', dolor);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'increase',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ))),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45)),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.7,
                                    50),
                                backgroundColor: Colors.red),
                            onPressed: () {
                              int number =
                                  int.parse(increaseAmountController.text);
                              setState(() {
                                dolor -= number;
                                _sharedPreferences.setInt('dolor', dolor);
                                // saveDolor();
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'decrease',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ))),
                  ],
                )
              ],
            ),
          );
        });
  }
}
