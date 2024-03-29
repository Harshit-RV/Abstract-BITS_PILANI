import 'package:abstract_curiousity/Features/Profile/services/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc({required this.profileRepository}) : super(ProfileLoading()) {
    on<ProfileDetailsRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileRepository.getCurrentNameAndBio(
            firebaseUid: event.firebaseUid, context: event.context);
        emit(ProfileLoaded());
      } catch (e) {
        emit(ProfileError("Unable to Load data"));
        emit(ProfileNotFetched());
      }
    });
    on<ProfileDataUpdateRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        profileRepository.updateNameAndBio(
            firebaseUid: event.firebaseUid,
            name: event.name,
            bio: event.bio,
            context: event.context);
        emit(ProfileLoaded());
      } catch (e) {
        emit(ProfileError("Unable to Load data"));
        emit(ProfileNotFetched());
      }
    });
  }
}
