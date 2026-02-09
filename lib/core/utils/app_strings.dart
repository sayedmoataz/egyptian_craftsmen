import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// App strings helper class for localization.
/// Use the `of(context)` method to get context-aware translations.
class AppStrings {
  final BuildContext _context;

  AppStrings._(this._context);

  /// Get an instance of AppStrings with the given context
  static AppStrings of(BuildContext context) => AppStrings._(context);

  /// Translate a key using the current context
  String tr(String key) => key.tr(context: _context);

  String trWithParams(String key, List<String> params) {
    String text = tr(key);
    for (int i = 0; i < params.length; i++) {
      text = text.replaceAll('{$i}', params[i]);
    }
    return text;
  }

  // Onboarding
  String get onboardingTrustedMarketplaceTitle =>
      tr('onboarding_trusted_marketplace_title');
  String get onboardingTrustedMarketplaceDesc =>
      tr('onboarding_trusted_marketplace_desc');
  String get onboardingSmartDiscoveryTitle =>
      tr('onboarding_smart_discovery_title');
  String get onboardingSmartDiscoveryDesc =>
      tr('onboarding_smart_discovery_desc');
  String get onboardingSellFasterTitle => tr('onboarding_sell_faster_title');
  String get onboardingSellFasterDesc => tr('onboarding_sell_faster_desc');
  String get next => tr('next');
  String get skip => tr('skip');

  // Auth - Login
  String get login => tr('login');
  String get loginToYourAccount => tr('login_to_your_account');
  String get rememberMe => tr('remember_me');
  String get email => tr('email');
  String get enterYourEmail => tr('Enter_your_email');
  String get password => tr('password');
  String get enterYourPassword => tr('Enter_your_password');
  String get forgetPassword => tr('forget_password');

  // Auth - Forget Password
  String get forgetPasswordDescription => tr('forget_password_description');
  String get resetPassword => tr('reset_password');

  // Auth - Create New Password
  String get createNewPassword => tr('create_new_password');
  String get createNewPasswordDescription =>
      tr('create_new_password_description');
  String get confirmPassword => tr('confirm_password');
  String get passwordMinCharacters => tr('password_min_characters');
  String get itsBetterToHave => tr('its_better_to_have');
  String get upperLowerCaseLetters => tr('upper_lower_case_letters');
  String get specialCharacters => tr('special_characters');
  String get numbers => tr('numbers');
  String get submit => tr('submit');

  // Auth - Sign Up
  String get dontHaveAccount => tr('dont_have_account');
  String get haveAnAccount => tr('have_an_account');
  String get register => tr('register');
  String get signup => tr('signup');
  String get enterYourDetailToRegister => tr('enter_your_detail_to_register');
  String get name => tr('name');
  String get enterYourName => tr('enter_your_name');
  String get phoneNumber => tr('phone_number');
  String get enterYourNumber => tr('enter_your_number');
  String get iAgreeWithTermsAndConditions =>
      tr('i_agree_with_terms_and_conditions');
  String get pleaseAcceptTerms => tr('please_accept_terms');

  // Auth - Verify Email
  String get verify => tr('verify');
  String get didntReceiveCode => tr('didnt_receive_code');
  String get checkYourEmail => tr('check_your_email');
  String get verifyEmailDescription => tr('verify_email_description');
  String get sendAgain => tr('send_again');

  // General
  String get searchCountry => tr('search_country');
  String get brands => tr('brands');

  // Home Screen
  String get home => tr('home');
  String get search => tr('search');
  String get searchHint => tr('search_hint');
  String get searchCategory => tr('search_category');
  String get kuwaitCity => tr('kuwait_city');
  String get notifications => tr('notifications');
  String get favorites => tr('favorites');
  String get seeAll => tr('see_all');
  String get recentlyViewed => tr('recently_viewed');
  String get egp => tr('egp');
  String get kwd => tr('kwd');
  String get categories => tr('categories');
  String get vehicles => tr('vehicles');
  String get electronics => tr('electronics');
  String get properties => tr('properties');
  String get services => tr('services');
  String get fashion => tr('fashion');
  String get sports => tr('sports');
  String get add => tr('add');
  String get product => tr('product');
  String get service => tr('service');
  String get profile => tr('profile');

  // Home Screen - New sections
  String get browseCategories => tr('browse_categories');
  String get exploreKuwait => tr('explore_kuwait');
  String get realEstateAds => tr('real_estate_ads');
  String get electronicAds => tr('electronic_ads');
  String get constructionAds => tr('construction_ads');
  String get classifiedAds => tr('classified_ads');
  String get commercialAds => tr('commercial_ads');
  String get commercial => tr('commercial');
  String get verified => tr('verified');
  String get ago => tr('ago');

  // Categories
  String get engines => tr('engines');
  String get realEstate => tr('real_estate');
  String get construction => tr('construction');
  String get camping => tr('camping');
  String get animals => tr('animals');
  String get furniture => tr('furniture');
  String get gifts => tr('gifts');
  String get jobs => tr('jobs');
  String get fashionFamily => tr('fashion_family');
  String get education => tr('education');
  String get miscellaneous => tr('miscellaneous');
  String get entertainment => tr('entertainment');
  String get healthcare => tr('healthcare');
  String get fitnessSports => tr('fitness_sports');
  String get restaurantsCafes => tr('restaurants_cafes');

  // utils
  String get youAreOffline => tr('you_are_offline');
  String get youAreOfflineDescription => tr('you_are_offline_description');
  String get tryAgain => tr('try_again');
  String get forceUpdate => tr('force_update');
  String get forceUpdateDescription => tr('force_update_description');
  String get updateNow => tr('update_now');

  String get allCategories => tr('all_categories');
  String get noCategoriesFound => tr('no_categories_found');
  String get country => tr('country');
  String get selectCountry => tr('select_country');
  String get pleaseSelectCountry => tr('please_select_country');
  String get noFavoritesYet => tr('no_favorites_yet');
  String get retry => tr('retry');
  String get noReviews => tr('no_reviews');
  String get noReviewsDesc => tr('no_reviews_desc');

  // Notifications
  String get notificationsAll => tr('notifications_all');
  String get notificationsOffers => tr('notifications_offers');
  String get notificationsSystem => tr('notifications_system');
  String get noNotificationsYet => tr('no_notifications_yet');
  String get viewOffer => tr('view_offer');

  // Product Details
  String get negotiable => tr('negotiable');
  String get description => tr('description');
  String get inStock => tr('in_stock');
  String get yes => tr('yes');
  String get no => tr('no');
  String get viewProfile => tr('view_profile');
  String get call => tr('call');
  String get message => tr('message');
  String get somethingWentWrong => tr('something_went_wrong');
  String get somethingWentWrongDescription => tr('something_went_wrong_description');

  // Product Details - Additional
  String get freeInspection => tr('free_inspection');
  String get reviews => tr('reviews');
  String get location => tr('location');
  String get posted => tr('posted');
  String get conditionLabel => tr('condition');
  String get days => tr('days');
  String get viewedBy => tr('viewed_by');
  String get adId => tr('ad_id');
  String get reportAd => tr('report_ad');
  String get rateAd => tr('rate_ad');
  String get submitRating => tr('submit_rating');
  String get rateAdValue => tr('rate_ad_value');
  String get keyFeatures => tr('key_features');
  String get whatsapp => tr('whatsapp');
  String get callNow => tr('call_now');
  String get newCondition => tr('new');

  // Validation Errors
  String validationFieldRequired(String fieldName) =>
      trWithParams('validation_field_required', [fieldName]);
  String get validationEmailRequired => tr('validation_email_required');
  String get validationEmailInvalid => tr('validation_email_invalid');
  String get validationPasswordRequired => tr('validation_password_required');
  String validationPasswordMinLength(int length) =>
      trWithParams('validation_password_min_length', [length.toString()]);
  String get validationPasswordUppercase => tr('validation_password_uppercase');
  String get validationPasswordLowercase => tr('validation_password_lowercase');
  String get validationPasswordNumber => tr('validation_password_number');
  String get validationPasswordSpecial => tr('validation_password_special');
  String get validationConfirmPasswordRequired =>
      tr('validation_confirm_password_required');
  String get validationPasswordsDoNotMatch =>
      tr('validation_passwords_do_not_match');
  String get validationPhoneRequired => tr('validation_phone_required');
  String get validationPhoneInvalid => tr('validation_phone_invalid');
  String validationMinLength(String fieldName, int length) =>
      trWithParams('validation_min_length', [fieldName, length.toString()]);
  String validationMaxLength(String fieldName, int length) =>
      trWithParams('validation_max_length', [fieldName, length.toString()]);
  String validationMustBeNumber(String fieldName) =>
      trWithParams('validation_must_be_number', [fieldName]);
  String get validationUrlRequired => tr('validation_url_required');
  String get validationUrlInvalid => tr('validation_url_invalid');
  String get validationCreditCardRequired =>
      tr('validation_credit_card_required');
  String get validationCreditCardInvalid =>
      tr('validation_credit_card_invalid');
  String get validationDateRequired => tr('validation_date_required');
  String get validationDateFormat => tr('validation_date_format');
  String get validationDateInvalid => tr('validation_date_invalid');
  String get validationMonthInvalid => tr('validation_month_invalid');
  String get validationDayInvalid => tr('validation_day_invalid');

  // Filter
  String get filter => tr('filter');
  String get priceRange => tr('price_range');
  String get from => tr('from');
  String get to => tr('to');
  String get clear => tr('clear');
  String get viewResult => tr('view_result');
  String get subCategories => tr('sub_categories');
  String get sortBy => tr('sort_by');
  String get latest => tr('latest');
  String get priceHighToLow => tr('price_high_to_low');
  String get priceLowToHigh => tr('price_low_to_high');
  String get highestRated => tr('highest_rated');
  String get mostViewed => tr('most_viewed');
  String get minRating => tr('min_rating');
  String get stars => tr('stars');

  // Add Product
  String get postAd => tr('post_ad');
  String get selectCategory => tr('select_category');
  String get category => tr('category');
  String get stock => tr('stock');
  String get enterStock => tr('enter_stock');
  String get addPhotos => tr('add_photos');
  String get addPhotosDescription => tr('add_photos_description');
  String get serviceDetails => tr('service_details');
  String get addPhoto => tr('add_photo');
  String get essentials => tr('essentials');
  String get adTitleEn => tr('ad_title_en');
  String get enterTitleEn => tr('enter_title_en');
  String get adTitleAr => tr('ad_title_ar');
  String get enterTitleAr => tr('enter_title_ar');
  String get adPrice => tr('ad_price');
  String get enterPrice => tr('enter_price');
  String get condition => tr('condition');
  String get usedCondition => tr('used_condition');
  String get refurbishedCondition => tr('refurbished_condition');
  String get descriptionEn => tr('description_en');
  String get describeYourItemEn => tr('describe_your_item_en');
  String get descriptionAr => tr('description_ar');
  String get describeYourItemAr => tr('describe_your_item_ar');
  String get selectLocation => tr('select_location');
  String get detailedAddress => tr('detailed_address');
  String get detailedAddressHint => tr('detailed_address_hint');
  String get contactSetting => tr('contact_setting');
  String get addSecondaryNumber => tr('add_secondary_number');
  String get choosePlan => tr('choose_plan');
  String get noPlansAvailable => tr('no_plans_available');
  String get adPreview => tr('ad_preview');
  String get photos => tr('photos');
  String get now => tr('now');
  String get noPrice => tr('no_price');
  String get noTitle => tr('no_title');
  String get popular => tr('popular');
  String get free => tr('free');
  String get daysActive => tr('days_active');
  String get month => tr('month');
  String get publishAndPay => tr('publish_and_pay');
  String get subscribe => tr('subscribe');
  String get planAndSubscription => tr('plan_and_subscription');
  String get back => tr('back');
  String get stepInfoMedia => tr('step_info_media');
  String get stepDetails => tr('step_details');
  String get stepReviewPay => tr('step_review_pay');
  String get productPublishedSuccessfully =>
      tr('product_published_successfully');
  String get adUnderReviewTitle => tr('ad_under_review_title');
  String get adUnderReviewBody => tr('ad_under_review_body');
  String get camera => tr('camera');
  String get gallery => tr('gallery');

  // Permission strings
  String get enableLocationAccess => tr('enable_location_access');
  String get enableCameraAccess => tr('enable_camera_access');
  String get enableMicrophoneAccess => tr('enable_microphone_access');
  String get enableNotificationAccess => tr('enable_notification_access');
  String get enableGpsAccess => tr('enable_gps_access');
  String get locationAccessDescription => tr('location_access_description');
  String get cameraAccessDescription => tr('camera_access_description');
  String get microphoneAccessDescription => tr('microphone_access_description');
  String get notificationAccessDescription =>
      tr('notification_access_description');
  String get gpsAccessDescription => tr('gps_access_description');
  String get openSettings => tr('open_settings');
  String permissionsPermanentlyDenied(String permission) =>
      trWithParams('permissions_permanently_denied', [permission]);
  String errorRequestingCameraPermission(String error) =>
      trWithParams('error_requesting_camera_permission', [error]);
  String get locationPerimissionDesc => tr('location_permission_desc');
  String get cameraPerimissionDesc => tr('camera_permission_desc');
  String get microphonePerimissionDesc => tr('microphone_permission_desc');
  String get notificationPerimissionDesc => tr('notification_permission_desc');
  String get gpsPerimissionDesc => tr('gps_permission_desc');
  String get uploadImage => tr('upload_image');
  String get imageType => tr('image_type');

  // Add Service
  String get addService => tr('add_service');
  String get nameInEnglish => tr('name_in_english');
  String get enterNameInEnglish => tr('enter_name_in_english');
  String get nameInArabic => tr('name_in_arabic');
  String get enterNameInArabic => tr('enter_name_in_arabic');
  String get phone => tr('phone');
  String get enterPhoneNumber => tr('enter_phone_number');
  String get enterWhatsappNumber => tr('enter_whatsapp_number');
  String get photo => tr('photo');
  String get success => tr('success');
  String get errorOccurred => tr('error_occurred');

  // Category Attributes
  String get selectDate => tr('select_date');
  String get uploadFile => tr('upload_file');
  String get noFileSelected => tr('no_file_selected');
  String get tapToSelectDate => tr('tap_to_select_date');
  String get tapToUploadFile => tr('tap_to_upload_file');
  String get categoryAttributes => tr('category_attributes');
  String get loadingAttributes => tr('loading_attributes');
  String get requiredField => tr('required_field');

  // Profile Screen
  String get heyThere => tr('hey_there');
  String get loginOrSignupPrompt => tr('login_or_signup_prompt');
  String get myListing => tr('my_listing');
  String get myAds => tr('my_ads');
  String get activity => tr('activity');
  String get recentViewed => tr('recent_viewed');
  String get savedSearch => tr('saved_search');
  String get settings => tr('settings');
  String get language => tr('language');
  String get darkMode => tr('dark_mode');
  String get agent => tr('agent');
  String get blogs => tr('blogs');
  String get termsAndConditions => tr('terms_and_conditions');
  String get aboutUs => tr('about_us');
  String get logout => tr('logout');
  String get followUs => tr('follow_us');
  String get logoutConfirmation => tr('logout_confirmation');
  String get cancel => tr('cancel');
  String get supportHelp => tr('support_help');
  String get appSupport => tr('app_support');

  // Contact Us & FAQ
  String get frequentlyAskedQuestions => tr('frequently_asked_questions');
  String get contactUs => tr('contact_us');
  String get subject => tr('subject');
  String get subjectHint => tr('subject_hint');
  String get messageHint => tr('message_hint');
  String get faqQuestion1 => tr('faq_question_1');
  String get faqQuestion2 => tr('faq_question_2');
  String get faqQuestion3 => tr('faq_question_3');
  String get faqQuestion4 => tr('faq_question_4');
  String get faqQuestion5 => tr('faq_question_5');
  String get faqAnswer3 => tr('faq_answer_3');
  String get noTermsAndConditions => tr('no_terms_and_conditions');
  String get noTermsAndConditionsDescription =>
      tr('no_terms_and_conditions_description');
  String get noFqa => tr('no_fqa');
  String get noFqaDescription => tr('no_fqa_description');

  // Agents Support
  String get agentsSupport => tr('agents_support');
  String get noAgentsAvailable => tr('no_agents_available');
  String get loadingAgents => tr('loading_agents');
  String get alMasayel => tr('al_masayel');
  String get noRecentlyViewedProducts => tr('no_recently_viewed_products');
  String get recentlyViewedProductsDescription =>
      tr('recently_viewed_products_description');

  String get byTheNumbers => tr('by_the_numbers');
  String get whoWeAre => tr('who_we_are');
  String get ourVision => tr('our_vision');
  String get ourMission => tr('our_mission');
  String get userCount => tr('user_count');
  String get adsCount => tr('ads_count');
  String starsOutOf5(int rating) =>
      trWithParams('stars_out_of_5', [rating.toString()]);

  String get itemWillBeRemovedAfterTwoWeeks =>
      tr('item_will_be_removed_after_two_weeks');
  String get keyWord => tr('key_word');
  String get chooseCategory => tr('choose_category');
  String get chooseLocation => tr('choose_location');
  String get enterKeyWord => tr('enter_key_word');
  String get addNewItem => tr('add_new_item');
  String get pleaseWaitUntilDataIsLoaded =>
      tr('please_wait_until_data_is_loaded');
  String get expiredDate => tr('expired_date');
  String get noItemsAddedFound => tr('no_items_added_found');
  String get saveYourFavoriteSearchesToFindThemQuicklyAnytime =>
      tr('save_your_favorite_searches_to_find_them_quickly_anytime');

  // Report Ad
  String get reportSubmitted => tr('reportSubmitted');
  String get reason => tr('reason');
  String get selectReason => tr('selectReason');
  String get details => tr('details');
  String get enterDetails => tr('enterDetails');
  String get fieldRequired => tr('fieldRequired');
  String get pleaseSelectReason => tr('please_select_reason');
  String get suspiciousListing => tr('suspicious_listing');
  String get offensiveContent => tr('offensive_content');
  String get irrelevantContent => tr('irrelevant_content');
  String get fraudulent => tr('fraudulent');
  String get other => tr('other');
  String get reported => tr('reported');

  List<String> get reasons => [
    suspiciousListing,
    offensiveContent,
    irrelevantContent,
    fraudulent,
    other,
  ];

  String get unlimited => tr('unlimited');

  // Rating Feature
  String get addYourFeedback => tr('add_your_feedback');
  String get yourRating => tr('your_rating');
  String get feedbackPlaceholder => tr('feedback_placeholder');
  String get ratingSubmittedSuccess => tr('rating_submitted_success');
  String get ratingSubmittedError => tr('rating_submitted_error');

  // Search Screen
  String get pinnedAds => tr('pinned_ads');
  String get specialOffers => tr('special_offers');
  String get discoverAmazingDeals => tr('discover_amazing_deals');
  String get browseNow => tr('browse_now');
  String get trending => tr('trending');
  String get adsFound => tr('ads_found');
  String get noResultsFound => tr('no_results_found');

  // Product Details
  String get youMightAlsoLike => tr('you_might_also_like');
  String get checkProfile => tr('check_profile');
  String get follow => tr('follow');
  String get unfollow => tr('unfollow');

  // Image Helper
  String get savedToGallery => tr('saved_to_gallery');
  String get failedToSaveImage => tr('failed_to_save_image');
  String get errorSavingImage => tr('error_saving_image');
  String get permissionDeniedToSaveImageToGallery =>
      tr('permission_denied_to_save_image_to_gallery');

  String get noProductsFound => tr('no_products_found');

  String get nothingNewToSeeHere => tr('nothing_new_to_see_here');
  String get allCaughtUp => tr('all_caught_up');

  String get goToHome => tr('go_to_home');

  String get noMatchesFound => tr('no_matches_found');
  String get clearFilter => tr('clear_filter');
  String get clearFilterButton => tr('clear_filter_button');
}
