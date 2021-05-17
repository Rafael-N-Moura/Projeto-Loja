import 'package:flutter/material.dart';
import 'package:projeto_budega/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  @override
  DrawerTile({this.title, this.iconData, this.page});

  final String title;
  final IconData iconData;
  final int page;

  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;
    final Color primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Icon(
                iconData,
                size: 32,
                color: curPage == page ? primaryColor : Colors.grey[700],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: curPage == page ? primaryColor : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
