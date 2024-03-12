
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/model/business_book_model.dart';
import 'package:geni_app/model/entry_model.dart';
import 'package:geni_app/model/user_book_model.dart';
import 'package:geni_app/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();

  List<Book> _books = [];
  List<Book> get books => _books;
  List<UserBook> _userBooks = [];
  List<UserBook> get userBooks => _userBooks;
  List<BusinessBook> _businessBooks = [];
  List<BusinessBook> get businessBooks => _businessBooks;
  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  Future<void> getBooks() async {
    _books = await _bookRepository.getBooks().first;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await _bookRepository.addBook(book);
    await getBooks();
  }

  Future<void> updateBook(Book book) async {
    await _bookRepository.updateBook(book);
    await getBooks();
  }

  Future<void> deleteBook(Book book) async {
    await _bookRepository.deleteBook(book);
    await getBooks();
  }

  Future<Book> getBookById(String id) async {
    return await _bookRepository.getBookById(id);
  }

  Future<void> addUserBook(UserBook userBook) async {
    await _bookRepository.addUserBook(userBook);
  }

  Future<void> deleteUserBook(UserBook userBook) async {
    await _bookRepository.deleteUserBook(userBook);
  }

  Future<void> updateUserBook(UserBook userBook) async {
    await _bookRepository.updateUserBook(userBook);
  }

  Future<void> addBusinessBook(BusinessBook businessBook) async {
    await _bookRepository.addBusinessBook(businessBook);
  }

  Future<void> deleteBusinessBook(BusinessBook businessBook) async {
    await _bookRepository.deleteBusinessBook(businessBook);
  }

  Future<void> updateBusinessBook(BusinessBook businessBook) async {
    await _bookRepository.updateBusinessBook(businessBook);
  }

  Future<void> getBusinessBooks(DocumentReference businessRef) async {
    _businessBooks = await _bookRepository.getBooksOfBusiness(businessRef);
    notifyListeners();
  }

  Future<void> getUserBooks(DocumentReference userRef) async {
    _userBooks = await _bookRepository.getBooksOfUser(userRef);
    notifyListeners();
  }

  Future<void> addBookEntry(DocumentReference bookRef, Entry entry) async {
    await _bookRepository.addBookEntry(bookRef, entry);
  }

  Future<void> updateEntry(Entry entry) async {
    await _bookRepository.updateEntry(entry);
  }

  Future<void> deleteEntry(Entry entry) async {
    await _bookRepository.deleteEntry(entry);
  }

  Future<List<Entry>> getEntriesOfBook(DocumentReference bookRef) async {
    _entries = await _bookRepository.getEntriesOfBook(bookRef);
    notifyListeners();
    return _entries;
  }

}