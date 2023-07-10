import 'package:app/services/firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/overview/user_avatar.dart';
import 'package:app/services/user_data.dart';
import 'package:app/overview/avatar_customizer.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
                AvatarCustomizerScreen(widget.userData.profile)));
  }

  bool showEditOccupation = false;
  TextEditingController cOccupation = TextEditingController();
  FocusNode fOccupation = FocusNode();

  bool showEditRelationshipStatus = false;

  bool showEditBio = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                      onTap: () {
                        setState(() {
                          showEditOccupation = true;
                          cOccupation.text = widget.userData.occupation;
                          fOccupation.requestFocus();
                        });
                      },
                    ),
                    ProfileDisplayValue(
                      label: AppLocalizations.of(context)!.relationshipStatus,
                      value: widget.userData.relationshipStatus,
                      onTap: () {},
                    ),
                    ProfileDisplayValue(
                      label: AppLocalizations.of(context)!.biography,
                      value: widget.userData.bio,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        showEditOccupation
            ? EditOccupation(
                cOccupation: cOccupation,
                fOccupation: fOccupation,
                onTapOutside: () {
                  setState(() {
                    showEditOccupation = false;
                  });
                },
                onSubmit: (value) {
                  context.loaderOverlay.show();

                  widget.userData.profile.occupation = value;

                  FirestoreService()
                      .updateUserProfile(widget.userData.profile)
                      .then((value) {
                    setState(() {
                      showEditOccupation = false;
                      context.loaderOverlay.hide();
                    });
                  });
                },
              )
            : Container(),
      ],
    );
  }
}

class ProfileDisplayValue extends StatelessWidget {
  final String label;
  final String value;
  final Function onTap;

  const ProfileDisplayValue({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
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
                IconButton(
                  icon: const Icon(Icons.edit),
                  splashColor: Colors.deepPurple,
                  onPressed: () {
                    onTap();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditOccupation extends StatelessWidget {
  final TextEditingController cOccupation;
  final FocusNode fOccupation;
  final Function onTapOutside;
  final Function onSubmit;

  const EditOccupation({
    super.key,
    required this.cOccupation,
    required this.fOccupation,
    required this.onTapOutside,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 29,
        bottom: MediaQuery.of(context).size.height * 0.25,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: const <BoxShadow>[BoxShadow(blurRadius: 2)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.occupation,
            ),
            textCapitalization: TextCapitalization.words,
            maxLength: 20,
            maxLines: 1,
            controller: cOccupation,
            focusNode: fOccupation,
            onTapOutside: (event) {
              onTapOutside();
            },
            onFieldSubmitted: (value) {
              onSubmit(value);
            },
          ),
        ),
      ),
    );
  }
}
