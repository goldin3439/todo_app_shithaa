import 'package:flutter/material.dart';
import 'package:todo_app_shithaa/sql_help.dart';

class TUDOPAGE extends StatefulWidget {
  const TUDOPAGE({Key? key}) ;

  @override
  State<TUDOPAGE> createState() => _TUDOPAGEState();
}

class _TUDOPAGEState extends State<TUDOPAGE> {
  final _formkey=GlobalKey<FormState>();
  //All journals
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }
    showModalBottomSheet(

        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Enter title';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Enter Title';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      if (id == null) {
                        await _addItem();
                        Navigator.of(context).pop();
                        _titleController.text = '';
                        _descriptionController.text = '';
                      }
                    }
                    if (id != null) {
                      await _updateItem(id);
                      Navigator.of(context).pop();
                      _titleController.text = '';
                      _descriptionController.text = '';
                    }
                    // _titleController.text = '';
                    // _descriptionController.text = '';
                  },
                  child: Text(id == null ? 'Create New' : 'Update'),
                )
              ],
            ),
          ),
        ));
  }
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }
  void_deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLUESEA',
          style: TextStyle(
            fontFamily: "LilitaOne"
          ),
      ),),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Color.fromRGBO(255, 204, 204 ,1.0),
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['title'],style: TextStyle(
    fontFamily: "LilitaOne",
    fontSize: 28
    ),),
              subtitle: Text(_journals[index]['description'],
              style: TextStyle(
                fontFamily: "LilitaOne"
              ),
              ),
          trailing: SizedBox(
          width: 100,
          child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showForm(_journals[index]['id']),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () =>
              void_deleteItem(_journals[index]['id']),
        ),
        ],
      ),
          )),
    ),
      ),
        floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}