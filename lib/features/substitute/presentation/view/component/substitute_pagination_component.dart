import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/pagination/compact_paginator.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_tactical_board/app/manager/values_manager.dart';

class SubstitutePaginationComponent extends StatefulWidget {
  const SubstitutePaginationComponent({
    super.key,
    required this.total,
    required this.onSubChange,
  });

  final int total;
  final Function(int) onSubChange;

  @override
  State<SubstitutePaginationComponent> createState() =>
      _SubstitutePaginationComponentState();
}

class _SubstitutePaginationComponentState
    extends State<SubstitutePaginationComponent>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MatchBloc>().add(MatchUpdateEvent());
  }

  _callOnSubChange() {
    widget.onSubChange.call(_selectedIndex);
  }

  _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: [
          Text(
            "Substitutes",
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: ColorManager.grey),
          ),
          CompactPaginator(
            initialPage: _selectedIndex,
            maxPagesToShow: 10,
            config: CompactPaginatorUiConfig(
              navButtonPadding: EdgeInsets.zero,
              pageNumberPadding: EdgeInsets.zero,
              navIconSize: AppSize.s32,
              pageNumberFontSize: AppSize.s18,
            ),
            totalPages: (widget.total),
            onPageChanged: (int index) {
              _updateIndex(index);
              _callOnSubChange();
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
