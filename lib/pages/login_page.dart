import 'package:chatease/components/my_button.dart';
import 'package:chatease/components/my_textfield.dart';
import 'package:chatease/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();

  FocusNode myfocusNode=FocusNode();

  LoginPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  void login(BuildContext context) async{
    final authService = AuthService();
    
    try{
      await authService.signInWithEmailPassword(_emailController.text, _passwordController.text,);
    }
    catch(e){
      showDialog(
          context: context,
          builder:(context) => AlertDialog(
            title: Text(e.toString()),
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
            "Welcome back",
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

          const SizedBox(height: 25,),

          MyButton(
            text: "Login",
            onTap:() => login(context),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a Member? ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),),
              GestureDetector(
                onTap: onTap,
                child: Text("Register Now",
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
