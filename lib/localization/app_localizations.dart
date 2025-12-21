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
      'ready_for_today': '오늘 준비되셨나요?',
      'no_goal_set_today': '오늘 설정된 목표가 없습니다',
      'clear_mind_description': '마음을 비우고, 오늘의 단 하나의\n집중할 목표를 정의해보세요.',
      'define_your_focus': '집중할 목표 정의',
      'start_here': '여기서 시작',
      'home': '홈',
      'settings': '설정',
      'remaining_time': '남은 시간',
      'until_midnight': '자정까지 남은 시간',
      'hours': '시간',
      'minutes': '분',
      'left': '남았습니다',
      'complete_goal': '목표 완료',
      'create_goal': '목표 생성',
      'goal_name': '목표 이름',
      'goal_name_hint': '예: 영어 문법 공부',
      'my_goal': '나의 목표',
      'my_goal_question': '오늘 반드시 이루고 싶은 한 가지는\n무엇인가요?',
      'focus_time': '알람 시간',
      'goal_time': '알람 시간',
      'alarm_time_description': '자정 되기 설정한 시간 전에 알림',
      'alarm_setting': '알람 설정',
      'optional': '선택사항',
      'no_alarm_set': '알람이 설정되지 않았습니다',
      'add_alarm': '알람 추가',
      'goal_end_alarm': '자정 되기 해당 시간 전에 알림',
      'alarm_activation': '알람 활성화',
      'alarm_time_setting': '알람 시간 설정',
      'until_midnight_based': '자정까지 남은 시간 기준',
      'before': '전',
      'cancel': '취소',
      'confirm': '확인',
      'select_time': '시간을 선택해주세요',
      'duplicate_alarm': '알람이 이미 추가되어 있습니다',
      'time_exceeds_remaining': '현재 남은 시간보다 더 크게 설정할 수 없습니다.',
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
      'in_progress': '진행 중',
      'todays_focus': '오늘의 집중',
      'time_remaining_label': '남은 시간',
      'mark_as_complete': '완료',
      'edit_goal': '목표 수정',
      'coming_soon': '준비중입니다',
      'edit_goal_coming_soon': '목표 수정 기능은 준비중입니다',
      'goal_quote': '"수분을 충분히 섭취하여 정신을 맑게 유지하고\n몸을 활기차게 만드세요."',
    },
    'en': {
      'app_title': 'One Today',
      'today_goal': "Today's Goal",
      'no_goal': 'No goal for today',
      'no_goal_description': 'Set one goal you want to achieve today',
      'add_goal': 'Add Goal',
      'ready_for_today': 'Ready for today?',
      'no_goal_set_today': 'No goal set for today',
      'clear_mind_description':
          'Clear your mind. Define your single focus to\nstart the timer.',
      'define_your_focus': 'Define Your Focus',
      'start_here': 'Start here',
      'home': 'Home',
      'settings': 'Settings',
      'remaining_time': 'Remaining Time',
      'until_midnight': 'Time until midnight',
      'hours': 'hours',
      'minutes': 'minutes',
      'left': 'left',
      'complete_goal': 'Complete Goal',
      'create_goal': 'Create Goal',
      'goal_name': 'Goal Name',
      'goal_name_hint': 'e.g., Study English grammar',
      'my_goal': 'YOUR AMBITION',
      'my_goal_question': 'What is the one thing you must\nachieve today?',
      'focus_time': 'Alarm Time',
      'goal_time': 'Alarm Setting',
      'alarm_time_description': 'Alarm before midnight at the set time',
      'alarm_setting': 'Alarm Setting',
      'optional': 'Optional',
      'no_alarm_set': 'No alarm set',
      'add_alarm': 'Add Alarm',
      'goal_end_alarm': 'Alarm before midnight at the specified time',
      'alarm_activation': 'Alarm Activation',
      'alarm_time_setting': 'Set Alarm Time',
      'until_midnight_based': 'Based on time until midnight',
      'before': 'before',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'select_time': 'Please select a time',
      'duplicate_alarm': 'This alarm is already added',
      'time_exceeds_remaining':
          'Cannot set a time greater than the remaining time.',
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
      'in_progress': 'IN PROGRESS',
      'todays_focus': "TODAY'S FOCUS",
      'time_remaining_label': 'Time Remaining',
      'mark_as_complete': 'Mark as Complete',
      'edit_goal': 'Edit Goal',
      'coming_soon': 'Coming soon',
      'edit_goal_coming_soon': 'Edit goal is coming soon',
      'goal_quote':
          '"Stay hydrated to keep your mind sharp\nand your body active."',
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
  String get readyForToday => translate('ready_for_today');
  String get noGoalSetToday => translate('no_goal_set_today');
  String get clearMindDescription => translate('clear_mind_description');
  String get defineYourFocus => translate('define_your_focus');
  String get startHere => translate('start_here');
  String get home => translate('home');
  String get settings => translate('settings');
  String get remainingTime => translate('remaining_time');
  String get untilMidnight => translate('until_midnight');
  String get hours => translate('hours');
  String get minutes => translate('minutes');
  String get left => translate('left');
  String get completeGoal => translate('complete_goal');
  String get createGoal => translate('create_goal');
  String get goalName => translate('goal_name');
  String get goalNameHint => translate('goal_name_hint');
  String get myGoal => translate('my_goal');
  String get myGoalQuestion => translate('my_goal_question');
  String get focusTime => translate('focus_time');
  String get goalTime => translate('goal_time');
  String get alarmTimeDescription => translate('alarm_time_description');
  String get alarmSetting => translate('alarm_setting');
  String get optional => translate('optional');
  String get noAlarmSet => translate('no_alarm_set');
  String get addAlarm => translate('add_alarm');
  String get goalEndAlarm => translate('goal_end_alarm');
  String get alarmActivation => translate('alarm_activation');
  String get alarmTimeSetting => translate('alarm_time_setting');
  String get untilMidnightBased => translate('until_midnight_based');
  String get before => translate('before');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get selectTime => translate('select_time');
  String get duplicateAlarm => translate('duplicate_alarm');
  String get timeExceedsRemaining => translate('time_exceeds_remaining');
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
  String get inProgress => translate('in_progress');
  String get todaysFocus => translate('todays_focus');
  String get timeRemaining => translate('time_remaining_label');
  String get markAsComplete => translate('mark_as_complete');
  String get editGoal => translate('edit_goal');
  String get comingSoon => translate('coming_soon');
  String get editGoalComingSoon => translate('edit_goal_coming_soon');
  String get goalQuote => translate('goal_quote');
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
