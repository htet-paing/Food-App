import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwhp_flutter/model/food.dart';
import 'package:cwhp_flutter/model/user.dart';
import 'package:cwhp_flutter/provider/auth_provider.dart';
import 'package:cwhp_flutter/provider/food_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'as path;
import 'package:uuid/uuid.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> login(AUser aUser, AuthProvider authProvider) async {
  try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: aUser.email, password: aUser.password);
      if (userCredential != null) {
        User user = userCredential.user;
        if (user != null) {
          print("LOggedIn : $user");
          authProvider.setUser(user);
        }
      }
      
  } catch(error) {
    print(error);
  } 
}

Future<void> signup(AUser aUser, AuthProvider authProvider) async {
  try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: aUser.email, password: aUser.password);
      
      if (userCredential != null) {
        User user = userCredential.user;

        if (user != null) {
          await _auth.currentUser.updateProfile(displayName: aUser.displayName);
          await user.reload();
          print("SignUp: $user");
          User currentUser =  _auth.currentUser;
          authProvider.setUser(currentUser);
        }
      }
    }catch (error) {
      print(error);
    }
}

Future<void> signout(AuthProvider authProvider) async {
  await _auth.signOut();
  authProvider.setUser(null);
}

Future<User> initializeCurrentUser() async{
  User user =   _auth.currentUser;
  if (user != null) {
    return user;
  }else {
    return null;
  }
}

Future<void> getFoods(FoodProvider foodProvider) async {
  Query snapshot = FirebaseFirestore.instance
  .collection('Foods')
  .orderBy("createdAt", descending: true);
  List<Food> _foodList = [];

  await snapshot.get().then((querySnapshot) async {
    querySnapshot.docs.forEach((document) { 
      Food food = Food.fromJson(document.data());
      _foodList.add(food);
    });
  });
    foodProvider.foodList = _foodList;  
}

 Future<void> uploadFoodAndImage(Food food,bool isUpdating, File localImage, Function foodUploaded) async{
    if (localImage != null) {
      print("Updating Image");

      var fileExtension = path.extension(localImage.path);
      print("FileExtension : $fileExtension");
      
      var uuId = Uuid().v4();

      final StorageReference storageReference = 
        FirebaseStorage().ref().child('foods/images/$uuId$fileExtension');
      await storageReference.putFile(localImage).onComplete.catchError((onError) {
        print(onError);
        return false;
      });

      String url = await storageReference.getDownloadURL();
      print("Download URL : $url");
      
      //Upload Food
      _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
    }else {
      print("....Skipping image Upload");
      _uploadFood(food, isUpdating, foodUploaded);
    }
  }

  _uploadFood(Food food, bool isUpdating, Function foodUploaded, {String imageUrl}) async {
    CollectionReference foodRef = FirebaseFirestore.instance.collection('Foods');
    if (imageUrl != null) {
      food.image = imageUrl;
    }

    if (isUpdating) {
      //Update Food
      food.updatedAt = Timestamp.now();
      await foodRef.doc(food.id).update(food.toJson());
      foodUploaded(food);
      print("Updated Food with ID : ${food.id}");
    }else {
      //Create Food
      food.createdAt = Timestamp.now();
      DocumentReference documentRef  = await foodRef.add(food.toJson());
      food.id = documentRef.id;
      print("Uploaded Food SuccessFully : ${food.toString()}");
      
      await documentRef.set(food.toJson());
      foodUploaded(food);
    }
  }

  Future<void> deleteFood(Food food, Function foodDeleted) async {
    if (food.image != null) {
      StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(food.image);
      print(storageReference.path);
      await storageReference.delete();
    }
    await FirebaseFirestore.instance.collection('Foods').doc(food.id).delete();
    foodDeleted(food);
  }


