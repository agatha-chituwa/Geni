import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/faq_model.dart';

class FAQRepository {
  final DataModel _dataModel = DataModel();

  Future<void> addFAQ(FAQ faq) {
    faq.ref = _dataModel.faqCollection.doc();
    return faq.ref!.set(faq.toMap());
  }

  Stream<List<FAQ>> getFAQs() {
    return _dataModel.faqCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => FAQ.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> updateFAQ(FAQ faq) {
    return faq.ref!.update(faq.toMap());
  }

  Future<void> deleteFAQ(FAQ faq) {
    return faq.ref!.delete();
  }

  Future<FAQ> getFAQById(String id) {
    return _dataModel.faqCollection.doc(id).get().then((doc) => FAQ.fromMap(doc.data() as Map<String, dynamic>));
  }
}
