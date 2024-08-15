import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/model/user_model.dart';

class BusinessRepository {
  final DataModel _dataModel = DataModel();

  Future<void> addBusiness(Business business) async {
    business.ref = _dataModel.businessesCollection.doc();
    return business.ref!.set(business.toMap());
  }

  Stream<List<Business>> getBusinesses() {
    return _dataModel.businessesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Business.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<List<BusinessMember>> getBusinessMembers(DocumentReference businessRef) async {
    final businessMembers = (await _dataModel.businessMembersCollection.where('businessReference', isEqualTo: businessRef).get())
        .docs.map((doc) => BusinessMember.fromMap(doc.data() as Map<String, dynamic>)).toList();

    for (var element in businessMembers) {
    await element.userReference.get().then((value) {
    element.member = User.fromMap(value.data() as Map<String, dynamic>);
    });
    }

    return businessMembers;
  }

  Future<void> updateBusiness(Business business) {
    return business.ref!.update(business.toMap());
  }

  Future<void> deleteBusiness(Business business) async {
    for(final b in (await _dataModel.businessBookCollection.where('businessReference', isEqualTo: business.ref).get()).docs) {
      b.reference.delete();
    }
    for(final b in (await _dataModel.businessMembersCollection.where('businessReference', isEqualTo: business.ref).get()).docs) {
      b.reference.delete();
    }
    return business.ref!.delete();
  }

  Future<Business> getBusinessById(String id) {
    return _dataModel.businessesCollection.doc(id).get().then((doc) => Business.fromMap(doc.data() as Map<String, dynamic>));
  }

  Future<List<BusinessMember>> getUserBusinesses(DocumentReference userReference) async {
    final businessMembers = (await _dataModel.businessMembersCollection.where('userReference', isEqualTo: userReference).get())
        .docs.map((doc) => BusinessMember.fromMap(doc.data() as Map<String, dynamic>)).toList();

    for (var element in businessMembers) {
      await element.businessReference.get().then((value) {
        element.business = Business.fromMap(value.data() as Map<String, dynamic>);
      });
    }

    return businessMembers;
  }

  Future<void> addUserBusiness(BusinessMember businessMember) async {
    businessMember.ref = _dataModel.businessMembersCollection.doc();
    await businessMember.ref!.set(businessMember.toMap());
  }
}
