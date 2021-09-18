import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class XDSignupPage extends StatelessWidget {
  XDSignupPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.12, -1.0),
                end: Alignment(-0.1, 0.9),
                colors: [
                  const Color(0xffff6a83),
                  const Color(0xfff98875),
                  const Color(0xfff3a866)
                ],
                stops: [0.0, 0.488, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 50,
            child: Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 49,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: 125,
            left: 35,
            child: Text(
              'To OTA fix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          LoginFormWidget(),
          _buildSignInButton(context)
        ],
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 410),
          // color: Colors.transparent,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -0.42),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xffff6a83),
                          const Color(0xfff98875),
                          const Color(0xfff3a866)
                        ],
                        stops: [0.0, 0.488, 1.0],
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    )).wh(50, 50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();

  var _userEmailController = TextEditingController();

  var _userPasswordController = TextEditingController();

  var _emailFocusNode = FocusNode();

  var _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.only(top: 160),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Card(
              elevation: 8.0,
              child: Column(
                children: <Widget>[
                  _buildIntroText(),
                  _buildEmailField(context),
                  _buildPasswordField(context),
                  _buildForgotPasswordWidget(context),
                ],
              ),
            ).h(280),
            50.heightBox,
            _buildSocialLoginRow(context),
          ],
        ),
      ),
    ).centered();
  }

  Widget _buildSocialLoginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        __buildFacebookButtonWidget(context),
        __buildTwitterButtonWidget(context)
      ],
    );
  }

  Widget __buildTwitterButtonWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => print("twitter"),
      child: Image.asset(
        "assets/images/ic_twitter.png",
        height: 70,
        width: 70,
      ),
    );
  }

  Widget __buildFacebookButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(
        "assets/images/ic_fb.png",
      ),
    );
  }

  Widget _buildIntroText() {
    return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.red,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(child: "Login".text.make().p(10)),
                Tab(child: "Signup".text.make().p(10))
              ],
            )));
  }

  String? _userNameValidation(String? value) {
    if (value == null) {
      return "Please enter valid user name";
    } else {
      return null;
    }
  }

  Widget _buildEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          hintText: "Enter username",
          labelText: "Username",
          contentPadding: EdgeInsets.symmetric(vertical: 5),
        ),
        controller: _userEmailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) => _emailValidation(value),
      ),
    );
  }

  String? _emailValidation(String? value) {
    bool emailValid = value != null &&
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if (!emailValid) {
      return "Enter valid email address";
    } else {
      return null;
    }
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userPasswordController,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) => _userNameValidation(value),
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          labelText: "Password",
          hintText: "Enter Password",
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot your password ?',
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: ElevatedButton(
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            _signUpProcess(context);
          },
        ),
      ),
    );
  }

  void _signUpProcess(BuildContext context) {
    var validate = _formKey.currentState!.validate();

    if (validate) {
      //Do login stuff
    } else {
      setState(() {});
    }
  }
}
