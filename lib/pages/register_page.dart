import 'package:chatease/services/auth/auth_service.dart';
import 'package:chatease/components/my_button.dart';
import 'package:chatease/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {

  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _confirmpwController=TextEditingController();

  FocusNode myfocusNode=FocusNode();

  RegisterPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  void register(BuildContext context){
    final _auth=AuthService();

    if(_passwordController.text == _confirmpwController.text){
      try{
        _auth.signUpWithEmailPassword(
            _emailController.text,
            _passwordController.text,
        );
      }catch (e){
        showDialog(
          context: context,
          builder:(context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    else{
      showDialog(
        context: context,
        builder:(context) => AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 50,),

          Text(
            "Let's Create a Account for You",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25,),

          MyTextField(
            hintText:"Email",
            obscureText: false,
            controller: _emailController,
            //focusNode: myfocusNode,
          ),

          const SizedBox(height: 10,),

          MyTextField(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
            //focusNode: myfocusNode,
          ),

          const SizedBox(height: 10,),


          MyTextField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: _confirmpwController,
            //focusNode: myfocusNode,
          ),

          const SizedBox(height: 25,),

          MyButton(
            text: "Register",
            onTap: () => register(context),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an Account? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),),
              GestureDetector(
                onTap: onTap,
                child: Text("Login Now",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
