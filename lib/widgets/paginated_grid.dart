import 'package:flutter/material.dart';

class PaginatedGrid<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;

  const PaginatedGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.0,
  });

  @override
  PaginatedGridState<T> createState() => PaginatedGridState<T>();
}

class PaginatedGridState<T> extends State<PaginatedGrid<T>> {
  int _currentPage = 0;
  late int _pageCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculatePageCount();
  }

  @override
  void didUpdateWidget(PaginatedGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      _calculatePageCount();
      if (_currentPage >= _pageCount) {
        _currentPage = _pageCount - 1;
        if (_currentPage < 0) {
          _currentPage = 0;
        }
      }
    }
  }

  void _calculatePageCount() {
    final itemsPerPage = widget.crossAxisCount * 2;
    _pageCount = (widget.items.length / itemsPerPage).ceil();
  }

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsPerPage = widget.crossAxisCount * 2;
    final startIndex = _currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage > widget.items.length)
        ? widget.items.length
        : startIndex + itemsPerPage;
    final currentItems = widget.items.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemCount: currentItems.length,
            itemBuilder: (context, index) => widget.itemBuilder(currentItems[index]),
          ),
        ),
        if (_pageCount > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _currentPage > 0 ? _previousPage : null,
              ),
              Text('${_currentPage + 1} / $_pageCount'),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _currentPage < _pageCount - 1 ? _nextPage : null,
              ),
            ],
          ),
      ],
    );
  }
}
