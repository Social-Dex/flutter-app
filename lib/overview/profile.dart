import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/overview/user_avatar.dart';
import 'package:app/services/user_data.dart';
import 'package:app/overview/avatar_customizer.dart';

class ProfileScreen extends StatefulWidget {
  final UserData userData;

  const ProfileScreen({
    super.key,
    required this.userData,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _onAvatarPress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AvatarCustomizerScreen(_onCustomizerNavBack)));
  }

  void _onCustomizerNavBack() {
    setState(() {
      widget.userData.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 30),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: const Icon(Icons.settings),
              ),
              const Spacer(),
              const Spacer(),
              UserAvatar(
                svg: '',
                backgroundColor: Theme.of(context).canvasColor,
                statusColor: widget.userData.statusColor,
                onPress: _onAvatarPress,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userData.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  Row(
                    children: [
                      Text(widget.userData.age.toString()),
                      Icon(widget.userData.genderIcon),
                      widget.userData.genderIcon == Icons.transgender
                          ? Text(widget.userData.gender)
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ProfileDisplayValue(
                  label: AppLocalizations.of(context)!.occupation,
                  value: widget.userData.occupation,
                ),
                ProfileDisplayValue(
                  label: AppLocalizations.of(context)!.sexuality,
                  value: 'Straight',
                ),
                ProfileDisplayValue(
                  label: AppLocalizations.of(context)!.relationshipStatus,
                  value: 'Single',
                ),
                ProfileDisplayValue(
                  label: AppLocalizations.of(context)!.biography,
                  value:
                      'Honestly not much ...\nI like "Mission Hail Marry" tho',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileDisplayValue extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDisplayValue({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.black26,
            ),
            child: Row(
              children: [
                Text(value),
                const Spacer(),
                const Icon(Icons.edit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
