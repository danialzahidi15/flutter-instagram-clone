import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/screens/profile_screen.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: InstagramColor.mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search for user',
            suffixIcon: isShowUser
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isShowUser = false;
                      });
                      searchController.text = '';
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: InstagramColor.primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Loader();
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  uid: snapshot.data!.docs[index]['uid'],
                                )));
                      },
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                        //   backgroundImage: NetworkImage(
                        //     snapshot.data!.docs[index]['photoUrl'],
                        //   ),
                        ),
                        title: Text(
                          snapshot.data!.docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loader();
                }
                return Container();
                // return GridView.builder(
                //   itemCount: snapshot.data!.docs.length,
                //   gridDelegate: ,
                //   crossAxisCount: 3,
                //   itemBuilder: (context, index) {
                //     return StaggeredGrid.count(crossAxisCount: 4,);
                //   },
                // );
              },
            ),
    );
  }
}
