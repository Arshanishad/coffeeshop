//
// import 'package:coffee_shop_app/features/login/screen/signup_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/constants.dart';
// import '../../../core/pallete/theme.dart';
// import '../../../core/widget/alertbox.dart';
// import '../../../core/widget/rounded_loading_button.dart';
// import '../../../core/widget/textformfield.dart';
// import '../../../model/user_model.dart';
// import '../../Home/screens/navigation_screen.dart';
// import '../controller/login_controller.dart';
// import 'forgot_password.dart';
//
//
// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final eyeBool = StateProvider((ref) => false);
//
//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//   GlobalKey<ScaffoldMessengerState>();
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void dispose() {
//     print("LoginScreen dispose called");
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   void _handleLoginSuccess(UserModel userModel) {
//     print("_handleLoginSuccess called");
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       if (mounted) {
//         print("Navigating to NavigationScreen");
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const NavigationScreen()),
//         );
//       } else {
//         print("LoginScreen is not mounted, navigation aborted");
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return ScaffoldMessenger(
//       key: scaffoldMessengerKey,
//       child: Material(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SafeArea(
//             child: Center(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: h * 0.1),
//                     Image.asset(Constants.loginImage),
//                     SizedBox(height: h * 0.05),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ForgotScreen(),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "Forgot Password",
//                           style: TextStyle(
//                             fontSize: w * 0.04,
//                             color: Palette.redLightColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                       child: Column(
//                         children: [
//                           CustomTextInput(
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               return null;
//                             },
//                             controller: emailController,
//                             label: 'Email',
//                             prefixIcon: Icons.email,
//                             width: 0.7,
//                             height: 0.1,
//                           ),
//                           SizedBox(height: h * 0.02),
//                           Consumer(
//                             builder: (context, ref, child) {
//                               final passwordVisibility = ref.watch(eyeBool);
//                               return CustomTextInput(
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your password';
//                                   }
//                                   return null;
//                                 },
//                                 controller: passwordController,
//                                 maxLines: 1,
//                                 label: 'Password',
//                                 prefixIcon: Icons.lock,
//                                 width: 0.7,
//                                 obscureText: passwordVisibility,
//                                 suffixIcon: ref.watch(eyeBool) == false
//                                     ? Icons.remove_red_eye_outlined
//                                     : Icons.visibility_off,
//                                 height: 0.12,
//                                 onSuffixIconTap: () {
//                                   ref.read(eyeBool.notifier).state =
//                                   !passwordVisibility;
//                                 },
//                               );
//                             },
//                           ),
//                           SizedBox(height: 30),
//                           Consumer(
//                             builder: (context, ref, child) {
//                               return SizedBox(
//                                 width: w * 0.7,
//                                 height: h * 0.05,
//                                 child: RoundedLoadingButton(
//                                   icon: false,
//                                   backgroundColor: Palette.redLightColor,
//                                   // textColor: Colors.white,
//                                   text: 'Login',
//                                   isLoading: false,
//                                   onPressed: () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return ConfirmationDialog(
//                                             message:
//                                             'Are you sure you want to Login?',
//                                             onConfirmed: () async {
//                                               Navigator.of(context).pop();
//                                               // ref
//                                               //     .read(
//                                               //     loginControllerProvider
//                                               //         .notifier)
//                                               //     .login(
//                                               //   email: emailController.text
//                                               //       .trim(),
//                                               //   password: passwordController
//                                               //       .text
//                                               //       .trim(),
//                                               //   onSuccess: _handleLoginSuccess,
//                                               //   context: context,
//                                               // );
//                                               ref.read(loginControllerProvider.notifier).login(email: emailController.text.trim(), password: passwordController.text.trim(), context: context);
//                                             },
//                                             onCancel: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                           );
//                                         },
//                                       );
//                                     }
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                           SizedBox(height: h * 0.01),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Don't Have an Account?",
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: w * 0.04,
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                       const SignUpScreen(),
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   "Sign Up",
//                                   style: TextStyle(
//                                     fontSize: w * 0.04,
//                                     color: Palette.redLightColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:coffee_shop_app/features/login/screen/signup_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/constants.dart';
// import '../../../core/pallete/theme.dart';
// import '../../../core/widget/alertbox.dart';
// import '../../../core/widget/rounded_loading_button.dart';
// import '../../../core/widget/textformfield.dart';
// import '../controller/login_controller.dart';
// import 'forgot_password.dart';
//
// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//
//   final _formKey = GlobalKey<FormState>();
//
//   login() async {
//     if(_formKey.currentState!.validate()) {
//       ref.read(loginControllerProvider.notifier).login(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//           context: context);
//     }
//   }
//
//   final passVisibleProvider = StateProvider<bool>((ref) => false);
//   final eyeBool = StateProvider<bool>((ref) => false);
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }
//   @override
//   // Widget build(BuildContext context) {
//   //   double h = MediaQuery.of(context).size.height;
//   //   double w = MediaQuery.of(context).size.width;
//   //   final passVisible=ref.watch(passVisibleProvider);
//   //   return Scaffold(
//   //     backgroundColor: Colors.white,
//   //     body: Padding(
//   //       padding: EdgeInsets.all(w * 0.02),
//   //       child: Form(
//   //         key: _formKey,
//   //         child: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             const Center(
//   //               child: Text(
//   //                 "Login",
//   //                 style: TextStyle(
//   //                     color: Colors.black,
//   //                     fontSize: 30,
//   //                     fontWeight: FontWeight.bold),
//   //               ),
//   //             ),
//   //             SizedBox(height: h * 0.08),
//   //             SizedBox(
//   //                 width: w * 0.85,
//   //                 child: TextFormField(
//   //                   textInputAction: TextInputAction.next,
//   //                   autovalidateMode: AutovalidateMode.onUserInteraction,
//   //                   // validator: (value) {
//   //                   //   if (value!.isEmpty ||
//   //                   //       !RegExp(r"^[a-zA-Z]")
//   //                   //           .hasMatch(value)) {
//   //                   //     return 'Enter a Valid Username';
//   //                   //   }
//   //                   //   return null;
//   //                   // },
//   //                   controller: emailController,
//   //                   decoration: InputDecoration(
//   //                       hintText: ' Email',
//   //                       labelText: 'Email',
//   //                       border: OutlineInputBorder(
//   //                           borderRadius: BorderRadius.circular(30))),
//   //                 )),
//   //             SizedBox(
//   //               height: h * 0.03,
//   //             ),
//   //             SizedBox(
//   //                 width: w * 0.85,
//   //                 child: TextFormField(
//   //                   autovalidateMode: AutovalidateMode.onUserInteraction,
//   //                   // validator: (value) {
//   //                   //   if (value != null && value.length < 6) {
//   //                   //     return 'Enter The Valid Password!';
//   //                   //   } else {
//   //                   //     return null;
//   //                   //   }
//   //                   // },
//   //                   controller: passwordController,
//   //                   obscureText: passVisible ? false : true,
//   //                   decoration: InputDecoration(
//   //                       border: OutlineInputBorder(
//   //                           borderRadius: BorderRadius.circular(30)),
//   //                       labelText: "Password",
//   //                       hintText: 'Enter Your Password',
//   //                       suffixIcon: IconButton(
//   //                         icon: Icon((passVisible == true)
//   //                             ? Icons.visibility
//   //                             : Icons.visibility_off),
//   //                         onPressed: () {
//   //                           ref.watch(passVisibleProvider.notifier).update((state) => state =!state);
//   //                         },
//   //                       )
//   //                   ),
//   //                 )),
//   //             SizedBox(
//   //               height: h * 0.04,
//   //             ),
//   //             SizedBox(
//   //                 width: w * 0.3,
//   //                 child: ElevatedButton(
//   //                     style:
//   //                     ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//   //                     onPressed: () {
//   //                       if (emailController.text.trim() != '' &&
//   //                           passwordController.text.trim() != '') {
//   //                         if (_formKey.currentState!.validate()) {
//   //                           login();
//   //                           // usernameController.clear();
//   //                           // passwordController.clear();
//   //                         }
//   //                       }else {
//   //                         emailController.text.trim() == '';
//   //                             // ?
//   //                         // showSnackBar(context, 'Please Enter Username')
//   //                         //     : showSnackBar(context, 'Please  Enter Password');
//   //                       }
//   //                     },
//   //                     child: const Text(
//   //                       'LOGIN',
//   //                       style: TextStyle(color: Colors.white),
//   //                     ))),
//   //             const Text(
//   //               "v.0.0.4",
//   //               style: TextStyle(color: Colors.grey),
//   //             )
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: SafeArea(
//           child: Center(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: h * 0.1),
//                   Image.asset(Constants.loginImage),
//                   SizedBox(height: h * 0.05),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ForgotScreen(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "Forgot Password",
//                         style: TextStyle(
//                           fontSize: w * 0.04,
//                           color: Palette.redLightColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                     child: Column(
//                       children: [
//                         CustomTextInput(
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             return null;
//                           },
//                           controller: emailController,
//                           label: 'Email',
//                           prefixIcon: Icons.email,
//                           width: 0.7,
//                           height: 0.1,
//                         ),
//                         SizedBox(height: h * 0.02),
//                         Consumer(
//                           builder: (context, ref, child) {
//                             final passwordVisibility = ref.watch(eyeBool);
//                             return CustomTextInput(
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 return null;
//                               },
//                               controller: passwordController,
//                               maxLines: 1,
//                               label: 'Password',
//                               prefixIcon: Icons.lock,
//                               width: 0.7,
//                               obscureText: passwordVisibility,
//                               suffixIcon: ref.watch(eyeBool) == false
//                                   ? Icons.remove_red_eye_outlined
//                                   : Icons.visibility_off,
//                               height: 0.12,
//                               onSuffixIconTap: () {
//                                 ref.read(eyeBool.notifier).state =
//                                 !passwordVisibility;
//                               },
//                             );
//                           },
//                         ),
//                         SizedBox(height: 30),
//                         Consumer(
//                           builder: (context, ref, child) {
//                             return SizedBox(
//                               width: w * 0.7,
//                               height: h * 0.05,
//                               child: RoundedLoadingButton(
//                                 icon: false,
//                                 backgroundColor: Palette.redLightColor,
//                                 // textColor: Colors.white,
//                                 text: 'Login',
//                                 isLoading: false,
//                                 onPressed: () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return ConfirmationDialog(
//                                           message:
//                                           'Are you sure you want to Login?',
//                                           onConfirmed: () async {
//                                             Navigator.of(context).pop();
//                                             // ref
//                                             //     .read(
//                                             //     loginControllerProvider
//                                             //         .notifier)
//                                             //     .login(
//                                             //   email: emailController.text
//                                             //       .trim(),
//                                             //   password: passwordController
//                                             //       .text
//                                             //       .trim(),
//                                             //   onSuccess: _handleLoginSuccess,
//                                             //   context: context,
//                                             // );
//                                             // ref.read(loginControllerProvider.notifier).login(email: emailController.text.trim(), password: passwordController.text.trim(), context: context);
//                                             login();
//                                           },
//                                           onCancel: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                         );
//                                       },
//                                     );
//                                   }
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                         SizedBox(height: h * 0.01),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Don't Have an Account?",
//                               style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: w * 0.04,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                     const SignUpScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Sign Up",
//                                 style: TextStyle(
//                                   fontSize: w * 0.04,
//                                   color: Palette.redLightColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/features/Home/screens/navigation_screen.dart';
import 'package:coffee_shop_app/features/login/screen/forgot_password.dart';
import 'package:coffee_shop_app/features/login/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/login_controller.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

bool passVisible = false;

class _LoginState extends ConsumerState<Login> {
  login() async {
    // if(_formKey.currentState!.validate()) {
      ref.read(loginControllerProvider.notifier).login(
          email: _getEmail.text.trim(),
          password: _getPassword.text.trim(),
          context: context);
    // }
  }
  final TextEditingController _getEmail = TextEditingController();
  final TextEditingController _getPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage("asset/image/bg2.png"), fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              const SizedBox(height: 150),
              const Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9, top: 90),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                      width: 300,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (!_getEmail.text.contains("@gmail.com")) {
                            return 'enter a valid email';
                          }
                          return null;
                        },
                        controller: _getEmail,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9, top: 20),
                child: Container(
                    width: 300,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value.length < 8) {
                          return 'Enter the valid password!';
                        } else {
                          return null;
                        }
                      },
                      controller: _getPassword,
                      obscureText: (passVisible == true) ? false : true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          labelText: "password",
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon((passVisible == true)
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                passVisible = !passVisible;
                              });
                            },
                          )),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Container(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                        login();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavigationScreen()),
                                  (route) => false);
                        },
                        child: const Text('LOGIN'))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                    height: h * 0.05,
                    width: w * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do you have account?"),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpScreen()));
                            },
                            child: const Text(
                              " Sign up",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotScreen()));
                },
                child: Container(
                  height: h * 0.02,
                  width: w * 0.3,
                  child: const Center(
                      child: Text(
                        "forgot password",
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

