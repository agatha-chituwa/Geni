import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/repositories/business_repository.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessRepository _businessRepository = BusinessRepository();

  List<Business> _businesses = [];

  bool isLoading = false;
  List<Business> get businesses => _businesses;

  List<BusinessMember> _userBusinesses = [];
  List<BusinessMember> get userBusinesses => _userBusinesses;

  init(DocumentReference? userReference) async {
    await _loadBusinesses();
    if (userReference != null) loadUserBusinesses(userReference);
  }

  Future<void> _loadBusinesses() async {
    try {
      _businesses = await _businessRepository.getBusinesses().first;
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<void> addBusiness(Business business, DocumentReference userReference) async {
    try {
      await _businessRepository.addBusiness(business);
      _businesses.add(business);
      await _businessRepository.addUserBusiness(
        BusinessMember(
          userReference: userReference, 
          roleReference: DataModel().rolesCollection.doc("owner"), 
          businessReference: business.ref!, 
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now()
        )
      );
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<void> updateBusiness(Business business) async {
    try {
      await _businessRepository.updateBusiness(business);
      final index = _businesses.indexWhere((u) => u.ref == business.ref);
      if (index >= 0) {
        _businesses[index] = business;
        notifyListeners();
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> deleteBusiness(Business business) async {
    try {
      await _businessRepository.deleteBusiness(business);
      _businesses.remove(business);
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<Business> getBusinessById(String id) async {
    return await _businessRepository.getBusinessById(id);
  }

  Future<void> getBussinessesOf(DocumentReference userRef) async {
    _userBusinesses = await _businessRepository.getUserBusinesses(userRef);
  }

  loadUserBusinesses(DocumentReference userReference) async {
    try {
      isLoading = true;
      //notifyListeners();
      _userBusinesses = await _businessRepository.getUserBusinesses(userReference);
      isLoading = false;
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }
  
}