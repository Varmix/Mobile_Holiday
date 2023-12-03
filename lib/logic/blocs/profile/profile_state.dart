part of 'profile_bloc.dart';

enum ProfileStatus { initial, requested }

class ProfileState {
  final ProfileStatus profileStatus;
  final String email;

  ProfileState({this.profileStatus = ProfileStatus.initial, this.email = ""});

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    String? email,
  }) {
    return ProfileState(
        profileStatus: profileStatus ?? this.profileStatus,
        email: email ?? this.email
    );
  }
}
