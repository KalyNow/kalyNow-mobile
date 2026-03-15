# Instructions Copilot — kalyNow Mobile

## 🎯 Vue d'ensemble du projet

**kalyNow Mobile** est l'application mobile BUYER de la plateforme kalyNow — un marketplace anti-gaspillage alimentaire permettant aux utilisateurs de découvrir et réserver des offres de restauration à prix réduit.

### Technologies principales

| Outil | Version | Usage |
|-------|---------|-------|
| Flutter | 3.27.3 (via fvm) | Framework UI |
| Dart SDK | ≥ 3.3.0 | Langage |
| flutter_riverpod | ^2.6.1 | State management |
| riverpod_annotation + riverpod_generator | ^2.3.5 / ^2.4.3 | Codegen Riverpod |
| go_router | ^14.6.2 | Navigation |
| dio | ^5.7.0 | Client HTTP |
| freezed_annotation + freezed | ^3.0.0 | Immutable classes & unions |
| json_annotation + json_serializable | ^4.9.0 / ^6.8.0 | JSON serialization |
| equatable | ^2.0.7 | Égalité structurelle |
| build_runner | ^2.4.13 | Génération de code |
| custom_lint + riverpod_lint | ^0.7.5 / ^2.3.13 | Linting Riverpod |

### Flutter version management

Ce projet utilise **fvm** (Flutter Version Manager) :
```bash
# Utiliser la version configurée du projet
fvm flutter <commande>

# Générer le code (après modification d'un fichier annoté)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Ou en watch mode
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 🏗️ Architecture Clean Architecture

Le projet implémente la **Clean Architecture** avec 3 couches distinctes par feature.

### Structure générale

```
lib/
├── main.dart
├── core/                        # Infrastructure partagée
│   ├── constants/
│   │   └── app_constants.dart   # Constantes globales (baseUrl, clés, pagination)
│   ├── errors/
│   │   ├── exceptions.dart      # Exceptions (AppException, ServerException, …)
│   │   └── failures.dart        # Failures (Failure, ServerFailure, …)
│   ├── network/
│   │   └── dio_client.dart      # Provider Dio configuré + intercepteurs
│   ├── router/
│   │   └── app_router.dart      # GoRouter + guards d'authentification
│   ├── theme/                   # ThemeData, couleurs, typographie
│   └── usecases/
│       └── usecase.dart         # Interfaces abstraites UseCase<T,P> / UseCaseNoParams<T>
│
├── features/                    # Features métier
│   ├── auth/
│   ├── offers/
│   └── restaurants/
│
└── shared/
    ├── utils/                   # Utilitaires réutilisables
    └── widgets/                 # Widgets partagés (AppErrorWidget, AppLoadingWidget)
```

### Structure d'une feature

Chaque feature respecte la même organisation :

```
features/[feature]/
├── data/
│   ├── datasources/
│   │   └── [feature]_remote_datasource.dart   # Interface + implémentation API (Dio)
│   ├── models/
│   │   └── [entity]_model.dart                # Étend l'entité, fromJson/toJson
│   └── repositories/
│       └── [feature]_repository_impl.dart     # Implémentation du repository domain
│
├── domain/
│   ├── entities/
│   │   └── [entity].dart                      # Entité Equatable (logique métier pure)
│   ├── repositories/
│   │   └── [feature]_repository.dart          # Interface repository (contrat)
│   └── usecases/
│       └── [action]_usecase.dart              # UseCase unique et ciblé
│
└── presentation/
    ├── pages/
    │   └── [feature]_page.dart                # Écrans (ConsumerWidget / ConsumerStatefulWidget)
    ├── providers/
    │   └── [feature]_provider.dart            # Providers Riverpod (state + dépendances)
    └── widgets/                               # Widgets spécifiques à la feature (optionnel)
        └── [widget_name].dart
```

---

## 📐 Couches en détail

### 1. Domain Layer — Logique métier pure

**Entités** : classes Dart avec `Equatable`, sans dépendance externe.

```dart
// features/[feature]/domain/entities/[entity].dart
import 'package:equatable/equatable.dart';

class MyEntity extends Equatable {
  final String id;
  final String name;
  final String? optionalField;

  const MyEntity({
    required this.id,
    required this.name,
    this.optionalField,
  });

  // Logique métier simple autorisée dans les entités
  bool get isValid => name.isNotEmpty;

  @override
  List<Object?> get props => [id, name, optionalField];
}
```

**Repository interface** : contrat pur, sans implémentation.

```dart
// features/[feature]/domain/repositories/[feature]_repository.dart
abstract class MyRepository {
  Future<List<MyEntity>> getAll();
  Future<MyEntity> getById(String id);
  Future<void> create(MyEntity entity);
}
```

**UseCases** : implémentent `UseCase<Type, Params>` ou `UseCaseNoParams<Type>` de `core/usecases/usecase.dart`.

```dart
// features/[feature]/domain/usecases/get_my_entities_usecase.dart
import '../../../../core/usecases/usecase.dart';
import '../entities/my_entity.dart';
import '../repositories/my_repository.dart';

class GetMyEntitiesUseCase extends UseCaseNoParams<List<MyEntity>> {
  final MyRepository _repository;

  GetMyEntitiesUseCase(this._repository);

  @override
  Future<List<MyEntity>> call() => _repository.getAll();
}

class GetMyEntityByIdUseCase extends UseCase<MyEntity, GetMyEntityByIdParams> {
  final MyRepository _repository;

  GetMyEntityByIdUseCase(this._repository);

  @override
  Future<MyEntity> call(GetMyEntityByIdParams params) =>
      _repository.getById(params.id);
}

class GetMyEntityByIdParams extends Equatable {
  final String id;
  const GetMyEntityByIdParams(this.id);

  @override
  List<Object> get props => [id];
}
```

---

### 2. Data Layer — Accès aux données

**Models** : étendent l'entité domain, ajoutent `fromJson` / `toJson`.

```dart
// features/[feature]/data/models/[entity]_model.dart
import '../../domain/entities/my_entity.dart';

class MyEntityModel extends MyEntity {
  const MyEntityModel({
    required super.id,
    required super.name,
    super.optionalField,
  });

  factory MyEntityModel.fromJson(Map<String, dynamic> json) {
    return MyEntityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      optionalField: json['optional_field'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'optional_field': optionalField,
    };
  }

  factory MyEntityModel.fromEntity(MyEntity entity) {
    return MyEntityModel(
      id: entity.id,
      name: entity.name,
      optionalField: entity.optionalField,
    );
  }
}
```

**DataSources** : interface + implémentation Dio.

```dart
// features/[feature]/data/datasources/[feature]_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/my_entity_model.dart';
import '../../domain/entities/my_entity.dart';

abstract class MyFeatureRemoteDataSource {
  Future<List<MyEntity>> getAll();
  Future<MyEntity> getById(String id);
}

class MyFeatureRemoteDataSourceImpl implements MyFeatureRemoteDataSource {
  final Dio _dio;

  MyFeatureRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MyEntity>> getAll() async {
    try {
      final response = await _dio.get('/my-resource');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => MyEntityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Les exceptions sont mappées par l'intercepteur dans dio_client.dart
      throw e.error as AppException? ??
          AppException(e.message ?? 'Unexpected error');
    }
  }

  @override
  Future<MyEntity> getById(String id) async {
    try {
      final response = await _dio.get('/my-resource/$id');
      return MyEntityModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error as AppException? ??
          AppException(e.message ?? 'Unexpected error');
    }
  }
}
```

**Repository implementation** : convertit les exceptions en failures.

```dart
// features/[feature]/data/repositories/[feature]_repository_impl.dart
import '../../domain/entities/my_entity.dart';
import '../../domain/repositories/my_repository.dart';
import '../datasources/my_feature_remote_datasource.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

class MyRepositoryImpl implements MyRepository {
  final MyFeatureRemoteDataSource _dataSource;

  MyRepositoryImpl(this._dataSource);

  @override
  Future<List<MyEntity>> getAll() async {
    try {
      return await _dataSource.getAll();
    } on ServerException catch (e) {
      throw ServerFailure(e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Future<MyEntity> getById(String id) async {
    try {
      return await _dataSource.getById(id);
    } on NotFoundException catch (e) {
      throw NotFoundFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }
}
```

---

### 3. Presentation Layer — UI et State Management

#### Providers Riverpod

Le projet utilise **Riverpod avec l'API manuelle** (`Provider`, `StateNotifierProvider`, `FutureProvider`) — **pas** le style codegen `@riverpod`.

```dart
// features/[feature]/presentation/providers/[feature]_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/my_feature_remote_datasource.dart';
import '../../data/repositories/my_feature_repository_impl.dart';
import '../../domain/entities/my_entity.dart';
import '../../domain/repositories/my_repository.dart';
import '../../domain/usecases/get_my_entities_usecase.dart';

// --- Infrastructure ---

final myFeatureDataSourceProvider = Provider<MyFeatureRemoteDataSource>((ref) {
  return MyFeatureRemoteDataSourceImpl(ref.watch(dioProvider));
});

final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepositoryImpl(ref.watch(myFeatureDataSourceProvider));
});

// --- Use cases ---

final getMyEntitiesUseCaseProvider = Provider<GetMyEntitiesUseCase>((ref) {
  return GetMyEntitiesUseCase(ref.watch(myRepositoryProvider));
});

// --- State ---

// FutureProvider pour des données simples (lecture seule)
final myEntitiesProvider = FutureProvider<List<MyEntity>>((ref) async {
  return ref.watch(getMyEntitiesUseCaseProvider).call();
});

// FutureProvider.family pour des données paramétrées
final myEntityByIdProvider =
    FutureProvider.family<MyEntity, String>((ref, id) async {
  return ref.watch(getMyEntityByIdUseCaseProvider).call(
        GetMyEntityByIdParams(id),
      );
});
```

**StateNotifier** pour la logique d'état complexe (ex : auth avec login/logout) :

```dart
// State sealed class
sealed class MyFeatureState {
  const MyFeatureState();
}
final class MyFeatureInitial extends MyFeatureState { const MyFeatureInitial(); }
final class MyFeatureLoading extends MyFeatureState { const MyFeatureLoading(); }
final class MyFeatureLoaded extends MyFeatureState {
  final List<MyEntity> items;
  const MyFeatureLoaded(this.items);
}
final class MyFeatureError extends MyFeatureState {
  final String message;
  const MyFeatureError(this.message);
}

// Notifier
class MyFeatureNotifier extends StateNotifier<MyFeatureState> {
  final GetMyEntitiesUseCase _getEntities;

  MyFeatureNotifier(this._getEntities) : super(const MyFeatureInitial());

  Future<void> load() async {
    state = const MyFeatureLoading();
    try {
      final items = await _getEntities();
      state = MyFeatureLoaded(items);
    } catch (e) {
      state = MyFeatureError(e.toString());
    }
  }
}

final myFeatureNotifierProvider =
    StateNotifierProvider<MyFeatureNotifier, MyFeatureState>((ref) {
  return MyFeatureNotifier(ref.watch(getMyEntitiesUseCaseProvider));
});
```

#### Pages (ConsumerWidget)

```dart
// features/[feature]/presentation/pages/my_feature_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/my_feature_provider.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

class MyFeaturePage extends ConsumerWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesAsync = ref.watch(myEntitiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: entitiesAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(myEntitiesProvider),
        ),
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(title: Text(item.name));
          },
        ),
      ),
    );
  }
}
```

---

## 🗺️ Navigation (go_router)

Le router est configuré dans `core/router/app_router.dart` via le provider `appRouterProvider`.

```dart
// Naviguer vers une route nommée
context.goNamed('restaurant-detail', pathParameters: {'id': restaurant.id});

// Naviguer en empilant
context.pushNamed('my-route');

// Retour
context.pop();
```

**Ajouter une route** dans `app_router.dart` :
```dart
GoRoute(
  path: '/my-feature',
  name: 'my-feature',
  builder: (context, state) => const MyFeaturePage(),
),
```

**Routes paramétrées** :
```dart
GoRoute(
  path: '/item/:id',
  name: 'item-detail',
  builder: (context, state) => ItemDetailPage(
    itemId: state.pathParameters['id']!,
  ),
),
```

**Guard d'authentification** : le redirect dans `appRouterProvider` surveille `authNotifierProvider`. Il redirige automatiquement vers `/login` si non authentifié, et vers `/home` si déjà authentifié.

---

## 🌐 Client HTTP (Dio)

Toujours injecter `dioProvider` via Riverpod dans les DataSources :

```dart
class MyDataSourceImpl implements MyDataSource {
  final Dio _dio;
  MyDataSourceImpl(this._dio);
  // ...
}

final myDataSourceProvider = Provider<MyDataSource>((ref) {
  return MyDataSourceImpl(ref.watch(dioProvider));  // ✅
});
```

**Gestion des erreurs Dio** : l'intercepteur dans `dio_client.dart` mappe automatiquement les `DioException` en exceptions de `core/errors/exceptions.dart`. Dans les DataSources, capturer `DioException` et propager `e.error` :

```dart
} on DioException catch (e) {
  throw e.error as AppException? ??
      AppException(e.message ?? 'Unexpected error');
}
```

**Token d'authentification** : ajouter l'intercepteur dans `dio_client.dart` :
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = /* récupérer depuis SharedPreferences */ '';
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  ),
);
```

---

## ⚠️ Gestion des erreurs

### Hiérarchie

```
Exceptions (Data Layer)          Failures (Domain/Presentation)
──────────────────────           ────────────────────────────
AppException                     Failure (abstract)
├── ServerException    →         ├── ServerFailure
├── NetworkException   →         ├── NetworkFailure
├── AuthException      →         ├── AuthFailure
├── NotFoundException  →         ├── NotFoundFailure
└── CacheException     →         └── CacheFailure
                                 └── UnexpectedFailure
```

- Les **exceptions** sont levées par la couche Data
- Les **failures** sont utilisées en domain/presentation quand on préfère ne pas propager d'exceptions (pattern optionnel)
- En practice dans ce projet, les exceptions se propagent jusqu'au provider Riverpod qui les capture via `try/catch`

### Dans les widgets

```dart
entitiesAsync.when(
  loading: () => const AppLoadingWidget(),
  error: (error, stack) => AppErrorWidget(
    message: error is ServerFailure
        ? 'Erreur serveur: ${error.message}'
        : error.toString(),
    onRetry: () => ref.invalidate(myEntitiesProvider),
  ),
  data: (data) => /* ... */,
);
```

---

## 📝 Conventions de code

### Naming

| Élément | Convention | Exemple |
|---------|-----------|---------|
| Fichiers | snake_case | `restaurant_detail_page.dart` |
| Classes | PascalCase | `RestaurantDetailPage` |
| Variables / méthodes | camelCase | `restaurantId`, `getById()` |
| Constantes | camelCase (ou UPPER si static final) | `AppConstants.baseUrl` |
| Providers Riverpod | camelCase + `Provider` suffix | `restaurantsProvider` |
| DataSources | PascalCase + `RemoteDataSource` | `RestaurantsRemoteDataSource` |
| Repositories | PascalCase + `Repository` (interface) / `RepositoryImpl` (impl) | `AuthRepository`, `AuthRepositoryImpl` |
| UseCases | PascalCase + `UseCase` | `LoginUseCase` |
| Models | PascalCase + `Model` | `RestaurantModel` |

### Imports — ordre

```dart
// 1. Packages Flutter/Dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 2. Packages tiers
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

// 3. Imports locaux (relatifs)
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/restaurant.dart';
import '../providers/restaurants_provider.dart';
import '../../widgets/restaurant_card.dart';
```

### Constantes globales

Toujours utiliser `AppConstants` de `core/constants/app_constants.dart` :

```dart
// ✅ BON
static const String baseUrl = AppConstants.baseUrl;
await Future.delayed(AppConstants.connectTimeout);

// ❌ MAUVAIS
final url = 'https://api.kalynow.com/v1'; // hardcoded
```

---

## 📂 Features existantes

### `features/auth/`
- **Entité** : `User` (id, email, name, avatarUrl?, phoneNumber?)
- **State** : `AuthState` sealed class — `AuthInitial | AuthLoading | AuthAuthenticated | AuthUnauthenticated | AuthError`
- **Provider** : `authNotifierProvider` (StateNotifierProvider) — méthodes `login()`, `register()`, `logout()`
- **UseCases** : `LoginUseCase`, `RegisterUseCase`, `LogoutUseCase`
- **Clés de stockage** : `AppConstants.authTokenKey`, `AppConstants.refreshTokenKey`, `AppConstants.userIdKey`

### `features/restaurants/`
- **Entité** : `Restaurant` (id, name, description, imageUrl, rating, reviewCount, deliveryTimeMinutes, deliveryFee, category, isOpen)
- **Enum** : `RestaurantCategory` (burger, pizza, sushi, mexican, indian, chinese, italian, other)
- **Providers** :
  - `restaurantsProvider` — `FutureProvider<List<Restaurant>>`
  - `restaurantByIdProvider` — `FutureProvider.family<Restaurant, String>`
- **Routes** : `/home` (liste) → `/restaurants/:id` (détail)

### `features/offers/`
- **Entité** : `Offer` (id, title, description, imageUrl, discountPercentage, validUntil, restaurantId, restaurantName)
- **Computed** : `offer.isExpired` → `DateTime.now().isAfter(validUntil)`
- **Providers** : à compléter selon les besoins

---

## 🔧 Shared

### `shared/widgets/`
- `AppLoadingWidget` — spinner de chargement centralisé
- `AppErrorWidget` — affichage d'erreur avec callback `onRetry`

```dart
// Usage type dans les pages
entitiesAsync.when(
  loading: () => const AppLoadingWidget(),
  error: (e, _) => AppErrorWidget(message: e.toString(), onRetry: () => ref.invalidate(provider)),
  data: (data) => /* ... */,
);
```

### `shared/utils/`
Utilitaires réutilisables (helpers de date, formatage, etc.)

---

## ✅ Checklist — Ajouter une nouvelle feature

- [ ] **Entité** : créer `domain/entities/[entity].dart` extends `Equatable`
- [ ] **Repository interface** : créer `domain/repositories/[feature]_repository.dart`
- [ ] **UseCase(s)** : créer `domain/usecases/[action]_usecase.dart` implements `UseCase<T,P>`
- [ ] **Model** : créer `data/models/[entity]_model.dart` extends l'entité, avec `fromJson`/`toJson`
- [ ] **DataSource** : créer interface + impl dans `data/datasources/[feature]_remote_datasource.dart`
- [ ] **Repository impl** : créer `data/repositories/[feature]_repository_impl.dart`
- [ ] **Providers** : créer `presentation/providers/[feature]_provider.dart` (datasource → repo → usecase → state)
- [ ] **Page(s)** : créer `presentation/pages/[feature]_page.dart` (ConsumerWidget)
- [ ] **Route** : ajouter dans `core/router/app_router.dart`
- [ ] **Widgets** : créer dans `presentation/widgets/` si nécessaire

---

## 🚫 À ne jamais faire

- ❌ Appeler `Dio` directement dans un widget ou un provider — passer par le DataSource
- ❌ Importer des packages `data/` dans la couche `domain/`
- ❌ Utiliser `localhost` ou des URLs hardcodées — utiliser `AppConstants.baseUrl`
- ❌ Créer un provider Riverpod sans l'enregistrer dans la chaîne de dépendances
- ❌ Utiliser `ref.read()` dans le `build()` — utiliser `ref.watch()` pour réagir aux changements
- ❌ Lancer `flutter pub get` / `flutter pub run` directement — toujours préfixer avec `fvm`
- ❌ Casser l'immutabilité des entités — elles ne doivent pas avoir de setters

---

**Version**: 1.0
**Projet**: kalyNow Mobile (BUYER app)
**Dernière mise à jour**: 2025
**Stack**: Flutter 3.27.3 · Riverpod · go_router · Dio · Clean Architecture
