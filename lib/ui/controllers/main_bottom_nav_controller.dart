import 'package:get/get.dart';

class MainBottomNavController extends GetxController {
  // Reactive selected index
  var selectedIndex = 0.obs;

  // Update selected index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
