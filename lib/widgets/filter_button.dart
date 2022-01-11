import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  List<String> data;
  List<String>? selected;
  Function filterResults;

  FilterButton(
      {Key? key,
      required this.data,
      required this.selected,
      required this.filterResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _openFilterDialog() async {
      await FilterListDialog.display<String>(context,
          listData: data,
          selectedListData: selected,
          height: 480,
          headlineText: "Select launch",
          searchFieldHintText: "Search Here", choiceChipLabel: (item) {
        return item;
      }, validateSelectedItem: (list, val) {
        return list!.contains(val);
      }, onItemSearch: (list, text) {
        if (list!.any(
            (element) => element.toLowerCase().contains(text.toLowerCase()))) {
          return list
              .where((element) =>
                  element.toLowerCase().contains(text.toLowerCase()))
              .toList();
        } else {
          return [];
        }
      }, onApplyButtonClick: (list) {
        if (list != null) {
          selected = List.from(list);
        }
        if (list!.isEmpty) {
          selected = [];
        }
        filterResults(selected);

        Navigator.pop(context);
      });
    }

    return Container(
      child: IconButton(
        icon: const Icon(Icons.search),
        onPressed: _openFilterDialog,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).primaryColor,
      ),
      width: 50,
      height: 50,
    );
  }
}
