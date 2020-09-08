import 'package:flutter/material.dart';
import 'package:flutter_app/common/color_constants.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/database/session/session_repository_imp.dart';
import 'package:flutter_app/pages/home/bloc/home_page_cubit.dart';
import 'package:flutter_app/pages/login/login_page.dart';
import 'package:flutter_app/pages/sessions_list/bloc/sessions_list_cubit.dart';
import 'package:flutter_app/pages/sessions_list/sessions_list_page.dart';
import 'package:flutter_app/pages/scanner/barcode_scanner_page.dart';
import 'package:flutter_app/pages/settings_page.dart';
import 'package:flutter_app/pages/shared/button_primary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_banner.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(child: Container(), preferredSize: Size(0.0, 0.0)),
        body: BlocProvider(
            create: (context) => HomePageCubit(),
            child: BlocConsumer<HomePageCubit, HomePageState>(
              listener: (context, state) {
                print("samo osluskujem");
              },
              builder: (context, state) {
                if (state is HomePageInitial) {
                  return buildHomePage(
                      context, state.welcomeString, state.isLoggedIn);
                } else {
                  return Container();
                }
              },
            )));
  }

  Widget buildHomePage(
      BuildContext context, String message, bool isLoggedInUser) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ImageBanner("assets/images/home_banner.jpg"),
        SizedBox(height: 50),
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonPrimary(
                  'Skeniraj',
                  ColorConstants.color4,
                  250,
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BarcodeScannerPage()),
                        )
                      }),
              SizedBox(
                height: 20,
              ),
              ButtonPrimary(
                  'Sesije',
                  ColorConstants.color4,
                  250,
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SessionsListCubit(
                                  SessionRepositoryImp(DBProvider.instance)),
                              child: SessionsListPage(),
                            ),
                          ),
                        ),
                      }),
              SizedBox(
                height: 20,
              ),
              ButtonPrimary(
                  'Podešavanja',
                  ColorConstants.color4,
                  250,
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        ),
                      }),
              SizedBox(
                height: 20,
              ),
              isLoggedInUser
                  ? ButtonPrimary('Odjava', ColorConstants.color4, 250, () {
                      final homeCubit = context.bloc<HomePageCubit>();
                      homeCubit.logout();
                    })
                  : ButtonPrimary(
                      'Prijava',
                      ColorConstants.color4,
                      250,
                      () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            ),
                          })
            ],
          ),
        )
      ],
    );
  }
}
