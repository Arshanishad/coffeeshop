


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/toast.dart';
import '../../../model/user_model.dart';
import '../../Home/screens/navigation_screen.dart';
import '../repository/login_repository.dart';
import '../screen/login_screen.dart';
import '../screen/signup_screen.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, bool>(
        (ref) => LoginController(
        loginRepository: ref.read(loginRepositoryProvider), ref: ref));
final userProvider = StateProvider<UserModel?>((ref) => null);
final getUserProvider=StreamProvider.family((ref,String uid){
  final loginController=ref.watch(loginControllerProvider.notifier);
  return loginController.getUser(uid);
} );


class LoginController extends StateNotifier<bool> {
  final LoginRepository _loginRepository;
  final Ref _ref;

  LoginController({
    required LoginRepository loginRepository,
    required Ref ref,
  })
      : _loginRepository = loginRepository,
        _ref = ref,
        super(false);
  bool state = false;
  UserModel? userModel;
  //
  // Future<void> login(
  //     {required String email,
  //       required String password,
  //       required BuildContext context}) async {
  //   state = true;
  //   final res = await _loginRepository.login( email,password);
  //   state = false;
  //   res.fold((l) {
  //     print("leftttttttt");
  //     showToast('User not exist');
  //
  //   }, (r) async {
  //     // if(mounted){
  //     //   Navigator.push(
  //     //       context,
  //     //       MaterialPageRoute(
  //     //         builder: (context) =>   HomeScreen(),
  //     //       ),
  //     //
  //     //     );
  //     // }
  //     print("aaaaaaaa");
  //     print(r.email);
  //     if(mounted){
  //       // Navigator.pushAndRemoveUntil(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) =>   HomeScreen(),
  //       //   ),
  //       //       (route) => false,
  //       // );
  //       print("bbbbbbbb");
  //     }
  //     if (r.password == password) {
  //       _ref.read(userProvider.notifier).update((state) => r);
  //       final SharedPreferences userDatas =
  //       await SharedPreferences.getInstance();
  //       currentUserID = r.uid;
  //       currentUserName = r.name;
  //       userDatas.setString("uid", currentUserID);
  //       userDatas.setString("name", r.name);
  //       if (r.delete) {
  //         showDialog(
  //           context: context,
  //           builder: (context) => const AlertDialog(
  //             title: Text("you are blocked"),
  //           ),
  //         );
  //       } else {
  //         if(mounted){
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) =>   NavigationScreen(),
  //             ),
  //                 (route) => false,
  //           );
  //         }
  //
  //
  //       }
  //       showToast('Login Successfully');
  //        } else {
  //       showToast('Incorrect Password');
  //     }
  //   });
  // }


  // Future login({
  //   required String email,
  //   required String password,
  //    required void Function(UserModel value) onSuccess,
  // }) async {
  //
  //   // state = true;
  //   final res = await _loginRepository.login(email: email, password: password);
  //   // state = false;
  //   res.fold(
  //         (l) => showToast('Error: ${l.message}'),
  //         (r) => onSuccess(r),
  //
  //   );
  // }

  // Future<void> login({
  //   required String email,
  //   required String password,
  //   required void Function(UserModel value) onSuccess,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final res = await _loginRepository.login(email: email, password: password);
  //
  //     res.fold(
  //           (l) {
  //         // Handle error case
  //         showToast('Error: ${l.message}');
  //         // Log the error for debugging purposes
  //         print('Login failed: ${l.message}');
  //       },
  //           (r) {
  //         onSuccess(r);
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => NavigationScreen()),
  //               (route) => false,
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     // Catch unexpected errors
  //     showToast('Unexpected error: ${e.toString()}');
  //     // Log the error for debugging purposes
  //     print('Unexpected error during login: $e');
  //   }
  // }

  Future<void> login({required String email,
    required String password,
    required BuildContext context}) async {
    state = true;
    final res =
    await _loginRepository.login(email: email, password: password);
    state = false;
    res.fold((l) => showToast(l.message), (r) async {
      final ware=await _loginRepository.getUserUid();
      // showSnackBar(context, 'Login Successfully');
      showToast('Login Successfully');

      userModel=r;
      prefs?.setBool('logged', true);
      _ref.read(userProvider.notifier).update((state) => r);
      if(mounted){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const NavigationScreen()),
              (route) => false,
        );
      }

    });
  }

















  Future<void> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    final res = await _loginRepository.registerUser(
      username: username,
      email: email,
      phone: phone,
      password: password,
    );

    res.fold(
          (l) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
              (route) => false,
        );
      },
          (r) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>  const NavigationScreen(),
          ),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New User Created')),
        );
          }
    );
  }

  Future<void> checkKeepLogin(BuildContext context) async {
    final res = await _loginRepository.checkKeepLogin();
    res.fold(
          (l) async {
        print(l.message);
        await Future.delayed(const Duration(seconds: 3));
        if(mounted){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
          );
        }

      },
          (r) async {
        _ref.read(userProvider.notifier).update((state) => r);
        await Future.delayed(const Duration(seconds: 3));
        if(mounted){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
                (route) => false,
          );
        }

      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await _loginRepository.logOutUser();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
            (route) => false,
      );
      prefs?.clear();
    }
  }
  Future passwordReset({required String email}) async {
    return _loginRepository.passwordReset(email: email);
  }

  Stream<UserModel?> getUser(String uid){
    return _loginRepository.getUser(uid);
  }


}