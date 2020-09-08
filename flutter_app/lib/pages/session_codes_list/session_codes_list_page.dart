import 'package:flutter/material.dart';
import 'package:flutter_app/common/color_constants.dart';
import 'package:flutter_app/models/session_code.dart';
import 'package:flutter_app/pages/session_codes_list/bloc/session_codes_list_cubit.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCodesListPage extends StatefulWidget {
  @override
  _SessionCodesListState createState() => _SessionCodesListState();
}

class _SessionCodesListState extends State<SessionCodesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        title: Text(
          "Barkodovi",
          style: TextStyle(
            color: Colors.blueGrey,
            fontFamily: FontNameDefault,
          ),
        ),
        backgroundColor: ColorConstants.color5,
        elevation: 0,
      ),
      body: BlocConsumer<SessionCodesListCubit, SessionCodesListState>(
        builder: (context, state) {
          if (state is SessionCodesListLoading) {
            return buildLoading();
          } else if (state is SessionCodesListLoaded) {
            return buildSessionCodesList(context, state.sessionCodes);
          } else {
            //state is error
            return Text("greska");
          }
        },
        listener: (BuildContext context, SessionCodesListState state) {
          if (state is SessionCodesListError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildSessionCodesList(
      BuildContext context, List<SessionCode> sessionCodes) {
    return ListView.builder(
      itemCount: sessionCodes.length,
      itemBuilder: (context, index) {
        SessionCode item = sessionCodes[index];
        final Widget dismissibleItem = new Dismissible(
            key: new ObjectKey(item),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: ColorConstants.color5, width: 0.5),
                // borderRadius: BorderRadius.circular(5),
              ),
              color: Colors.white,
              child: ListTile(
                title: Text(item.code),
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
              final sessionCodesListCubit =
                  context.bloc<SessionCodesListCubit>();
              sessionCodesListCubit.deleteSessionCode(item.code);
            });
        return dismissibleItem;
      },
    );
  }
}
