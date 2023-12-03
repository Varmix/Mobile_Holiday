import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:holiday_mobile/data/models/user_authentificated/user_authentificated.dart';
import 'package:holiday_mobile/data/repositories/authentification_api_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  ProfileBloc(this.authRepository) : super(ProfileState()) {
    on<ProfileEmailRequest>(_onEmailRequest);
  }

  void _onEmailRequest(ProfileEmailRequest event, Emitter<ProfileState> emit) {
    emit(state.copyWith(profileStatus: ProfileStatus.requested, email: authRepository.userConnected!.email));
  }
}
