import 'package:flutter/material.dart';

class ProfileDisplayValue extends StatelessWidget {
  final bool editable;
  final String label;
  final String value;
  final Function onTap;

  const ProfileDisplayValue({
    super.key,
    this.editable = false,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: editable ? 5 : 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.black26,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                ),
                editable
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        splashColor: Colors.deepPurple,
                        onPressed: () {
                          onTap();
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
