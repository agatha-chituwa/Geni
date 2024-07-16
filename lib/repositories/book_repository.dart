import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/model/business_book_model.dart';
import 'package:geni_app/model/entry_model.dart';
import 'package:geni_app/model/user_book_model.dart';

class BookRepository {
  final DataModel _dataModel = DataModel();

  Future<void> addBook(Book book) {
    book.ref = _dataModel.booksCollection.doc();
    return book.ref!.set(book.toMap());
  }

  Stream<List<Book>> getBooks() {
    return _dataModel.booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> updateBook(Book book) {
    return book.ref!.update(book.toMap());
  }

  Future<void> deleteBook(Book book) async {
    final bb = await _dataModel.businessBookCollection.where('bookReference', isEqualTo: book.ref).get();
    for(final b in bb.docs) {
      b.reference.delete();
    }
    final bu = await _dataModel.userBookCollection.where('bookReference', isEqualTo: book.ref).get();
    for(final b in bu.docs) {
      b.reference.delete();
    }
    return book.ref!.delete();
  }

  Future<Book> getBookById(String id) {
    return _dataModel.booksCollection.doc(id).get().then((doc) => Book.fromMap(doc.data() as Map<String, dynamic>));
  }

  Future<void> addUserBook(UserBook userBook) {
    userBook.ref = _dataModel.userBookCollection.doc();
    return userBook.ref!.set(userBook.toMap());
  }

  // Delete a user book
  Future<void> deleteUserBook(UserBook userBook) {
    return userBook.ref!.delete();
  }

  // Update a user book
  Future<void> updateUserBook(UserBook userBook) {
    return userBook.ref!.update(userBook.toMap());
  }

  Future<void> addBusinessBook(BusinessBook businessBook) {
    businessBook.ref = _dataModel.businessBookCollection.doc();
    return businessBook.ref!.set(businessBook.toMap());
  }

  // Delete a business book
  Future<void> deleteBusinessBook(BusinessBook businessBook) {
    return businessBook.ref!.delete();
  }

  // Update a business book
  Future<void> updateBusinessBook(BusinessBook businessBook) {
    return businessBook.ref!.update(businessBook.toMap());
  }

  Future<void> addBookEntry(DocumentReference bookRef, Entry entry) {
    entry.ref = _dataModel.entriesCollection(bookRef).doc();
    return entry.ref!.set(entry.toMap());
  }

  // Update an entry
  Future<void> updateEntry(Entry entry) {
    return entry.ref!.update(entry.toMap());
  }

  // Delete an entry
  Future<void> deleteEntry(Entry entry) {
    return entry.ref!.delete();
  }

  Future<List<Entry>> getEntriesOfBook(DocumentReference bookRef) async {
    final entries = (await _dataModel.entriesCollection(bookRef).get())
        .docs.map((doc) => Entry.fromMap(doc.data() as Map<String, dynamic>)).toList();
    return entries;
  }

  Future<List<Entry>> getEntriesOfBookByDate(DocumentReference bookRef, DateTime date) async {
    final entries = (await _dataModel.entriesCollection(bookRef).where('date', isEqualTo: date).get())
        .docs.map((doc) => Entry.fromMap(doc.data() as Map<String, dynamic>)).toList();
    return entries;
  }

  Future<List<Entry>> getEntriesOfBookByDateRange(DocumentReference bookRef, DateTime startDate, DateTime endDate) async {
    final entries = (await _dataModel.entriesCollection(bookRef).where('date', isGreaterThanOrEqualTo: startDate).where('date', isLessThanOrEqualTo: endDate).get())
        .docs.map((doc) => Entry.fromMap(doc.data() as Map<String, dynamic>)).toList();
    return entries;
  }

  // Retrieve all books of a business
  Future<List<BusinessBook>> getBooksOfBusiness(DocumentReference businessRef) async {
    final businessBooks = (await _dataModel.businessBookCollection.where('businessReference', isEqualTo: businessRef).get())
         .docs.map((doc) => BusinessBook.fromMap(doc.data() as Map<String, dynamic>)).toList();
    for (var element in businessBooks) {
      await element.bookReference.get().then((value) {
        element.book = Book.fromMap(value.data() as Map<String, dynamic>);
      });
    }
    return businessBooks;
  }

  // Retrieve all books of a user
  Future<List<UserBook>> getBooksOfUser(DocumentReference userRef) async {
    final userBooks = (await _dataModel.userBookCollection.where('userReference', isEqualTo: userRef).get())
        .docs.map((doc) => UserBook.fromMap(doc.data() as Map<String, dynamic>)).toList();
    for (var element in userBooks) {
      await element.bookReference.get().then((value) {
        element.book = Book.fromMap(value.data() as Map<String, dynamic>);
      });
    }
    return userBooks;
  }
}
