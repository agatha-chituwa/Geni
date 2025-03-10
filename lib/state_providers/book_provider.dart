
import 'dart:ffi';

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
  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  init() async {
    await getBooks();
  }

  Future<void> getBooks() async {
    _books = await _bookRepository.getBooks().first;
    notifyListeners();
  }

  Future<void> addBookofBusiness(Book book, DocumentReference businessReference) async {
    await _bookRepository.addBook(book);
    await addBusinessBook(
      BusinessBook(
        businessReference: businessReference, 
        bookReference: book.ref!, 
        createdAt: DateTime.now(), 
        updatedAt: DateTime.now(), 
      )
    );
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    await _bookRepository.updateBook(book);
    notifyListeners();
  }

  Future<void> deleteBook(Book book) async {
    await _bookRepository.deleteBook(book);
    notifyListeners();
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

  Future<List<BusinessBook>> getBusinessBooks(DocumentReference businessRef) async {
    final businessBooks = await _bookRepository.getBooksOfBusiness(businessRef);
    for (final b in businessBooks) {
      await loadBookMembers(b.book!);
    }
    return businessBooks;
  }

  Future<void> getUserBooks(DocumentReference userRef) async {
    _userBooks = await _bookRepository.getBooksOfUser(userRef);
    notifyListeners();
  }

  Future<void> addBookEntry(Book book, Entry entry) async {
    await _bookRepository.addBookEntry(book.ref!, entry);
    book.balance += entry.isCashIn? entry.amount : -entry.amount;
    book.totalCashIn += entry.isCashIn? entry.amount : 0;
    book.totalCashOut += entry.isCashIn? 0 : entry.amount;
    await updateBook(book);
    notifyListeners();
  }

  Future<void> updateEntry(Entry entry) async {
    await _bookRepository.updateEntry(entry);
  }

  Future<void> deleteEntry(Entry entry, Book book) async {
    await _bookRepository.deleteEntry(entry);
    book.balance -= entry.isCashIn? entry.amount : -entry.amount;
    book.totalCashIn -= entry.isCashIn? entry.amount : 0;
    book.totalCashOut -= entry.isCashIn? 0 : entry.amount;
    await updateBook(book);
    notifyListeners();
  }

  Future<List<Entry>> getEntriesOfBook(DocumentReference bookRef) async {
    _entries = await _bookRepository.getEntriesOfBook(bookRef);
    notifyListeners();
    debugPrint('Fetched entries ${_entries.length}');
    return _entries;
  }

  Future<List<double>> getBalances(Book book) async {
    final entries = await getEntriesOfBook(book.ref!);
    double totalCashIn = 0.0;
    double totalCashout = 0.0;
    for (final entry in entries) {
      totalCashIn += entry.isCashIn? entry.amount : 0;
      totalCashout += entry.isCashIn? 0 : entry.amount;
    }
    book.totalCashOut = totalCashout;
    book.totalCashIn = totalCashIn;
    book.balance = totalCashIn - totalCashout;
    return [totalCashIn, totalCashout, totalCashIn - totalCashout];
  }

  loadBookMembers(Book entity) async {
    entity.members = (await getBookMembers(entity.ref!)) ?? [];
  }

  getBookMembers(DocumentReference<Object?> documentReference) {
    _bookRepository.getMembersOfBook(documentReference);
  }

  removeUserBook(UserBook member) async {
    await member.ref!.delete();
  }
}