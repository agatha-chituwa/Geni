import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/repositories/business_repository.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessRepository _businessRepository = BusinessRepository();

  List<Business> _businesses = [];
  List<Business> get businesses => _businesses;

  List<BusinessMember> _userBusinesses = [];
  List<BusinessMember> get userBusinesses => _userBusinesses;

  init() async {
    await _loadBusinesses();
  }

  Future<void> _loadBusinesses() async {
    try {
      _businesses = await _businessRepository.getBusinesses().first;
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<void> addBusiness(Business business) async {
    try {
      await _businessRepository.addBusiness(business);
      _businesses.add(business);
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
  
}