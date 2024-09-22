import 'package:clarigo_project/constanst/constans.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/providers/user_provider.dart';

class SelectedProfileScreen extends StatelessWidget {
  const SelectedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Selected Users')),
      body:
      userProvider.acceptedUsers.isEmpty
          ? Center(child: Text('No selected users', style: TextStyle(fontSize: 18)))
          :
      ListView.builder(
        itemCount: userProvider.acceptedUsers.length,
        itemBuilder: (context, index) {
          final user = userProvider.acceptedUsers[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage(AppConstants.appLogo)),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
