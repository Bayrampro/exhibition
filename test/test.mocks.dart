// Mocks generated by Mockito 5.4.4 from annotations
// in requests_with_riverpod/test/test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:requests_with_riverpod/api/api_service.dart' as _i4;
import 'package:requests_with_riverpod/models/auth_response.dart' as _i3;
import 'package:requests_with_riverpod/models/kind.dart' as _i6;
import 'package:requests_with_riverpod/models/models.dart' as _i2;
import 'package:shared_preferences/src/shared_preferences_legacy.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCat_0 extends _i1.SmartFake implements _i2.Cat {
  _FakeCat_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuthResponse_1 extends _i1.SmartFake implements _i3.AuthResponse {
  _FakeAuthResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiService extends _i1.Mock implements _i4.ApiService {
  MockApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i2.Cat>> getCats() => (super.noSuchMethod(
        Invocation.method(
          #getCats,
          [],
        ),
        returnValue: _i5.Future<List<_i2.Cat>>.value(<_i2.Cat>[]),
      ) as _i5.Future<List<_i2.Cat>>);

  @override
  _i5.Future<_i2.Cat> getCatsDetail(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getCatsDetail,
          [id],
        ),
        returnValue: _i5.Future<_i2.Cat>.value(_FakeCat_0(
          this,
          Invocation.method(
            #getCatsDetail,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Cat>);

  @override
  _i5.Future<void> createCat(Map<String, dynamic>? body) => (super.noSuchMethod(
        Invocation.method(
          #createCat,
          [body],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i3.AuthResponse> getAuthToken(Map<String, dynamic>? body) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAuthToken,
          [body],
        ),
        returnValue: _i5.Future<_i3.AuthResponse>.value(_FakeAuthResponse_1(
          this,
          Invocation.method(
            #getAuthToken,
            [body],
          ),
        )),
      ) as _i5.Future<_i3.AuthResponse>);

  @override
  _i5.Future<_i3.AuthResponse> refreshAuthToken(Map<String, dynamic>? body) =>
      (super.noSuchMethod(
        Invocation.method(
          #refreshAuthToken,
          [body],
        ),
        returnValue: _i5.Future<_i3.AuthResponse>.value(_FakeAuthResponse_1(
          this,
          Invocation.method(
            #refreshAuthToken,
            [body],
          ),
        )),
      ) as _i5.Future<_i3.AuthResponse>);

  @override
  _i5.Future<void> rateCat(
    int? id,
    Map<String, dynamic>? body,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rateCat,
          [
            id,
            body,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<List<_i6.Kind>> getKinds() => (super.noSuchMethod(
        Invocation.method(
          #getKinds,
          [],
        ),
        returnValue: _i5.Future<List<_i6.Kind>>.value(<_i6.Kind>[]),
      ) as _i5.Future<List<_i6.Kind>>);

  @override
  _i5.Future<List<_i2.Cat>> getCatsByKind(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getCatsByKind,
          [id],
        ),
        returnValue: _i5.Future<List<_i2.Cat>>.value(<_i2.Cat>[]),
      ) as _i5.Future<List<_i2.Cat>>);

  @override
  _i5.Future<List<_i2.Cat>> getCatsByUser(int? userId) => (super.noSuchMethod(
        Invocation.method(
          #getCatsByUser,
          [userId],
        ),
        returnValue: _i5.Future<List<_i2.Cat>>.value(<_i2.Cat>[]),
      ) as _i5.Future<List<_i2.Cat>>);

  @override
  _i5.Future<void> deleteCatById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteCatById,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateCatById(
    int? id,
    Map<String, dynamic>? body,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateCatById,
          [
            id,
            body,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateWholeCatById(
    int? id,
    Map<String, dynamic>? body,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateWholeCatById,
          [
            id,
            body,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [SharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferences extends _i1.Mock implements _i7.SharedPreferences {
  MockSharedPreferences() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Set<String> getKeys() => (super.noSuchMethod(
        Invocation.method(
          #getKeys,
          [],
        ),
        returnValue: <String>{},
      ) as Set<String>);

  @override
  Object? get(String? key) => (super.noSuchMethod(Invocation.method(
        #get,
        [key],
      )) as Object?);

  @override
  bool? getBool(String? key) => (super.noSuchMethod(Invocation.method(
        #getBool,
        [key],
      )) as bool?);

  @override
  int? getInt(String? key) => (super.noSuchMethod(Invocation.method(
        #getInt,
        [key],
      )) as int?);

  @override
  double? getDouble(String? key) => (super.noSuchMethod(Invocation.method(
        #getDouble,
        [key],
      )) as double?);

  @override
  String? getString(String? key) => (super.noSuchMethod(Invocation.method(
        #getString,
        [key],
      )) as String?);

  @override
  bool containsKey(String? key) => (super.noSuchMethod(
        Invocation.method(
          #containsKey,
          [key],
        ),
        returnValue: false,
      ) as bool);

  @override
  List<String>? getStringList(String? key) =>
      (super.noSuchMethod(Invocation.method(
        #getStringList,
        [key],
      )) as List<String>?);

  @override
  _i5.Future<bool> setBool(
    String? key,
    bool? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setBool,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setInt(
    String? key,
    int? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setInt,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setDouble(
    String? key,
    double? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setDouble,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setString(
    String? key,
    String? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setString,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setStringList(
    String? key,
    List<String>? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setStringList,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> remove(String? key) => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [key],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> commit() => (super.noSuchMethod(
        Invocation.method(
          #commit,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> clear() => (super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<void> reload() => (super.noSuchMethod(
        Invocation.method(
          #reload,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
