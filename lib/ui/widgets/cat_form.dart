import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:requests_with_riverpod/models/kind.dart';
import 'package:requests_with_riverpod/providers/business_logic/create_cat_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/edit_cat_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/form_data_provider.dart';
import 'package:requests_with_riverpod/providers/business_logic/kinds_provider.dart';
import 'package:requests_with_riverpod/ui/widgets/input_field.dart';
import 'package:requests_with_riverpod/ui/widgets/label_text.dart';

class CatForm extends ConsumerWidget {
  const CatForm({
    super.key,
    required this.formKey,
    required this.showColorPicker,
    required this.ageValidator,
    required this.descriptionValidator,
    required this.kindValidator,
    required this.onSubmit,
    //For editable form
    this.isEditting,
    this.exColor,
    this.exAge,
    this.exDescription,
    this.exKind,
  });

  final GlobalKey<FormState> formKey;
  final void Function() showColorPicker;
  final String? Function(String? value) ageValidator;
  final String? Function(String? value) descriptionValidator;
  final String? Function(Kind? kind) kindValidator;
  final void Function() onSubmit;

  //For editable form
  final bool? isEditting;
  final Color? exColor;
  final int? exAge;
  final String? exDescription;
  final Kind? exKind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final kindsList = ref.watch(kindsProvider);
    final pickedColor = ref.watch(pickedColorProvider);
    final selectedKind = ref.watch(selectedKindProvider);
    final newCatState = ref.watch(createCatProvider);
    final editCatState = ref.watch(editCatProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (newCatState.isSuccess || editCatState.isSuccess) {
          Navigator.of(context).pop();
          newCatState.isSuccess
              ? ref.read(createCatProvider.notifier).backToInitial()
              : ref.read(editCatProvider.notifier).backToInitial();
        } else if (newCatState.errorMessage != null ||
            editCatState.errorMessage != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: Icon(
                Icons.error,
                size: 45,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Ошибка',
                style: theme.textTheme.titleLarge,
              ),
              content: Text(
                newCatState.errorMessage != null
                    ? newCatState.errorMessage!
                    : editCatState.errorMessage!,
                style: theme.textTheme.titleSmall,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ок'),
                )
              ],
            ),
          );
          newCatState.errorMessage != null
              ? ref.read(createCatProvider.notifier).backToInitial()
              : ref.read(editCatProvider.notifier).backToInitial();
        }
      },
    );

    return SizedBox(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height * 0.90,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.0,
            32.0,
            16.0,
            mediaQuery.viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      color: pickedColor,
                    ),
                    ElevatedButton(
                      onPressed: showColorPicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        fixedSize: Size.fromWidth(mediaQuery.size.width * 0.8),
                      ),
                      child: Text(
                        'Выбери цвет',
                        style: TextStyle(
                          color: theme.canvasColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),
                const LabelText(
                  text: 'Возвраст:',
                  spaceBefore: 5,
                ),
                InputField(
                  initialValue: exAge?.toString(),
                  validator: ageValidator,
                  onSaved: (value) {
                    final intAge = int.parse(value!);
                    ref
                        .read(enteredAgeProvider.notifier)
                        .changeEnteredAge(intAge);
                  },
                  border: Border.all(color: theme.primaryColor),
                  horizontalPaddingValue: 0.0,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 18.0),
                const LabelText(
                  text: 'Описание:',
                  spaceBefore: 5,
                ),
                InputField(
                  initialValue: exDescription,
                  validator: descriptionValidator,
                  onSaved: (value) => ref
                      .read(enteredDescriptionProvider.notifier)
                      .changeEnteredDescription(value!),
                  border: Border.all(color: theme.primaryColor),
                  horizontalPaddingValue: 0.0,
                ),
                const SizedBox(height: 18.0),
                kindsList.whenOrNull(
                      data: (kinds) => DropdownButtonFormField(
                        isExpanded: true,
                        itemHeight: 70,
                        iconSize: 40,
                        dropdownColor: theme.colorScheme.secondaryContainer,
                        value: exKind != null
                            ? kinds.firstWhere((k) => k.id == exKind!.id)
                            : selectedKind,
                        hint: const Text('Выбери пароду'),
                        items: kinds
                            .map(
                              (k) => DropdownMenuItem(
                                value: k,
                                child: Text(k.name),
                              ),
                            )
                            .toList(),
                        onChanged: (newKind) => ref
                            .read(selectedKindProvider.notifier)
                            .changeSelectedKind(newKind!),
                        validator: kindValidator,
                      ),
                    ) ??
                    Container(),
                const SizedBox(height: 35.0),
                ElevatedButton(
                  onPressed: editCatState.isLoading || newCatState.isLoading
                      ? null
                      : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    fixedSize: Size(mediaQuery.size.width * 0.5, 50),
                  ),
                  child: editCatState.isLoading || newCatState.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          isEditting == true ? 'Изменить' : 'Создать',
                          style: TextStyle(color: theme.canvasColor),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
