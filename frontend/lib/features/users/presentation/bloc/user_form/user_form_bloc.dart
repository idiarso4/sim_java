import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/users/domain/usecases/create_user.dart';
import 'package:frontend/features/users/domain/usecases/update_user.dart';

part of 'user_form_bloc.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final CreateUser createUser;
  final UpdateUser updateUser;

  UserFormBloc({
    required this.createUser,
    required this.updateUser,
  }) : super(const UserFormState()) {
    on<UserFormSubmitted>(_onSubmitted);
    on<UserFormReset>(_onReset);
    on<UserFormFieldChanged>(_onFieldChanged);
  }

  Future<void> _onSubmitted(
    UserFormSubmitted event,
    Emitter<UserFormState> emit,
  ) async {
    emit(state.copyWith(status: UserFormStatus.loading));

    try {
      if (event.userId != null) {
        // Update existing user
        final result = await updateUser(UpdateUserParams(
          id: event.userId!,
          data: event.formData,
        ));

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: UserFormStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (_) => emit(
            state.copyWith(status: UserFormStatus.success),
          ),
        );
      } else {
        // Create new user
        final result = await createUser(CreateUserParams(data: event.formData));

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: UserFormStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (_) => emit(
            state.copyWith(status: UserFormStatus.success),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UserFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onReset(
    UserFormReset event,
    Emitter<UserFormState> emit,
  ) {
    emit(const UserFormState());
  }

  void _onFieldChanged(
    UserFormFieldChanged event,
    Emitter<UserFormState> emit,
  ) {
    final newFormData = Map<String, dynamic>.from(state.formData);
    newFormData[event.field] = event.value;
    
    emit(state.copyWith(
      formData: newFormData,
      // Clear any previous errors for this field
      errors: Map<String, String>.from(state.errors)..remove(event.field),
    ));
  }
}
