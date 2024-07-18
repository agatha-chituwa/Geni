
import 'package:flutter/material.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/book_model.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/model/user_book_model.dart';
import 'package:geni_app/model/user_model.dart';
import 'package:geni_app/state_providers/book_provider.dart';
import 'package:geni_app/state_providers/business_provider.dart';
import 'package:geni_app/state_providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../model/business_member_model.dart';

class MembersPage extends StatefulWidget {
  final bool isBusiness;
  final dynamic entity; // This will be either a Book or Business object

  const MembersPage({Key? key, required this.isBusiness, required this.entity}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<User> _searchResults = [];
  String? _selectedUser;
  String? _selectedRole;
  late Future<dynamic> membersLoadFuture;

  bool _addingMember = false;

  bool _removingMember = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  _loadMembers() {
    membersLoadFuture = widget.isBusiness
        ? Provider.of<BusinessProvider>(context, listen: false).loadBusinessMembers(widget.entity as Business)
        : Provider.of<BookProvider>(context, listen: false).loadBookMembers(widget.entity as Book);
  }

  @override
  Widget build(BuildContext context) {
    final entityName = widget.isBusiness ? (widget.entity as Business).name : (widget.entity as Book).name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Members of $entityName'),
        backgroundColor: const Color(0xFF19CA79),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<dynamic>(
        future: membersLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading members'));
          } else {
            return SingleChildScrollView(
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMemberList(),
                    const SizedBox(height: 20.0),
                    _buildSearchAndAddSection(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMemberList() {
    final members = widget.isBusiness
        ? (widget.entity as Business).members
        : (widget.entity as Book).members;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current Members',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20.0),
            ...members.map((member) => _buildMemberRow(member)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(dynamic member) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        member.member.name,
        style: const TextStyle(fontSize: 16.0),
      ),
      subtitle: Text(
        member.roleReference.id,
        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.remove, color: Colors.red),
        onPressed: () {
          _confirmRemove(member);
        },
      ),
    );
  }

  void _confirmRemove(dynamic member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Member'),
          content: Text('Are you sure you want to remove ${member.member.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _removeMember(member);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeMember(dynamic member) async {
    setState(() {
      _removingMember = true;
    });
    if (widget.isBusiness) {
      await Provider.of<BusinessProvider>(context, listen: false).removeBusinessMember(member);
    } else {
      await Provider.of<BookProvider>(context, listen: false).removeUserBook(member);
    }
    setState(() {
      _removingMember = false;
      _loadMembers();
    });
  }


  Widget _buildSearchAndAddSection() {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for a user',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _searchUsers,
            ),
            const SizedBox(height: 20.0),
            if (_searchResults.isNotEmpty)
              DropdownButtonFormField<String>(
                hint: const Text('Select a user'),
                items: _searchResults
                    .map((user) => DropdownMenuItem<String>(
                  value: user.email,
                  child: Text(user.name),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedUser = value),
                value: _selectedUser,
                decoration: const InputDecoration(
                  labelText: 'User',
                ),
              ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              hint: const Text('Select a role'),
              items: ['Admin', 'Editor', 'Viewer']
                  .map((role) => DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _selectedUser != null && _selectedRole != null ? _addMember : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19CA79),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: _addingMember? const CircularProgressIndicator() : const Text(
                'Add Member',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchUsers(String query) {
    // Simulate a user search, in a real scenario this would be an API call
    final allUsers = Provider.of<UsersProvider>(context, listen: false).users;
    setState(() {
      _searchResults.clear();
      _searchResults.addAll(allUsers.where((user) => user.name.toLowerCase().contains(query.toLowerCase())));
    });
  }

  Future<void> _addMember() async {
    final user = _searchResults.firstWhere((user) => user.email == _selectedUser);

    if (widget.isBusiness
      ? (widget.entity as Business).members.any((member) => member.member?.email == user.email)
    : (widget.entity as Book).members.any((member) => member.member?.email == user.email)) {
      _showAlreadyAddedMessage(user.name);
    } else {
      setState(() {
        _addingMember = true;
      });
      if (widget.isBusiness) {
        await Provider.of<BusinessProvider>(context, listen: false).addBusinessMember(
            BusinessMember(
                userReference: user.ref!,
                roleReference: DataModel().rolesCollection.doc(_selectedRole),
                businessReference: (widget.entity as Business).ref!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()));
      } else {
        await Provider.of<BookProvider>(context, listen: false).addUserBook(
            UserBook(
                userReference: user.ref!,
                roleReference: DataModel().rolesCollection.doc(_selectedRole),
                bookReference: (widget.entity as Book).ref!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()));
      }

      setState(() {
        _searchResults.clear();
        _selectedUser = null;
        _selectedRole = null;
        _searchController.clear();
        _addingMember = false;
        _loadMembers();
      });
    }
  }

  void _showAlreadyAddedMessage(String userName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$userName is already a member'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
