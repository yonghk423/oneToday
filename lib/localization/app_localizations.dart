import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'ko': {
      'app_title': 'One Today',
      'today_goal': '오늘의 목표',
      'no_goal': '오늘 목표가 없습니다',
      'no_goal_description': '하루에 딱 하나, 오늘 꼭 이루고 싶은\n목표를 설정해보세요',
      'add_goal': '목표 추가',
      'remaining_time': '남은 시간',
      'until_midnight': '자정까지 남은 시간',
      'hours': '시간',
      'minutes': '분',
      'left': '남았습니다',
      'complete_goal': '목표 완료',
      'create_goal': '오늘의 목표 설정',
      'goal_name': '목표 이름',
      'goal_name_hint': '예: 영어 문법 공부',
      'alarm_setting': '알람 설정',
      'optional': '선택사항',
      'no_alarm_set': '알람이 설정되지 않았습니다',
      'add_alarm': '알람 추가',
      'alarm_time_setting': '알람 시간 설정',
      'until_midnight_based': '자정까지 남은 시간 기준',
      'before': '전',
      'cancel': '취소',
      'confirm': '확인',
      'select_time': '시간을 선택해주세요',
      'duplicate_alarm': '알람이 이미 추가되어 있습니다',
      'goal_already_exists': '오늘의 목표는 이미 설정되어 있습니다',
      'completed': '완료!',
      'goal_completed': '오늘의 목표를 달성했어요!',
      'continue_tomorrow': '내일도 계속 도전해보세요',
      'time_passed': '시간이 지났어요',
      'goal_not_completed': '오늘의 목표를 완료하지 못했습니다',
      'try_again_tomorrow': '괜찮아요! 내일 다시 도전해봐요',
      'hours_left': '시간 남았습니다',
      'minutes_left': '분 남았습니다',
      'goal_name_required': '목표 이름을 입력해주세요',
      'create_goal_button': '목표 생성',
      'today_remaining_time': '오늘 남은 시간',
      'until_midnight_time': '자정까지 남은 시간입니다',
      'alarm_before_format': '{hours}시간 {minutes}분 전',
    },
    'en': {
      'app_title': 'One Today',
      'today_goal': "Today's Goal",
      'no_goal': 'No goal for today',
      'no_goal_description': 'Set one goal you want to achieve today',
      'add_goal': 'Add Goal',
      'remaining_time': 'Remaining Time',
      'until_midnight': 'Time until midnight',
      'hours': 'hours',
      'minutes': 'minutes',
      'left': 'left',
      'complete_goal': 'Complete Goal',
      'create_goal': 'Set Today\'s Goal',
      'goal_name': 'Goal Name',
      'goal_name_hint': 'e.g., Study English grammar',
      'alarm_setting': 'Alarm Setting',
      'optional': 'Optional',
      'no_alarm_set': 'No alarm set',
      'add_alarm': 'Add Alarm',
      'alarm_time_setting': 'Set Alarm Time',
      'until_midnight_based': 'Based on time until midnight',
      'before': 'before',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'select_time': 'Please select a time',
      'duplicate_alarm': 'This alarm is already added',
      'goal_already_exists': 'Today\'s goal is already set',
      'completed': 'Completed!',
      'goal_completed': 'You achieved today\'s goal!',
      'continue_tomorrow': 'Keep challenging tomorrow',
      'time_passed': 'Time has passed',
      'goal_not_completed': 'You didn\'t complete today\'s goal',
      'try_again_tomorrow': 'It\'s okay! Try again tomorrow',
      'hours_left': 'hours left',
      'minutes_left': 'minutes left',
      'goal_name_required': 'Please enter a goal name',
      'create_goal_button': 'Create Goal',
      'today_remaining_time': 'Time Remaining Today',
      'until_midnight_time': 'Time remaining until midnight',
      'alarm_before_format': '{hours} hours {minutes} minutes before',
    },
  };

  // 동적 텍스트를 위한 메서드
  String alarmBefore(int hours, int minutes) {
    final format = translate('alarm_before_format');
    return format
        .replaceAll('{hours}', hours.toString())
        .replaceAll('{minutes}', minutes.toString());
  }

  String translate(String key) {
    // 현재 언어의 번역이 있으면 사용, 없으면 영어로, 그것도 없으면 key 반환
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // 편의 메서드들
  String get appTitle => translate('app_title');
  String get todayGoal => translate('today_goal');
  String get noGoal => translate('no_goal');
  String get noGoalDescription => translate('no_goal_description');
  String get addGoal => translate('add_goal');
  String get remainingTime => translate('remaining_time');
  String get untilMidnight => translate('until_midnight');
  String get hours => translate('hours');
  String get minutes => translate('minutes');
  String get left => translate('left');
  String get completeGoal => translate('complete_goal');
  String get createGoal => translate('create_goal');
  String get goalName => translate('goal_name');
  String get goalNameHint => translate('goal_name_hint');
  String get alarmSetting => translate('alarm_setting');
  String get optional => translate('optional');
  String get noAlarmSet => translate('no_alarm_set');
  String get addAlarm => translate('add_alarm');
  String get alarmTimeSetting => translate('alarm_time_setting');
  String get untilMidnightBased => translate('until_midnight_based');
  String get before => translate('before');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get selectTime => translate('select_time');
  String get duplicateAlarm => translate('duplicate_alarm');
  String get goalAlreadyExists => translate('goal_already_exists');
  String get completed => translate('completed');
  String get goalCompleted => translate('goal_completed');
  String get continueTomorrow => translate('continue_tomorrow');
  String get timePassed => translate('time_passed');
  String get goalNotCompleted => translate('goal_not_completed');
  String get tryAgainTomorrow => translate('try_again_tomorrow');
  String get hoursLeft => translate('hours_left');
  String get minutesLeft => translate('minutes_left');
  String get goalNameRequired => translate('goal_name_required');
  String get createGoalButton => translate('create_goal_button');
  String get todayRemainingTime => translate('today_remaining_time');
  String get untilMidnightTime => translate('until_midnight_time');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ko', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
