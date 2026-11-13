import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shopping_list/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:shopping_list/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_in.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_out.dart';
import 'package:shopping_list/features/auth/domain/usecases/sign_up.dart';
import 'package:shopping_list/features/auth/domain/usecases/watch_auth_user.dart';
import 'package:shopping_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopping_list/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopping_list/features/household/data/repositories/firebase_household_repository.dart';
import 'package:shopping_list/features/household/domain/repositories/household_repository.dart';
import 'package:shopping_list/features/household/domain/usecases/create_household.dart';
import 'package:shopping_list/features/household/domain/usecases/join_household.dart';
import 'package:shopping_list/features/household/domain/usecases/watch_user_household.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_cubit.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_setup_cubit.dart';
import 'package:shopping_list/features/shopping_list/data/repositories/firebase_catalog_repository.dart';
import 'package:shopping_list/features/shopping_list/data/repositories/firebase_shopping_list_repository.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/catalog_repository.dart';
import 'package:shopping_list/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/add_catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/add_shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/remove_catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/remove_shopping_item.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/toggle_item_bought.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/toggle_product_pinned.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/update_catalog_product.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/watch_catalog_products.dart';
import 'package:shopping_list/features/shopping_list/domain/usecases/watch_shopping_items.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/catalog_cubit.dart';
import 'package:shopping_list/features/shopping_list/presentation/cubit/shopping_list_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // ===== auth =====
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(FirebaseAuth.instance),
  );
  getIt.registerFactory(() => WatchAuthUser(getIt()));
  getIt.registerFactory(() => SignIn(getIt()));
  getIt.registerFactory(() => SignUp(getIt()));
  getIt.registerFactory(() => SignOut(getIt()));
  getIt.registerFactory(
    () => AuthCubit(watchAuthUser: getIt(), signOut: getIt()),
  );
  getIt.registerFactory(() => SignInWithGoogle(getIt()));
  getIt.registerFactory(
    () =>
        LoginCubit(signIn: getIt(), signUp: getIt(), signInWithGoogle: getIt()),
  );

  // ===== household =====
  getIt.registerLazySingleton<HouseholdRepository>(
    () => FirebaseHouseholdRepository(FirebaseFirestore.instance),
  );
  getIt.registerFactory(() => WatchUserHousehold(getIt()));
  getIt.registerFactory(() => CreateHousehold(getIt()));
  getIt.registerFactory(() => JoinHousehold(getIt()));
  getIt.registerFactory(() => HouseholdCubit(watchUserHousehold: getIt()));
  getIt.registerFactory(
    () => HouseholdSetupCubit(createHousehold: getIt(), joinHousehold: getIt()),
  );

  // ===== shopping list =====
  getIt.registerLazySingleton<ShoppingListRepository>(
    () => FirebaseShoppingListRepository(FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<CatalogRepository>(
    () => FirebaseCatalogRepository(FirebaseFirestore.instance),
  );
  getIt.registerFactory(() => WatchShoppingItems(getIt()));
  getIt.registerFactory(() => AddShoppingItem(getIt(), getIt()));
  getIt.registerFactory(() => ToggleItemBought(getIt()));
  getIt.registerFactory(() => RemoveShoppingItem(getIt()));
  getIt.registerFactory(() => WatchCatalogProducts(getIt()));
  getIt.registerFactory(() => AddCatalogProduct(getIt()));
  getIt.registerFactory(() => UpdateCatalogProduct(getIt()));
  getIt.registerFactory(() => ToggleProductPinned(getIt()));
  getIt.registerFactory(() => RemoveCatalogProduct(getIt()));
  getIt.registerFactory(
    () => CatalogCubit(
      watchCatalogProducts: getIt(),
      addCatalogProduct: getIt(),
      updateCatalogProduct: getIt(),
      toggleProductPinned: getIt(),
      removeCatalogProduct: getIt(),
      addShoppingItem: getIt(),
    ),
  );
  getIt.registerFactory(
    () => ShoppingListCubit(
      watchShoppingItems: getIt(),
      watchCatalogProducts: getIt(),
      addShoppingItem: getIt(),
      toggleItemBought: getIt(),
      removeShoppingItem: getIt(),
    ),
  );
}
