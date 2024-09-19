// import "package: flutter/material.dart";
import "package:expense_app/components/expense_summary.dart";
import "package:expense_app/components/expense_tile.dart";
import "package:expense_app/data/expense_data.dart";
import "package:expense_app/models/expense_item.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseBirrAmountController = TextEditingController();
  final newExpenseSentsAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // prepare data on startup

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("አዲስ ወጪ ያስገቡ"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newExpenseNameController,
                    decoration: InputDecoration(hintText: "የወጪው ስም"),
                  ),
                  Row(
                    children: [
                      // birr
                      Expanded(
                        child: TextField(
                          controller: newExpenseBirrAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "ብር"),
                        ),
                      ),
                      // sntes
                      Expanded(
                        child: TextField(
                          controller: newExpenseSentsAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "ሳንቲም"),
                        ),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                ),
              ],
            ));
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseBirrAmountController.text.isNotEmpty) {
      String amount = newExpenseBirrAmountController.text +
          '.' +
          newExpenseSentsAmountController.text;
      ExpenseItem newExpense = ExpenseItem(
        amount: amount,
        name: newExpenseNameController.text,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);

      Navigator.pop(context);
      clear();
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseBirrAmountController.clear();
    newExpenseSentsAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: Icon(Icons.add),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                // weekly summary
                ExpenseSummary(startOfWeek: value.startOfWeekDate()),

                const SizedBox(height: 20),

                // expense list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime,
                    deleteTapped: (p0) =>
                        deleteExpense(value.getAllExpenseList()[index]),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
