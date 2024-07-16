import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/state_providers/auth_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:provider/provider.dart';

import 'business_details.dart';
import 'business_form.dart';
import 'home_page.dart';

class BusinessListPage extends StatefulWidget {
  const BusinessListPage({Key? key}) : super(key: key);

  @override
  _BusinessListPageState createState() => _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  List<BusinessMember> _userBusinesses = [];
  BusinessMember? _personalBusiness;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinesses();
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.addListener(_businessesUpdated);
  }

  @override
  void dispose() {
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.removeListener(_businessesUpdated);
    super.dispose();
  }

  void _businessesUpdated() {
    setState(() {
      _userBusinesses = _process(Provider.of<BusinessProvider>(context, listen: false).userBusinesses);
      _isLoading = Provider.of<BusinessProvider>(context, listen: false).isLoading;
    });
  }

  void _loadBusinesses() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.loadUserBusinesses(DataModel().usersCollection.doc(authProvider.currentUser!.email!));
  }

  Future<void> _navigateToAddBusiness() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BusinessForm()));
    _businessesUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userBusinesses.isEmpty && _personalBusiness == null
          ? const Center(
        child: Text(
          "You don't have any businesses.\nClick + to register a business.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Column(
        children: [
          if (_personalBusiness != null)
            Card(
              elevation: 2.0,
              shape: const RoundedRectangleBorder(),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                leading: Icon(Icons.wallet, size: 40, color: Colors.amber[800]),
                title: Text(
                  _personalBusiness?.business!.name ?? "",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),

                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BusinessDetailPage(business: _personalBusiness!)));
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _userBusinesses.length,
              itemBuilder: (context, index) {
                final business = _userBusinesses[index];
                return Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(2, 2))),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 1.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    leading: Icon(Icons.business, size: 40, color: Color(0xFF19CA79)),
                    title: Text(
                      business.business!.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(
                      'Location: ${business.business!.location}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BusinessDetailPage(business: business)));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddBusiness,
        backgroundColor: const Color(0xFF19CA79),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Business', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  List<BusinessMember> _process(List<BusinessMember> userBusinesses) {
    _personalBusiness = userBusinesses.firstWhere(
          (business) => business.business?.numberOfEmployees == -101,
    );
    if (_personalBusiness != null) {
      userBusinesses = userBusinesses.where((business) => business.business?.numberOfEmployees != -101).toList();
    }
    return userBusinesses;
  }
}
