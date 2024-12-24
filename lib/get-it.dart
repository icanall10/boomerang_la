import 'package:get_it/get_it.dart';

import 'package:boomerang/classes/fcm.dart';
import 'package:boomerang/classes/nav.dart';


void initGetIt() {
     GetIt.instance.registerLazySingleton(() => Nav());
     GetIt.instance.registerLazySingleton(() => FCM());
}