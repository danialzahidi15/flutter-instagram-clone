import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/models/user_model.dart';
import 'package:flutter_danthocode_instagram_clone/providers/user_model_provider.dart';
import 'package:flutter_danthocode_instagram_clone/resources/firestore_method.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/utils/utils.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  void postImage(String uid, String username, String profilePic) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethod().uploadPost(
        _captionController.text,
        _file!,
        uid,
        username,
        profilePic,
      );

      if (!mounted) return;
      if (res == 'Success') {
        setState(() {
          _isLoading = false;
        });
        showSnackbar('Posted', context);
        clearImage();
      } else {
        _isLoading = false;
        showSnackbar(res, context);
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose photo from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModelProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                color: InstagramColor.primaryColor,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: InstagramColor.mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    userModel.uid,
                    userModel.username,
                    userModel.photoUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              title: const Text('Post to'),
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',),
                      backgroundImage: NetworkImage(userModel.photoUrl),
                      // backgroundColor: Colors.grey,
                      // child: Icon(
                      //   Icons.person,
                      //   color: InstagramColor.primaryColor,
                      // ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _captionController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a caption...',
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 455,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
