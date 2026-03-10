import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalynow_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kalynow_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kalynow_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:kalynow_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kalynow_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:kalynow_mobile/features/auth/presentation/providers/auth_provider.dart';

void main() {
  ProviderContainer makeContainer() {
    return ProviderContainer();
  }

  group('AuthNotifier', () {
    test('initial state is AuthInitial', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      expect(container.read(authNotifierProvider), isA<AuthInitial>());
    });

    test('login transitions to AuthAuthenticated on success', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login(email: 'test@example.com', password: 'password');

      expect(container.read(authNotifierProvider), isA<AuthAuthenticated>());
      final state =
          container.read(authNotifierProvider) as AuthAuthenticated;
      expect(state.user.email, 'test@example.com');
    });

    test('logout transitions to AuthUnauthenticated', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      // First login
      await container
          .read(authNotifierProvider.notifier)
          .login(email: 'test@example.com', password: 'password');

      // Then logout
      await container.read(authNotifierProvider.notifier).logout();
      expect(
        container.read(authNotifierProvider),
        isA<AuthUnauthenticated>(),
      );
    });

    test('manual wiring of AuthNotifier works correctly', () async {
      final dataSource = AuthRemoteDataSourceImpl();
      final repo = AuthRepositoryImpl(dataSource);
      final notifier = AuthNotifier(
        loginUseCase: LoginUseCase(repo),
        registerUseCase: RegisterUseCase(repo),
        logoutUseCase: LogoutUseCase(repo),
      );

      expect(notifier.state, isA<AuthInitial>());
      await notifier.login(email: 'a@b.com', password: 'pw');
      expect(notifier.state, isA<AuthAuthenticated>());
    });
  });
}
