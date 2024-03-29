import 'package:medibookings/service/disposable_service.dart';

class HomeTabService extends DisposableService{
  int bottomTab = 0;
  Future<void> updateTab (int tab)async{
    bottomTab = tab;
    if(tab> 2){
      bottomTab = 0;
    }
    notifyListeners();
  }
}