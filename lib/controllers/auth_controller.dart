import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserLoggedIn();
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _authService.registerWithEmail(
        email,
        password,
        displayName,
      );

      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        Get.offNamed(AppRoutes.home);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _authService.loginWithEmail(email, password);

      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        Get.offNamed(AppRoutes.home);
      } else {
        errorMessage.value = 'Login gagal';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkUserLoggedIn() async {
    try {
      final isLogged = await _authService.isUserLoggedIn();
      if (isLogged) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          currentUser.value = user;
          isLoggedIn.value = true;
        }
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
  }
}
