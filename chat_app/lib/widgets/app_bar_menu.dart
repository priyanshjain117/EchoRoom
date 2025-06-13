import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white70,
        size: 28,
      ),
      onPressed: () async {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        final Offset offset = button.localToGlobal(
          Offset.zero,
          ancestor: overlay,
        );
        final RelativeRect position = RelativeRect.fromLTRB(
          offset.dx,
          offset.dy + 40, // Shift down from the icon
          overlay.size.width - offset.dx - 20,
          0,
        );

        final selectedItem = await showMenu<String>(
          context: context,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          position: position,
          initialValue: '',
          items: [
            PopupMenuItem(
              value: 'new_group',
              child: Text(
                'New Group',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        );

        if (selectedItem == 'new_group') {
          print('NewGroup');
        } else if (selectedItem == 'logout') {
          print('logout');
        } else {
          print('none');
        }
      },
    );
  }
}
