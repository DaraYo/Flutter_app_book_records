import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/color_constants.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/pages/login/cubit/login_page_cubit.dart';
import 'package:flutter_app/pages/shared/button_primary.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _autoValidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _confirmLogin(BuildContext context) {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      final loginCubit = context.bloc<LoginPageCubit>();
      print(_emailController.text);
      print(_passwordController.text);
      loginCubit.login(_emailController.text, _passwordController.text,
          _rememberMe, context);
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Ovo polje je obavezno';
    if (!regex.hasMatch(value))
      return '*Unesite validnu email adresu';
    else
      return null;
  }

  String passwordValidator(String value) {
    if (value.isEmpty)
      return '*Ovo polje je obavezno';
    else
      return null;
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _emailController,
            validator: emailValidator,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.blueGrey,
              fontFamily: FontNameDefault,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blueGrey,
              ),
              hintText: 'Unesite Email adresu',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Lozinka',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _passwordController,
            validator: passwordValidator,
            obscureText: true,
            style: TextStyle(
              color: Colors.blueGrey,
              fontFamily: FontNameDefault,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.blueGrey,
              ),
              hintText: 'Unesite lozinku',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox(BuildContext context, bool boxValue) {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: ColorConstants.color2),
            child: Checkbox(
              value: boxValue,
              checkColor: ColorConstants.color5,
              activeColor: ColorConstants.color2,
              onChanged: (value) {
                final loginCubit = context.bloc<LoginPageCubit>();
                loginCubit.rememberMeChecked(value);
              },
            ),
          ),
          Text(
            'Remember me',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginPageCubit(),
        child: BlocConsumer<LoginPageCubit, LoginPageState>(
          listener: (context, state) {
            print("listener");
          },
          builder: (context, state) {
            if (state is LoginPageInitial) {
              return buildLoginPage(context, state.rememberMe, null, 0);
            } else if (state is LoginIsLoading) {
              return buildLoginPage(context, false, null, 1);
            } else if (state is LoginSuccess) {
              return buildLoginPage(context, false, null, 2);
            } else if (state is LoginError) {
              return buildLoginPage(context, false, state.message, 0);
            } else {
              return buildLoginPage(context, false, null, 0);
            }
          },
        ),
      ),
    );
  }

  Widget buildLoginPage(BuildContext context, bool rememberMeValue,
      String message, int stateNumber) {
    if (message != null) {
      _showToast(context, message);
    }
    return
        // AnnotatedRegion<SystemUiOverlayStyle>(
        //   value: SystemUiOverlayStyle.light,
        //   child: GestureDetector(
        //     onTap: () => FocusScope.of(context).unfocus(),
        //     child:
        Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(height: 30.0),
                    _buildEmailTF(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTF(),
                    SizedBox(
                      height: 15.0,
                    ),
                    _buildRememberMeCheckbox(context, rememberMeValue),
                    Container(
                      padding: EdgeInsets.all(2.0),
                      // constraints: BoxConstraints.expand(
                      //   height: 80.0,
                      // ),
                      child: stateNumber > 0 && stateNumber == 1
                          ? CircularProgressIndicator()
                          : stateNumber == 2
                              ? Image.asset(
                                  "assets/images/checked_without_circle_full.png",
                                  height: 80.0,
                                )
                              : SizedBox(
                                  height: 80.0,
                                ),
                    ),
                    ButtonPrimary("Prijava", ColorConstants.color2,
                        double.infinity, () => {_confirmLogin(context)}),
                  ],
                ),
              )),
        )
      ],
      //   ),
      // ),
    );
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blueGrey[600],
        textColor: Colors.white,
        fontSize: 18.0);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
