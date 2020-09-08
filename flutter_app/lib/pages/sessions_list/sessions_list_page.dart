import 'package:flutter/material.dart';
import 'package:flutter_app/common/color_constants.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/database/session/session_repository_imp.dart';
import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/pages/session_codes_list/bloc/session_codes_list_cubit.dart';
import 'package:flutter_app/pages/session_codes_list/session_codes_list_page.dart';
import 'package:flutter_app/pages/sessions_list/bloc/sessions_list_cubit.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/sessions_list_state.dart';

class SessionsListPage extends StatefulWidget {
  @override
  _SessionsListState createState() => _SessionsListState();
}

class _SessionsListState extends State<SessionsListPage> {
  final _format = new DateFormat("dd/MM/yyyy HH:mm");

  _select() {
    final sessionsListCubit = context.bloc<SessionsListCubit>();
    sessionsListCubit.synchronizeSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        title: Text(
          "Sesije",
          style: TextStyle(
            color: Colors.blueGrey,
            fontFamily: FontNameDefault,
          ),
        ),
        backgroundColor: ColorConstants.color5,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.sync,
              // color: Colors.blueGrey,
            ),
            onPressed: () {
              _select();
            },
          ),
        ],
      ),
      body: BlocConsumer<SessionsListCubit, SessionsListState>(
        builder: (context, state) {
          if (state is SessionsListLoading) {
            return buildLoading();
          } else if (state is SessionsListLoaded) {
            return buildSessionsList(context, state.sessions);
          } else {
            //state is error
            return Text("greska");
          }
        },
        listener: (BuildContext context, SessionsListState state) {
          if (state is SessionsListError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
      ),
      // body: BlocProvider(
      //   create: (context) => SessionsListCubit(
      //     [],
      //     SessionRepositoryImp(DBProvider.instance),
      //   ),
      // ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildSessionsList(BuildContext context, List<Session> sessions) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        Session item = sessions[index];
        final Widget dismissibleItem = new Dismissible(
            key: new ObjectKey(item),
            child: Card(
              elevation: 2,
//              color: !item.sent? Colors.green.withOpacity(0.1): Colors.red.withOpacity(0.1),
              child: ClipPath(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: item.sent ? Colors.green : Colors.red,
                              width: 7))),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorConstants.color2,
                            fontFamily: FontNameDefault,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          _format.format(
                              new DateTime.fromMillisecondsSinceEpoch(
                                  item.timestamp)),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                            fontFamily: FontNameDefault,
                          ),
                        ),
                      ],
                    ),
//                    title: Text(item.name),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => SessionCodesListCubit(item.id,
                                SessionRepositoryImp(DBProvider.instance)),
                            child: SessionCodesListPage(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ),
            background: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Deleting",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              color: ColorConstants.color4,
            ),
            onDismissed: (direction) {
              final sessionsListCubit = context.bloc<SessionsListCubit>();
              sessionsListCubit.deleteSession(item.id);
            });
        return dismissibleItem;
      },
    );
  }
}
