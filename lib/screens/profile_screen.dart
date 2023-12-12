import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/resources/auth_method.dart';
import 'package:flutter_danthocode_instagram_clone/resources/firestore_method.dart';
import 'package:flutter_danthocode_instagram_clone/screens/login_screen.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/utils/global_variables.dart';
import 'package:flutter_danthocode_instagram_clone/utils/utils.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/follow_button.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/menu_card.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int followings = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();

      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      followings = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Loader()
        : Scaffold(
            backgroundColor: width > webScreenSize ? InstagramColor.webBackgroundColor : InstagramColor.mobileBackgroundColor,
            appBar: width > webScreenSize
                ? null
                : AppBar(
                    backgroundColor: InstagramColor.mobileBackgroundColor,
                    title: Text(userData['username']),
                    centerTitle: false,
                    actions: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: InstagramColor.mobileBackgroundColor,
                              builder: (context) {
                                return MenuCard(
                                  text: 'Sign Out',
                                  icon: Icons.settings,
                                  onTap: () async {
                                    await AuthMethod().signOut();
                                    if (!mounted) return;
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                );
                              });
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: width > webScreenSize
                      ? EdgeInsets.symmetric(
                          horizontal: width * 0.3,
                          vertical: 15,
                        )
                      : const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    profileStates(context, 'Posts', postLength),
                                    profileStates(context, 'Followers', followers),
                                    profileStates(context, 'Followings', followings),
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid == widget.uid
                                    ? FollowButton(
                                        backgroundColor: InstagramColor.mobileBackgroundColor,
                                        borderColor: Colors.grey,
                                        textColor: InstagramColor.primaryColor,
                                        text: 'Edit profile',
                                        onPressed: () {},
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            backgroundColor: InstagramColor.primaryColor,
                                            borderColor: InstagramColor.primaryColor,
                                            textColor: Colors.black,
                                            text: 'Unfollow',
                                            onPressed: () async {
                                              await FirestoreMethod().followUser(
                                                FirebaseAuth.instance.currentUser!.uid,
                                                userData['uid'],
                                              );

                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            backgroundColor: InstagramColor.blueColor,
                                            borderColor: InstagramColor.blueColor,
                                            textColor: InstagramColor.primaryColor,
                                            text: 'Follow',
                                            onPressed: () async {
                                              await FirestoreMethod().followUser(
                                                FirebaseAuth.instance.currentUser!.uid,
                                                userData['uid'],
                                              );
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(userData['bio']),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where(
                              'uid',
                              isEqualTo: widget.uid,
                            )
                            .get(),
                        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Loader();
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot snap = snapshot.data!.docs[index];
                              return Image(
                                image: NetworkImage(
                                  snap['postUrl'],
                                ),
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Column profileStates(BuildContext context, String text, int number) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(text),
        ),
      ],
    );
  }
}
