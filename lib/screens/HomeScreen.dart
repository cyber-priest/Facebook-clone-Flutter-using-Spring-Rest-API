import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_facebook/provider/dataProvider.dart';
import 'package:provider/provider.dart';

// import '../config/data/data.dart';
import '../config/pallete.dart';
import '../models/Models.dart';
import '../widgets/CircleButton.dart';
import '../widgets/CreatePostContainer.dart';
import '../widgets/PostContainer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var posts = Provider.of<DataProvider>(context, listen: true).posts;
    var currentUser = context.read<DataProvider>().user;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text(
              'facebook',
              style: const TextStyle(
                color: Palette.facebookBlue,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2,
              ),
            ),
            floating: true,
            actions: [
              CircleButton(
                icon: Icons.search,
                iconSize: 30.0,
                onPressed: () {
                  var user = context.read<DataProvider>().user;
                  print(user);
                },
              ),
              CircleButton(
                icon: MdiIcons.facebookMessenger,
                iconSize: 30.0,
                onPressed: () async {
                  await context.read<DataProvider>().fetchPostContent();
                },
              ),
              CircleButton(
                icon: Icons.menu,
                iconSize: 30.0,
                onPressed: () async {
                  await context.read<DataProvider>().signout();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: CreatePostContainer(currentUser: currentUser),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final Post post = posts[index];
                return PostContainer(
                  post: post,
                  index: index,
                );
              },
              childCount: posts.length,
            ),
          )
        ],
      ),
    );
  }
}
