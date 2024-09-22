import 'package:clarigo_project/constanst/constans.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/providers/user_provider.dart';

class RejectedProfileScreen extends StatelessWidget {
  const RejectedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Rejected Users')),
      body:

      userProvider.declinedUsers.isEmpty
          ? Center(child: Text('No rejected users', style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: userProvider.declinedUsers.length,
        itemBuilder: (context, index) {
          final user = userProvider.declinedUsers[index];
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
