import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/overview/user_avatar.dart';
import 'package:app/services/firestore.dart';
import 'package:app/services/user_data.dart';
import 'package:app/overview/avatar_customizer.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:app/overview/edit_profile_value.dart';
import 'package:app/overview/profile_display_value.dart';

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
  FocusNode fOccupation = FocusNode();
  TextEditingController cOccupation = TextEditingController();
  String occupation = '';

  bool showEditRelationshipStatus = false;
  FocusNode fRelationshipStatus = FocusNode();
  bool? isInRelationship;

  bool showEditBio = false;
  FocusNode fBio = FocusNode();
  TextEditingController cBio = TextEditingController();
  String bio = '';

  @override
  initState() {
    super.initState();

    cOccupation.addListener(() {
      occupation = cOccupation.text;
    });
    cBio.addListener(() {
      bio = cBio.text;
    });
  }

  @override
  void dispose() {
    super.dispose();

    cOccupation.dispose();
    cBio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60, top: 35),
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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ProfileDisplayValue(
                      editable: true,
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
                      editable: true,
                      label: AppLocalizations.of(context)!.relationshipStatus,
                      value: widget.userData.relationshipStatus,
                      onTap: () {
                        setState(() {
                          showEditRelationshipStatus = true;
                          fRelationshipStatus.requestFocus();
                        });
                      },
                    ),
                    ProfileDisplayValue(
                      editable: true,
                      label: AppLocalizations.of(context)!.biography,
                      value: widget.userData.bio,
                      onTap: () {
                        setState(() {
                          showEditBio = true;
                          cBio.text = widget.userData.bio;
                          fBio.requestFocus();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        showEditOccupation
            ? EditProfileValue(
                onExit: () {
                  setState(() {
                    showEditOccupation = false;
                  });
                },
                onSubmit: () {
                  if (occupation == widget.userData.occupation) {
                    setState(() {
                      showEditOccupation = false;
                    });
                    return;
                  }

                  context.loaderOverlay.show();

                  widget.userData.profile.occupation = occupation;

                  FirestoreService()
                      .updateUserProfile(widget.userData.profile)
                      .then((_) {
                    setState(() {
                      showEditOccupation = false;
                      context.loaderOverlay.hide();
                    });
                  });
                },
                widget: EditOccupation(
                  controller: cOccupation,
                  focusNode: fOccupation,
                ),
              )
            : Container(),
        showEditRelationshipStatus
            ? EditProfileValue(
                onExit: () {
                  setState(() {
                    showEditRelationshipStatus = false;
                  });
                },
                onSubmit: () {
                  if (isInRelationship ==
                      widget.userData.profile.isInRelationship) {
                    setState(() {
                      showEditRelationshipStatus = false;
                    });
                    return;
                  }

                  context.loaderOverlay.show();

                  widget.userData.profile.isInRelationship = isInRelationship;

                  FirestoreService()
                      .updateUserProfile(widget.userData.profile)
                      .then((_) {
                    setState(() {
                      showEditRelationshipStatus = false;
                      context.loaderOverlay.hide();
                    });
                  });
                },
                widget: EditRelationshipStatus(
                  initValue: widget.userData.profile.isInRelationship,
                  focusNode: fRelationshipStatus,
                  onChanged: (isIR) {
                    isInRelationship = isIR;
                  },
                ),
              )
            : Container(),
        showEditBio
            ? EditProfileValue(
                onExit: () {
                  setState(() {
                    showEditBio = false;
                  });
                },
                onSubmit: () {
                  if (bio == widget.userData.bio) {
                    setState(() {
                      showEditBio = false;
                    });
                    return;
                  }

                  context.loaderOverlay.show();

                  widget.userData.profile.bio = bio;

                  FirestoreService()
                      .updateUserProfile(widget.userData.profile)
                      .then((_) {
                    setState(() {
                      showEditBio = false;
                      context.loaderOverlay.hide();
                    });
                  });
                },
                widget: EditBio(
                  controller: cBio,
                  focusNode: fBio,
                ),
              )
            : Container(),
      ],
    );
  }
}

class EditOccupation extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const EditOccupation({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.occupation,
      ),
      textCapitalization: TextCapitalization.words,
      maxLength: 30,
      maxLines: 1,
      controller: controller,
      focusNode: focusNode,
    );
  }
}

class EditRelationshipStatus extends StatelessWidget {
  final bool? initValue;
  final FocusNode focusNode;
  final Function(bool?) onChanged;

  const EditRelationshipStatus({
    super.key,
    required this.initValue,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.relationshipStatus,
      ),
      value: initValue,
      focusNode: focusNode,
      items: [
        DropdownMenuItem(
          value: true,
          child: Text(AppLocalizations.of(context)!.relationshipStatusTaken),
        ),
        DropdownMenuItem(
          value: false,
          child: Text(AppLocalizations.of(context)!.relationshipStatusSingle),
        ),
        DropdownMenuItem(
          value: null,
          child: Text(AppLocalizations.of(context)!.preferNotToAnswer),
        ),
      ],
      onChanged: (isInRelationship) {
        onChanged(isInRelationship);
      },
    );
  }
}

class EditBio extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const EditBio({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.biography,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: controller,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
