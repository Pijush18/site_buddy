import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:site_buddy/features/auth/application/user_provider.dart';

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ProfileController(this.ref) : super(const AsyncData(null));

  Future<void> updateName(String name) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(userProvider.future);
      if (user == null) return;

      final updated = user.copyWith(name: name);
      await ref.read(userRepositoryProvider).saveUser(updated);

      // Invalidate both user and account data to reflect changes
      ref.invalidate(userProvider);
      ref.invalidate(accountDataProvider);
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    state = const AsyncLoading();
    try {
      final user = await ref.read(userProvider.future);
      if (user == null) return;

      final updated = user.copyWith(profileImage: file.path);
      await ref.read(userRepositoryProvider).saveUser(updated);

      ref.invalidate(userProvider);
      ref.invalidate(accountDataProvider);
      
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
