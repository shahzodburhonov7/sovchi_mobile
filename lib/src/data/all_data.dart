import 'package:easy_localization/easy_localization.dart';
import 'package:sovchilar/translations/locale_keys.g.dart';


String getNationalityTranslation(String nationalityKey) {
  switch (nationalityKey) {
    case "ALL":
      return LocaleKeys.auth_FormTwo_selectNationality_select.tr();
    case "Uzbek":
      return LocaleKeys.auth_FormTwo_selectNationality_Uzbek.tr();
    case "Russian":
      return LocaleKeys.auth_FormTwo_selectNationality_Russian.tr();
    case "Kazakh":
      return LocaleKeys.auth_FormTwo_selectNationality_Kazakh.tr();
    case "Kyrgyz":
      return LocaleKeys.auth_FormTwo_selectNationality_Kyrgyz.tr();
    case "Tajik":
      return LocaleKeys.auth_FormTwo_selectNationality_Tajik.tr();
    case "Turkmen":
      return LocaleKeys.auth_FormTwo_selectNationality_Turkmen.tr();
    case "Tatar":
      return LocaleKeys.auth_FormTwo_selectNationality_Tatar.tr();
    case "Karakalpak":
      return LocaleKeys.auth_FormTwo_selectNationality_Karakalpak.tr();
    case "Other":
      return LocaleKeys.auth_FormTwo_selectNationality_Other.tr();
    default:
      return "Unknown nationality"; // Default qiymat
  }
}

String getGenderTranslation(String genderKey) {
  switch (genderKey) {
    case 'MALE':
      return LocaleKeys.auth_CombinedForm_genderMale.tr();
    case 'FEMALE':
      return LocaleKeys.auth_CombinedForm_genderFemale.tr();
    default:
      return "Unknown gender";
  }
}
String getAddressTranslation(String cityKey) {
  switch (cityKey) {
    case 'BARCHA SHAHARLAR':
      return LocaleKeys.auth_FormOne_selectCity_select.tr();
    case 'TOSHKENT':
      return LocaleKeys.auth_FormOne_selectCity_Toshkent.tr();
    case 'ANDIJON':
      return LocaleKeys.auth_FormOne_selectCity_Andijon.tr();
    case 'BUXORO':
      return LocaleKeys.auth_FormOne_selectCity_Buxoro.tr();
    case 'FARGONA':
      return LocaleKeys.auth_FormOne_selectCity_Fargona.tr();
    case 'JIZZAX':
      return LocaleKeys.auth_FormOne_selectCity_Jizzax.tr();
    case 'XORAZM':
      return LocaleKeys.auth_FormOne_selectCity_Xorazm.tr();
    case 'NAMANGAN':
      return LocaleKeys.auth_FormOne_selectCity_Namangan.tr();
    case 'NAVOIY':
      return LocaleKeys.auth_FormOne_selectCity_Navoiy.tr();
    case 'QASHQADARYO':
      return LocaleKeys.auth_FormOne_selectCity_Qashqadaryo.tr();
    case 'SAMARQAND':
      return LocaleKeys.auth_FormOne_selectCity_Samarqand.tr();
    case 'SIRDARYO':
      return LocaleKeys.auth_FormOne_selectCity_Sirdaryo.tr();
    case 'SURXONDARYO':
      return LocaleKeys.auth_FormOne_selectCity_Surxondaryo.tr();
    case 'QORAQALPOGISTON':
      return LocaleKeys.auth_FormOne_selectCity_Qoraqalpogiston.tr();
    default:
      return "Unknown city";
  }
}

String getMartialStatusFemaleTranslation(String statusKey) {
  switch (statusKey) {
    case "ALL":
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_female_all.tr();
    case 'SINGLE':
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_female_single.tr();
    case 'DIVORCED':
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_female_divorced.tr();
    case 'MARRIED_SECOND':
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_female_widowed.tr();
    default:
      return "Unknown marital status";
  }
}
String getMartialStatusMaleTranslation(String statusKey) {
  switch (statusKey) {
    case "ALL":
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_male_all.tr();
    case 'SINGLE':
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_male_single.tr();
    case 'DIVORCED':
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_male_divorced.tr();
    case 'MARRIED_SECOND':
      return LocaleKeys.home_SecondHomePageSearch_form_maritalStatus_male_widowed.tr();
    default:
      return "Unknown marital status";
  }
}
String getStatusTranslation(String statusKey) {
  switch (statusKey) {
    case 'ACTIVE':
      return LocaleKeys.UserDetails_active.tr();
    case 'INACTIVE':
      return LocaleKeys.UserDetails_inactive.tr();
    case 'DONE':
      return LocaleKeys.UserDetails_inactive.tr(); // Or return DONE translation
    case 'PENDING':
      return LocaleKeys.UserDetails_inactive.tr(); // Or return PENDING translation
    default:
      return "Unknown status";
  }
}
String getDegreeTranslation(String degreeKey) {
  switch (degreeKey) {
    case "all":
      return LocaleKeys.auth_FormTwo_selectEducation.tr();
    case "middle":
      return LocaleKeys.userCard_qualification_middle.tr();
    case "specialized":
      return LocaleKeys.userCard_qualification_specialized.tr();
    case "incompleteHigher":
      return LocaleKeys.userCard_qualification_incompleteHigher.tr();
    case "higher":
      return LocaleKeys.userCard_qualification_higher.tr();
    case "master":
      return LocaleKeys.userCard_qualification_master.tr();
    case "doctorate":
      return LocaleKeys.userCard_qualification_doctorate.tr();
    default:
      return "Unknown degree";
  }
}
