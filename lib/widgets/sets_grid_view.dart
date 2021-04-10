import 'package:brick_app/model/set_or_moc.dart';
import 'package:brick_app/pages/moc_page.dart';
import 'package:brick_app/pages/set_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = void Function(dynamic);

class SetsGridView extends StatelessWidget {
  final List<SetOrMoc> sets;
  final bool withButtons;

  SetsGridView(this.sets, {this.withButtons = false});

  Widget build(BuildContext context) {
    return _createSetsView(context);
  }

  Widget _createSetsView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          GridView.builder(
            itemCount: sets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount:
                    MediaQuery.of(context).size.width > 768 ? 3 : 2),
            itemBuilder: (context, index) => _buildTile(
              context,
              sets[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, set) {
    return DecoratedBox(
      key: ObjectKey('tile_${set.setNum}'),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: withButtons ? 8 : 1,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Image.network(set.imgUrl),
            ),
          ),
          withButtons ? _createButtons(context, set) : Container(),
        ],
      ),
    );
  }

  Widget _createButtons(BuildContext context, set) => Expanded(
        flex: 2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createButton(
                context,
                Icons.menu_book,
                MaterialPageRoute(
                  settings: RouteSettings(name: 'setRoute'),
                  builder: (context) => MocPage(set),
                ),
              ),
              _createDivider(),
              _createButton(
                context,
                Icons.star,
                MaterialPageRoute(
                  settings: RouteSettings(name: 'mocsRoute'),
                  builder: (context) => MocPage(set),
                ),
              ),
              _createDivider(),
              _createButton(
                context,
                Icons.grain,
                MaterialPageRoute(
                  settings: RouteSettings(name: 'partsRoute'),
                  builder: (context) => MocPage(set),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _createButton(
          BuildContext context, IconData iconData, MaterialPageRoute route) =>
      Expanded(
        flex: 4,
        child: IconButton(
          icon: Icon(iconData, color: Colors.white),
          onPressed: () => Navigator.of(context).push(route),
        ),
      );

  Widget _createDivider() => Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: VerticalDivider(
            color: Colors.white,
          ),
        ),
      );
}
