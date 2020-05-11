import 'dart:io';

import 'package:famili/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

import 'loading.dart';

typedef _OnSuccessFunction<T> = Widget Function(BuildContext context, T data);
typedef _OnErrorFunction = Widget Function(BuildContext context, Object error);
typedef _OnWaitingFunction = Widget Function(BuildContext context);

class ApiObserver<T> extends StatelessWidget {
  final Stream<T> stream;

  final _OnSuccessFunction<T> onSuccess;
  final _OnWaitingFunction onWaiting;
  final _OnErrorFunction onError;
  final Function onErrorReload;

  const ApiObserver({Key key,
    @required this.stream,
    @required this.onSuccess,
    this.onWaiting,
    this.onError,
    this.onErrorReload})
      : super(key: key);

  Function get _defaultOnWaiting => (context) => circularLoading();

  Function get _defaultOnError => (context, error) => Text(error);

  Function get _defaultOnSocketException =>
          (BuildContext context, error) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: (stream is ValueStream) ? (stream as ValueStream).hasValue : false,
                child: onSuccess(context, (stream as ValueStream).value),
              ),
              SizedBox(
                  height: 100.0,
                  child: Lottie.asset(
                    'assets/animations/no-internet-connection.json',
                    frameBuilder: (context, child, composition) {
                      return AnimatedOpacity(
                        child: child,
                        opacity: composition == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                      );
                    },
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Text(Constant.lostConnection),
              ),
              Visibility(
                visible: onErrorReload != null,
                child: FlatButton.icon(
                  color: Colors.transparent,
                  onPressed: onErrorReload,
                  icon: Icon(Icons.refresh),
                  label: Text(
                    "Muat Ulang",
                  ),
                ),
              )
            ],
          );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          if (snapshot.error is SocketException) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.info_outline),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text(Constant.noConnection),
                      )
                    ],
                  ),
                  backgroundColor: Colors.red,
                ));
            });
            print(snapshot.error);

            return _defaultOnSocketException(
                context, snapshot.error.toString());
          }

          return (onError != null)
              ? onError(context, snapshot.error.toString())
              : _defaultOnError(context, snapshot.error.toString());
        }

        if (snapshot.hasData) {
          T data = snapshot.data;
          return onSuccess(context, data);
        } else {
          return (onWaiting != null)
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
