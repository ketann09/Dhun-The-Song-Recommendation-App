import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<LetsGoButtonPressed>((event, emit) {
      emit(NavigatingToHome());
    });
  }
}
