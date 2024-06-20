
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/search.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/type_def.dart';
import '../../../model/user_model.dart';

final loginRepositoryProvider=Provider((ref) => LoginRepository(firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider)));

class LoginRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  LoginRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })
      : _firestore = firestore,
        _auth = auth;

  CollectionReference get _userCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  // login({required String password, required String email}) async {
  //   try {
  //     QuerySnapshot User = await
  //     _userCollection
  //         .where("email", isEqualTo: email)
  //         .where("password", isEqualTo: password)
  //         .get();
  //     if (User.docs.isEmpty) {
  //       throw "user not exist";
  //     } else {
  //       if (kDebugMode) {
  //         print(User.docs[0]);
  //       }
  //       if (kDebugMode) {
  //         print("Admin.docs[0]");
  //       }
  //       final SharedPreferences userDatas = await SharedPreferences
  //           .getInstance();
  //       QueryDocumentSnapshot<Object?> data = User.docs[0];
  //       currentUserID = data.id;
  //       currentUserName = data.get("name");
  //       currentUserEmail = data.get("email");
  //       userDatas.setString('uid', data.id);
  //       userDatas.setString('email', currentUserEmail);
  //       currentUserID = data.id;
  //       user = UserModel.fromMap(
  //           User.docs.first.data() as Map<String, dynamic>);
  //     }
  //     return right(user);
  //   } on FirebaseException catch (e) {
  //     throw e.message ?? '';
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     return left(Failure(e.toString()));
  //   }
  // }
  //
  // FutureEither<UserModel?> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserModel? userModel;
  //     QuerySnapshot users = await _userCollection
  //         .where('email', isEqualTo: email)
  //         .get();
  //     if (users.docs.isEmpty) {
  //       throw "UserName  Not Exist";
  //     } else {
  //       final SharedPreferences userDatas =
  //       await SharedPreferences.getInstance();
  //       QueryDocumentSnapshot<Object?> data = users.docs[0];
  //       if (data.get("password") != password) {
  //         throw "password not exist";
  //       }
  //       currentUserID = data.id;
  //       currentUserName = data.get("name");
  //       userDatas.setString("uid", currentUserID);
  //       userDatas.setString("username", currentUserName);
  //       userModel =
  //           UserModel.fromMap(data.data() as Map<String, dynamic>);
  //       return right(userModel);
  //     }
  //   } on FirebaseException catch (e) {
  //     throw e.message ?? '';
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  // FutureEither<UserModel> userLogin({required String email}) async {
  //   try {
  //     UserModel? userModel = await getUserData(email: email);
  //     return right(userModel!);
  //   } on FirebaseException catch (e) {
  //     print("11111111111111111111");
  //     throw e.message!;
  //   } catch (e,s) {
  //     print("0000000000000000000000000");
  //     print(e);
  //     print(s);
  //     return left(Failure(e.toString()));
  //   }
  // }
  // FutureEither<UserModel> userLogin({required String email}) async {
  //   try {
  //     UserModel? userModel = await getUserData(email: email);
  //     if (userModel != null) {
  //       return right(userModel);
  //     } else {
  //       throw FirebaseException(message: "User not found.", plugin: ''); // You can customize the error message as needed
  //     }
  //   } on FirebaseException catch (e) {
  //     print("FirebaseException occurred: ${e.message}");
  //     throw e.message!;
  //   } catch (e, s) {
  //     print("Exception occurred: $e");
  //     print(s);
  //     return left(Failure(e.toString()));
  //   }
  // }
  //

  Future<UserModel?> getUserData({required String email}) async {
    var user = await _userCollection.where("email", isEqualTo: email).get();
    if (user.docs.isNotEmpty) {
      QueryDocumentSnapshot<Object?> data = user.docs[0];
      UserModel userModel =
      UserModel.fromMap(data.data() as Map<String, dynamic>);
      return userModel;
    } else {
      return null;
    }
  }
  // login(String password, String email) async {
  //   try {
  //     QuerySnapshot Admin = await
  //     _userCollection
  //     // .where('delete', isEqualTo: false)
  //         .where("email", isEqualTo: email)
  //         .where("password", isEqualTo: password)
  //         .get();
  //     if (Admin.docs.isEmpty) {
  //       throw "user not exist";
  //     } else {
  //       print(Admin.docs[0]);
  //       print("Admin.docs[0]");
  //       final SharedPreferences userDatas = await SharedPreferences
  //           .getInstance();
  //       QueryDocumentSnapshot<Object?> data = Admin.docs[0];
  //       currentUserID = data.id;
  //       currentUserName=data.get("name");
  //       currentUserEmail = data.get("email");
  //       userDatas.setString('uid', data.id);
  //       userDatas.setString('email', currentUserEmail);
  //       currentUserID = data.id;
  //       userModel = UserModel.fromMap(
  //           Admin.docs.first.data() as Map<String, dynamic>);
  //     }
  //     return right(userModel);
  //   } on FirebaseException catch (e) {
  //
  //     throw e.message ?? '';
  //
  //   } catch (e) {
  //     print(e.toString());
  //     return left(Failure(e.toString()));
  //   }
  // }


  // Future<Either<Failure, UserModel>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserModel? userModel;
  //     final users = await _userCollection
  //         .where('email', isEqualTo: email)
  //         .get();
  //
  //     if (users.docs.isEmpty) {
  //       throw FirebaseAuthException(
  //         code: 'user-not-found',
  //         message: 'No user found with these credentials.',
  //       );
  //     } else {
  //       final userDatas = await SharedPreferences.getInstance();
  //       final data = users.docs[0];
  //
  //       if (data.get("password") != password) {
  //         throw FirebaseAuthException(
  //           code: 'wrong-password',
  //           message: 'Incorrect password.',
  //         );
  //       }
  //
  //       currentUserID = data.id;
  //       currentUserName = data.get("name");
  //       userDatas.setString("uid", currentUserID);
  //       userDatas.setString("username", currentUserName);
  //
  //       userModel = UserModel.fromMap(data.data() as Map<String, dynamic>);
  //       return right(userModel);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return left(Failure(e.message ?? 'Authentication failed'));
  //   } on FirebaseException catch (e) {
  //     return left(Failure(e.message ?? 'Firebase error occurred'));
  //   } catch (e) {
  //     return left(Failure('Unexpected error occurred: ${e.toString()}'));
  //   }
  // }
  FutureEither<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel? userModel;
      QuerySnapshot users = await _userCollection
          .where('email', isEqualTo: email)
      // .where('password', isEqualTo: password)
          .get();
      if (users.docs.isEmpty) {
        throw "email  Not Exist";
      } else {
        final SharedPreferences userDatas =
        await SharedPreferences.getInstance();
        QueryDocumentSnapshot<Object?> data = users.docs[0];
        if (data.get("password") != password) {
          throw "password not exist";
        }
        currentUserID = data.id;
        currentUserEmail = data.get("email");
        userDatas.setString("uid", currentUserID);
        userDatas.setString("email", currentUserEmail);
        userModel =
            UserModel.fromMap(data.data() as Map<String, dynamic>);
        return right(userModel);
      }
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }





  Future<UserModel> getUsers(String uid) async {
    var a = await _userCollection.doc(uid).get();
    return UserModel.fromMap(a.data() as Map<String, dynamic>);
  }

  FutureEither<UserModel?> checkKeepLogin() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString("uid");
      if (uid != null) {
        currentUserID = uid;
        userModel = await getUsers(uid);
        print('userIdchecked :$currentUserID');
        print('dddddddddd');
        return right(userModel);
      } else {
        return left(Failure("userId  not found"));
      }
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    } catch (e) {
      print(e);
      return left(Failure(e.toString()));
    }
  }

  logOutUser() async {
    SharedPreferences? prefs =
    await SharedPreferences.getInstance();
    prefs.remove("uid");
    prefs.remove("country");
    prefs.remove("countryId");
    prefs.remove("countryCode");
    prefs.remove("role");
    prefs.remove("email");
    prefs = null;
    prefs?.remove("user_password");
    currentUserEmail = "";
    currentUserID = "";
  }


  Future<int> getUserUid() async {
    try {
      DocumentSnapshot settingsDoc = await _firestore.collection('settings')
          .doc('settings')
          .get();
      int uid = settingsDoc.exists ? settingsDoc['userId'] ?? 0 : 0;
      await _firestore.collection('settings').doc('settings').update(
          {'userId': FieldValue.increment(1)});
      return uid + 1;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user UID: $e");
      }
      rethrow;
    }
  }

  Future<Either<Failure, UserModel>> createUser(UserModel userModel) async {
    try {
      int uid = (getUser(userModel.uid)) as int;
      if (kDebugMode) {
        print("Generated UID: U$uid");
      }

      DocumentReference userRef = _userCollection.doc("U$uid");
      await userRef.set(userModel.toMap());
      if (kDebugMode) {
        print("User document created: U$uid");
      }

      userModel = userModel.copyWith(
        reference: userRef,
        uid: "U$uid",
        search: setSearchParam("S$uid ${userModel.name} ${userModel.phoneNumber} ${userModel.email}"),
      );

      await userRef.update(userModel.toMap());
      if (kDebugMode) {
        print("User document updated: U$uid");
      }

      return Right(userModel);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("FirebaseException: ${e.message}");
      }
      return Left(Failure(e.message ?? "Firebase Exception occurred"));
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        UserModel userModel = UserModel(
          uid: "",
          name: username,
          email: email,
          password: password,
          search: [],
          date: DateTime.now(),
          delete: false,
          status: 0,
          active: true,
          phoneNumber: phone,
        );
        var createUserResult = await createUser(userModel);
        return createUserResult;
      } else {
        return Left(Failure("User creation failed"));
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Authentication Error: ${e.message}");
      }
      return Left(Failure(e.message ?? "Authentication Error occurred"));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return Left(Failure(e.toString()));
    }
  }


  Future passwordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);

    }
  }

  Stream<UserModel?> getUser(String uid) {
    if (uid.isEmpty) {
      return Stream.empty(); // Return an empty stream if uid is empty
    }

    return _userCollection.doc(uid).snapshots().map((event) {
      if (event.exists) {
        return UserModel.fromMap(event.data()! as Map<String, dynamic>);
      } else {
        return null; // Handle case where document doesn't exist
      }
    });
  }

}










