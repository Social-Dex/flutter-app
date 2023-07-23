import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/services/models.dart';
import 'package:app/overview/user_avatar.dart';
import 'package:app/overview/profile_display_value.dart';
import 'package:app/services/user_data.dart';
import 'package:age_calculator/age_calculator.dart';

class UserView extends StatelessWidget {
  final String userId;
  final String avatarSVG;
  final Color statusColor;
  final UserProfile userProfile;
  final UserData userData;

  const UserView({
    super.key,
    required this.userId,
    required this.avatarSVG,
    required this.statusColor,
    required this.userProfile,
    required this.userData,
  });

  String getAge(String date) {
    SimpleDate simpleBday = SimpleDate.fromString(date: date);
    DateTime bDay = DateTime(simpleBday.year, simpleBday.month, simpleBday.day);
    DateDuration duration = AgeCalculator.age(bDay);

    return duration.years.toString();
  }

  IconData getGenderIcon(String gender) {
    switch (gender) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      default:
        return Icons.transgender;
    }
  }

  String getGenderText(BuildContext context, String gender) {
    switch (gender) {
      case 'male':
        return AppLocalizations.of(context)!.male;
      case 'female':
        return AppLocalizations.of(context)!.female;
    }

    return gender;
  }

  String getRelationshipText(BuildContext context, bool? isInRelationship) {
    if (isInRelationship == true) {
      return AppLocalizations.of(context)!.relationshipStatusTaken;
    }
    if (isInRelationship == false) {
      return AppLocalizations.of(context)!.relationshipStatusSingle;
    }

    return AppLocalizations.of(context)!.preferNotToAnswer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 60, top: 35),
            child: Row(
              children: [
                const Spacer(),
                const Spacer(),
                UserAvatar(
                  heroTag: 'avatar-$userId',
                  svg: avatarSVG,
                  statusColor: statusColor,
                  onPress: () {},
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userProfile.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    Row(
                      children: [
                        Text(getAge(userProfile.birthday)),
                        Icon(getGenderIcon(userProfile.gender)),
                        getGenderIcon(userProfile.gender) == Icons.transgender
                            ? Text(getGenderText(context, userProfile.gender))
                            : Container(),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  userProfile.occupation != ''
                      ? ProfileDisplayValue(
                          label: AppLocalizations.of(context)!.occupation,
                          value: userProfile.occupation,
                          onTap: () {},
                        )
                      : Container(),
                  userData.isInRelationship != null &&
                          userProfile.isInRelationship != null
                      ? ProfileDisplayValue(
                          label:
                              AppLocalizations.of(context)!.relationshipStatus,
                          value: getRelationshipText(
                              context, userProfile.isInRelationship),
                          onTap: () {},
                        )
                      : Container(),
                  userProfile.bio != ''
                      ? ProfileDisplayValue(
                          label: AppLocalizations.of(context)!.biography,
                          value: userProfile.bio,
                          onTap: () {},
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
