import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songquest/bloc/account_event.dart';
import 'package:songquest/bloc/account_state.dart';
import 'package:songquest/helper/constant.dart';
import 'package:songquest/helper/http.dart';
import 'package:songquest/repo/settings_repo.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final SettingsRepository settingsRepository;

  AccountBloc(this.settingsRepository) : super(AccountInitial()) {
    on<AccountLoadEvent>((event, emit) async {
      emit(AccountLoading());

      final token = settingsRepository.get(settingAPIServerToken);
      if (token != null && token != '') {
        try {
          // final user = await APIServer().userInfo(cache: event.cache);
          // if (user != null) {
          //   emit(AccountLoaded(user));
          // } else {
          //   emit(AccountNeedSignIn());
          // }
        } catch (e) {
          emit(AccountLoaded(null, error: e));
        }
      } else {
        emit(AccountNeedSignIn());
      }
    });

    on<AccountSignOutEvent>((event, emit) async {
      await settingsRepository.set(settingAPIServerToken, '');
      await settingsRepository.set(settingUserInfo, '');

      await HttpClient.cleanCache();
      emit(AccountNeedSignIn());
    });
  }
}
