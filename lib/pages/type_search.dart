import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/states/final_disposition_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/widgets/type_search/type_search_results.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeSearch extends StatefulWidget {
  TypeSearch();

  @override
  State<StatefulWidget> createState() => TypeSearchState();
}

class TypeSearchState extends State<TypeSearch> {
  final _searchController = TextEditingController();

  TypeSearchState();

  List<FinalDisposition> searchResults = [];

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Future<List<FinalDisposition>> search(String query) async {
      final finalDispositionEditCubit = context.watch<FinalDispositionCubit>();
      return finalDispositionEditCubit.state
          .ifState<FinalDispositionStateLoaded>(
        withState: (state) async {
          Iterable<FinalDisposition> filtered = state.dispositions.where((l) {
            return l.isActive &&
                l.type.toLowerCase().contains(query.toLowerCase());
          });

          return filtered.toList(growable: false);
        },
        orElse: (state) => <FinalDisposition>[],
      );
    }

    final newResults = () async {
      final results = await search(_searchController.text);
      if (mounted) {
        setState(() {
          searchResults = results;
        });
      }
    };

    _searchController.addListener(newResults);

    Widget searchField() {
      return TextFormField(
        maxLines: null,
        controller: _searchController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: localizations!.translate("typeSearchSearchFieldHint"),
          border: InputBorder.none,
        ),
        autofocus: true,
      );
    }

    Widget clearSearchFieldButton() {
      return IconButton(
        splashRadius: 1,
        icon: Icon(Icons.clear),
        onPressed: () {
          _searchController.text = "";
        },
        tooltip:
            DccLocalizations.of(context)!.translate("typeSearchClearTooltip"),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: searchField(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                clearSearchFieldButton(),
              ],
            ),
          )
        ],
      ),
      body: TypeSearchResults(
        results: searchResults,
        onSelection: (t) => navigator.pop(t),
      ),
    );
  }
}
