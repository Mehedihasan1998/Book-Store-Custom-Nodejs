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

  bool _isDarkMode = false;

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
      backgroundColor: _isDarkMode ? Colors.black12 : Colors.white,
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Books to Buy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: _isDarkMode ? Colors.black : Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                _isDarkMode = !_isDarkMode;
                setState(() {});
              },
              icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
                color: _isDarkMode ? Colors.yellow : Colors.white,
              )),
        ],
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
                          padding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                          itemCount: _books!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    _selectedBook = _books![index];

                                    _titleController.text =
                                        _selectedBook!.title;
                                    _authorController.text =
                                        _selectedBook!.author;
                                    _yearController.text =
                                        _selectedBook!.year.toString();
                                    _priceController.text =
                                        _selectedBook!.price.toString();
                                  },
                                  title: Text(
                                    "${_books![index].title} by ${_books![index].author} - released in ${_books![index].year}",
                                    style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Price: \$${_books![index].price}",
                                    style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _graphQLService.deleteBook(
                                            id: _books![index].id);
                                        _load();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: _isDarkMode
                                            ? Colors.yellow
                                            : Colors.red,
                                      )),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                              ],
                            );
                          },
                        ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _isEditMode = !_isEditMode;
                        setState(() {});
                      },
                      icon: Icon(
                        _isEditMode ? Icons.edit : Icons.add,
                        color: _isDarkMode ? Colors.red : Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: _titleController,
                              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: _isDarkMode ? Colors.yellow : Colors.purple)),
                                  border: OutlineInputBorder(),
                                  hintText: "Title",
                                  hintStyle: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white38
                                          : Colors.black54)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: _authorController,
                              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: _isDarkMode ? Colors.yellow : Colors.purple)),
                                  border: OutlineInputBorder(),
                                  hintText: "Author",
                                  hintStyle: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white38
                                          : Colors.black54)),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15.0, bottom: 15),
                                  child: TextField(
                                    controller: _yearController,
                                    style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: _isDarkMode ? Colors.yellow : Colors.purple)),
                                        border: OutlineInputBorder(),
                                        hintText: "Year",
                                        hintStyle: TextStyle(
                                            color: _isDarkMode
                                                ? Colors.white38
                                                : Colors.black54)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 15.0, bottom: 15),
                                  child: TextField(
                                    controller: _priceController,
                                    style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: _isDarkMode ? Colors.yellow : Colors.purple)),
                                        border: OutlineInputBorder(),
                                        hintText: "Price",
                                        hintStyle: TextStyle(
                                            color: _isDarkMode
                                                ? Colors.white38
                                                : Colors.black54)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_isEditMode) {
                          await _graphQLService.updateBook(
                              id: _selectedBook!.id,
                              title: _titleController.text,
                              author: _authorController.text,
                              year: int.parse(_yearController.text),
                              price: int.parse(_priceController.text));
                        } else {
                          await _graphQLService.createBook(
                              title: _titleController.text,
                              author: _authorController.text,
                              year: int.parse(_yearController.text),
                              price: int.parse(_priceController.text));
                        }
                        _load();
                        _clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: _isDarkMode ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
