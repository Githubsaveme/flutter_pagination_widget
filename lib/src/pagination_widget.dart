import 'package:flutter/material.dart';
import 'package:flutter_pagination_widget/src/pagination_model.dart';

class PaginationWidget extends StatelessWidget {
  final PaginationModel meta;
  final ValueChanged<int> onPageChanged;
  final Color primaryColor;
  final Color textColor;
  final double buttonPadding;
  final TextStyle? textStyle;

  const PaginationWidget({
    super.key,
    required this.meta,
    required this.onPageChanged,
    this.primaryColor = Colors.blue,
    this.textColor = Colors.black87,
    this.buttonPadding = 8.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final int startEntry = meta.from;
    final int endEntry = meta.to;
    final int totalEntries = meta.total;
    final int currentPage = meta.currentPage;
    final int totalPages = meta.lastPage;

    final double textScale = MediaQuery.of(context).textScaleFactor;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Base size on width but clamp between reasonable values
        double baseScale = (constraints.maxWidth / 400).clamp(0.8, 1.4);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10 * baseScale),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Showing $startEntry to $endEntry of $totalEntries entries',
                  overflow: TextOverflow.ellipsis,
                  style: textStyle ??
                      TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 14 * baseScale * textScale,
                      ),
                ),
              ),
              Row(
                children: [
                  _buildPaginationButton(
                    context,
                    text: 'Previous',
                    isEnabled: currentPage > 1,
                    onTap: () => onPageChanged(currentPage - 1),
                    scale: baseScale,
                    textScale: textScale,
                  ),
                  ..._buildPageButtons(context, currentPage, totalPages, baseScale, textScale, constraints.maxWidth),
                  _buildPaginationButton(
                    context,
                    text: 'Next',
                    isEnabled: currentPage < totalPages,
                    onTap: () => onPageChanged(currentPage + 1),
                    scale: baseScale,
                    textScale: textScale,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPageButtons(
      BuildContext context,
      int currentPage,
      int totalPages,
      double scale,
      double textScale,
      double availableWidth) {
    const int visibleRange = 1;
    List<Widget> buttons = [];

    void addPage(int page) {
      buttons.add(_buildPaginationButton(
        context,
        text: '$page',
        isSelected: page == currentPage,
        onTap: () => onPageChanged(page),
        scale: scale,
        textScale: textScale,
      ));
    }

    void addEllipsis() {
      buttons.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 4 * scale),
        child: Text('...', style: textStyle),
      ));
    }

    // If space is tight, show fewer pages
    bool compact = availableWidth < 320;

    if (totalPages <= (compact ? 5 : 7)) {
      for (int i = 1; i <= totalPages; i++) addPage(i);
    } else {
      addPage(1);
      if (currentPage > visibleRange + 2) addEllipsis();
      int start = (currentPage - visibleRange).clamp(2, totalPages - 1);
      int end = (currentPage + visibleRange).clamp(2, totalPages - 1);
      for (int i = start; i <= end; i++) addPage(i);
      if (currentPage < totalPages - (visibleRange + 1)) addEllipsis();
      addPage(totalPages);
    }
    return buttons;
  }

  Widget _buildPaginationButton(
      BuildContext context, {
        required String text,
        bool isSelected = false,
        bool isEnabled = true,
        required VoidCallback onTap,
        double scale = 1.0,
        double textScale = 1.0,
      }) {
    final Color backgroundColor =
    isSelected ? primaryColor : (isEnabled ? Colors.grey.shade200 : Colors.grey.shade100);
    final Color fgColor = isSelected ? Colors.white : (isEnabled ? textColor : Colors.grey.shade400);

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(4.0 * scale),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2 * scale),
        padding: EdgeInsets.symmetric(
          horizontal: 10 * scale,
          vertical: buttonPadding * (scale * 0.9),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.0 * scale),
          border: Border.all(color: isEnabled ? Colors.grey.shade300 : Colors.grey.shade200),
        ),
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                color: fgColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12 * scale * textScale,
              ),
        ),
      ),
    );
  }
}
