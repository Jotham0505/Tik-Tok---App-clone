import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/models/user.dart' as model;
import 'package:tiktok/views/widgets/screens/auth/login_screen.dart';
import 'package:tiktok/views/widgets/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?>_user;
  late Rx<File?>_pickedImage;

  File? get profilePhoto => _pickedImage.value; // getter for _pickedImage
  User get user => _user.value!;

  @override
  void onReady(){
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user){
    if (user == null) {
      Get.offAll(() => LoginScreen()); // using the getx package to navigate through screens
    } else{
      Get.offAll(() => HomeScreen());
    }
  }

  void pickImage() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage!=null) {
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture');
    }

    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }



  // upload image to firebase storage
  Future<String> _uploadToStorage(File image) async { // uploading the image to the storage
    Reference ref = firebaseStorage
        .ref('users')
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // create a methodd to register the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save our user to out auth and save it's data to the firebase
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          email: email,
          name: username,
          profilePhoto: downloadUrl,
          uid: cred.user!.uid,
        );
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      }else{
        Get.snackbar('Error Creating an account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating an account', e.toString());
    }
  }


  void LoginUser(String email, String password)async{
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        print('login success');
      }else{
         Get.snackbar('Error Logging in Account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Logging in', e.toString());
    }
  }
}
