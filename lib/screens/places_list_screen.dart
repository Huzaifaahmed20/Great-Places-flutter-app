import 'package:flutter/material.dart';
import 'package:great_places/screens/place_detail_screen.dart';

import './add_places_screen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  void confirmDelete(BuildContext ctx, String id) {
    showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
              title: Text('Are you sure you want to delete?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Provider.of<GreatPlaces>(ctx, listen: false)
                        .deletePlace(id);
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            ),
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<GreatPlaces>(
                      child: Center(
                        child: Text('No places added yet, add some'),
                      ),
                      builder: (ctx, model, ch) => model.places.length <= 0
                          ? ch
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListView.builder(
                                itemCount: model.places.length,
                                itemBuilder: (ctx, i) => Card(
                                  borderOnForeground: true,
                                  elevation: 10,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          FileImage(model.places[i].image),
                                    ),
                                    title: Text(model.places[i].title),
                                    subtitle:
                                        Text(model.places[i].location.address),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => confirmDelete(
                                          context, model.places[i].id),
                                    ),
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(PlaceDetailsScreen.routeName,
                                            arguments: model.places[i].id),
                                  ),
                                ),
                              ),
                            ),
                    ),
        ));
  }
}
