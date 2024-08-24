import 'package:book_store_nodejs/graphql/graphql_service.dart';
import 'package:book_store_nodejs/model/book_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BookModel>? _books;
  GraphQLService _graphQLService = GraphQLService();

  bool _isEditMode = false;
  BookModel? _selectedBook;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _books = null;
    _books = await _graphQLService.getBooks(limit: 5);
    setState(() {});
  }

  void _clear() {
    _titleController.clear();
    _authorController.clear();
    _priceController.clear();
    _yearController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Books",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _books == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: _books!.isEmpty
                      ? const Center(
                          child: Text("No Books"),
                        )
                      : ListView.builder(
                          itemCount: _books!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                _selectedBook = _books![index];

                                _titleController.text = _selectedBook!.title;
                                _authorController.text = _selectedBook!.author;
                                _yearController.text = _selectedBook!.year.toString();
                                _priceController.text = _selectedBook!.price.toString();
                              },
                              title: Text(
                                  "${_books![index].title} by ${_books![index].author}"),
                              subtitle:
                                  Text("Released: ${_books![index].year}"),
                              trailing: IconButton(
                                  onPressed: () {
                                    _graphQLService.deleteBook(
                                        id: _books![index].id);
                                    _load();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            );
                          },
                        ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _isEditMode = !_isEditMode;
                        setState(() {

                        });
                      },
                      icon: Icon(_isEditMode ? Icons.edit : Icons.add),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(hintText: "Title"),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: _authorController,
                              decoration: InputDecoration(hintText: "Author"),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: _yearController,
                              decoration: InputDecoration(hintText: "Year"),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: _priceController,
                              decoration: InputDecoration(hintText: "Price"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          if(_isEditMode) {
                            await _graphQLService.updateBook(
                              id: _selectedBook!.id,
                                title: _titleController.text,
                                author: _authorController.text,
                                year: int.parse(_yearController.text),
                                price: int.parse(_priceController.text));
                          }else {
                            await _graphQLService.createBook(
                                title: _titleController.text,
                                author: _authorController.text,
                                year: int.parse(_yearController.text),
                                price: int.parse(_priceController.text));
                          }
                          _load();
                          _clear();
                        },
                        icon: Icon(Icons.send),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
