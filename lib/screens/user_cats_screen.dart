import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:requests_with_riverpod/models/cat.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/cat_list_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/cats_by_user_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/create_cat_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/delete_cat_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/edit_cat_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/form_data_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/cat_form.dart';
import 'package:requests_with_riverpod/ui/widgets/custom_app_bar.dart';
import 'package:requests_with_riverpod/ui/widgets/error_warning.dart';
import 'package:requests_with_riverpod/ui/widgets/loading_indicator.dart';
import 'package:requests_with_riverpod/ui/widgets/my_cats_list_item.dart';
import 'package:requests_with_riverpod/ui/widgets/question_dialog.dart';
import 'package:requests_with_riverpod/utils/hex_string_to_color.dart';

class UserCatsScreen extends ConsumerStatefulWidget {
  const UserCatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<UserCatsScreen> {
  final _formKey = GlobalKey<FormState>();

  void _showColorPicker(Color? catCurrentColor) {
    final pickedColor = ref.watch(pickedColorProvider);
    final pickedColorNotifier = ref.read(pickedColorProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Выбери цвет',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            colorPickerWidth:
                MediaQuery.of(context).size.width > 600 ? 200 : 300,
            pickerColor: catCurrentColor ?? pickedColor,
            onColorChanged: (Color color) =>
                pickedColorNotifier.changePickedColor(color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ок'),
          )
        ],
      ),
    );
  }

  String? _ageValidator(String? value) {
    if (value == null ||
        value.trim().isEmpty ||
        int.tryParse(value) == null ||
        int.parse(value) < 0) {
      return 'Пожалуйста введите валидное число';
    }
    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Поле не должно быть пустым';
    }
    return null;
  }

  String? _kindValidator(Kind? kind) {
    if (kind == null) {
      return 'Выберите пароду';
    }
    return null;
  }

  //======================================

  /*
  !!!
  CAT CREATE LOGIC FUNCTIONS START
  !!!
  */

  void _onCreateSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final pickedColor = ref.watch(pickedColorProvider);

    final hexColor = colorToHex(pickedColor, includeHashSign: true);

    final selectedKind = ref.watch(selectedKindProvider);

    final enteredAge = ref.watch(enteredAgeProvider);

    final enteredDescription = ref.watch(enteredDescriptionProvider);

    ref.read(createCatProvider.notifier).createNewCat({
      "color": hexColor,
      "age": enteredAge,
      "description": enteredDescription,
      "kind_id": selectedKind!.id
    });
  }

  void _showCatCreateForm() {
    ref.watch(selectedKindProvider) != null
        ? ref.read(selectedKindProvider.notifier).backToInitial()
        : null;
    ref.watch(pickedColorProvider) != Colors.brown
        ? ref.read(pickedColorProvider.notifier).backToInitial()
        : null;
    ref.watch(enteredAgeProvider) != 0
        ? ref.read(enteredAgeProvider.notifier).backToInitial()
        : null;
    ref.watch(enteredDescriptionProvider) != ''
        ? ref.read(enteredDescriptionProvider.notifier).backToInitial()
        : null;

    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => CatForm(
        showColorPicker: () => _showColorPicker(null),
        ageValidator: _ageValidator,
        descriptionValidator: _descriptionValidator,
        kindValidator: _kindValidator,
        formKey: _formKey,
        onSubmit: _onCreateSubmit,
      ),
    );
  }

  /*
  !!!
  CAT CREATE LOGIC FUNCTIONS END
  !!!
  */

  //======================================

  /*
  !!!
  CAT DELETE LOGIC FUNCTIONS START
  !!!
  */

  Future<bool?> _onConfirmDismiss(Cat cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => QuestionDialog(
        titleText: 'Удаление котенка',
        questionText: 'Вы действительно хотите удалить котенка?',
        yesOnPressed: () => Navigator.of(context).pop(true),
        noOnPressed: () => Navigator.of(context).pop(false),
      ),
    );

    if (confirmed == true) {
      await ref.read(deleteCatProvider.notifier).deleteCat(cat.id);
      // ignore: unused_result
      ref.refresh(catsByUserProvider);
      return true;
    } else {
      return false;
    }
  }

  /*
  !!!
  CAT DELETE LOGIC FUNCTIONS END
  !!!
  */

  //======================================

  /*
  !!!
  CAT EDIT LOGIC FUNCTIONS START
  !!!
  */

  void _onEditSubmit(
      int id, Color exColor, int exAge, String exDescription, Kind exKind) {
    final pickedColor = ref.watch(pickedColorProvider);

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final selectedKind = ref.watch(selectedKindProvider);

    final enteredAge = ref.watch(enteredAgeProvider);

    final enteredDescription = ref.watch(enteredDescriptionProvider);

    final Map<String, dynamic> requestBody = {};

    final List<String> mapKeys = ['color', 'age', 'description', 'kind_id'];

    if (exColor != pickedColor) {
      final hexColor = colorToHex(pickedColor, includeHashSign: true);
      requestBody.addAll({mapKeys[0]: hexColor});
      Logger().i(requestBody);
    }
    if (exAge != enteredAge) {
      requestBody.addAll({mapKeys[1]: enteredAge});
      Logger().i(requestBody);
    }
    if (exDescription != enteredDescription) {
      requestBody.addAll({mapKeys[2]: enteredDescription});
      Logger().i(requestBody);
    }
    if (exKind != selectedKind) {
      requestBody.addAll({mapKeys[3]: selectedKind!.id});
      Logger().i(requestBody);
    }

    if (requestBody.isEmpty) {
      ref.read(editCatProvider.notifier).noChangesAlert();
      return;
    }

    if (requestBody.keys.toList() == mapKeys) {
      ref.read(editCatProvider.notifier).updateWholeCat(id, requestBody);
      return;
    }

    ref.read(editCatProvider.notifier).updateCat(id, requestBody);
  }

  void _showCatEditForm(
      int id, Color exColor, int exAge, String exDescription, Kind exKind) {
    ref.read(selectedKindProvider.notifier).changeSelectedKind(exKind);
    ref.read(enteredAgeProvider.notifier).changeEnteredAge(exAge);
    ref
        .read(enteredDescriptionProvider.notifier)
        .changeEnteredDescription(exDescription);
    ref.read(pickedColorProvider.notifier).changePickedColor(exColor);
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => CatForm(
        showColorPicker: () => _showColorPicker(exColor),
        ageValidator: _ageValidator,
        descriptionValidator: _descriptionValidator,
        kindValidator: _kindValidator,
        formKey: _formKey,
        //...
        onSubmit: () =>
            _onEditSubmit(id, exColor, exAge, exDescription, exKind),
        isEditting: true,
        exColor: exColor,
        exAge: exAge,
        exDescription: exDescription,
        exKind: exKind,
      ),
    );
  }

  /*
  !!!
  CAT EDIT LOGIC FUNCTIONS END
  !!!
  */

  @override
  Widget build(BuildContext context) {
    final catsByUserList = ref.watch(catsByUserProvider);
    final theme = Theme.of(context);
    final newCatState = ref.watch(createCatProvider);
    final editCatState = ref.watch(editCatProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (newCatState.isSuccess || editCatState.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newCatState.isSuccess
                    ? 'Новый котенок успешно добавлен'
                    : 'Котенок успешно изменен',
                style: TextStyle(
                  color: theme.canvasColor,
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 34, 119, 37),
            ),
          );
          newCatState.isSuccess
              ? ref.read(createCatProvider.notifier).backToInitial()
              : ref.read(editCatProvider.notifier).backToInitial();
          // ignore: unused_result
          ref.refresh(catsByUserProvider);
        }
      },
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(catsByUserProvider),
        child: CustomScrollView(
          slivers: [
            CustomAppBar(
              backButton: IconButton(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(catListProvider);
                  context.go('/cat-list');
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            catsByUserList.when(
              data: (data) => SliverList.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => MyCatsListItem(
                  cat: data[index],
                  index: index,
                  listLength: data.length,
                  onEdit: () => _showCatEditForm(
                    data[index].id,
                    hexStringToColor(data[index].color),
                    data[index].age,
                    data[index].description,
                    data[index].kind,
                  ),
                  confirmDismiss: (_) => _onConfirmDismiss(data[index]),
                ),
              ),
              error: (error, stackTrace) => const ErrorWarning(),
              loading: () => const LoadingIndicator(),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: _showCatCreateForm,
        backgroundColor: theme.primaryColor,
        tooltip: 'Создать кота',
        child: Icon(
          Icons.add,
          color: theme.canvasColor,
        ),
      ),
    );
  }
}
