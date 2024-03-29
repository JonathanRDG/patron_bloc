import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:patron_bloc/src/bloc/provider.dart';
import 'package:patron_bloc/src/providers/usuario.provider.dart';
import 'package:patron_bloc/src/utils/utils.dart';
class RegistroPage extends StatelessWidget {

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createBackground(context),
          _registerForm(context)
        ],
      )
    );
  }

  Widget _createBackground(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final purpleBackground = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, .05)
      ),
    );

    return Stack(
      children: <Widget>[
        purpleBackground,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -10.0, child: circle),
        Positioned(top: -50.0, right: -10.0, child: circle),
        Positioned(bottom: 120.0, right: 20.0, child: circle),
        Positioned(bottom: -50.0, left: -20.0, child: circle),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Jonathan Ricardo', style: TextStyle(color: Colors.white, fontSize: 25.0),)
            ],
          ),
        )
      ],
    );
  }

 Widget _registerForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * .85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Registro',style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0,),
                _createemail(bloc),
                SizedBox(height: 30.0,),
                _createPassword(bloc),
                SizedBox(height: 30.0,),
                _createBottom(bloc)


              ],
            ),
          ),
          FlatButton(
            child: Text('¿Ya tienes cuenta? Login'),
            onPressed: ()=>Navigator.pushReplacementNamed(context, 'login'),
          ),
          SizedBox(height: 100.0,)
        ],
      ),
    );
  }

  Widget _createemail(LoginBloc bloc) {

    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electronico',
                  counterText: snapshot.data,
                  errorText: snapshot.error
              ),
                onChanged: bloc.changeEmail
            ),
          );
        }
    );

  }

  Widget _createPassword(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      }
    );

  }

 Widget _createBottom(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0,vertical: 15.0),
            child: Text('Registrar'),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData? ()=> _register(bloc, context): null,
        );
      }
    );
  }

  _register(LoginBloc bloc, BuildContext context)async{

    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    if(info['ok']){
      Navigator.pushReplacementNamed(context, 'home');
    }
    else
    {
      mostrarAlerta(context, info['mensaje']);
    }
  //  Navigator.pushReplacementNamed(context, 'home');
  }
}
