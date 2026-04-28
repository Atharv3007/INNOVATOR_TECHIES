import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class VitalCard extends StatefulWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final LinearGradient gradient;
  final bool isLoading;
  final double? currentValue;
  final double? warningThreshold;
  final double? dangerThreshold;
  final bool belowThresholdIsDanger;

  const VitalCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.gradient,
    this.isLoading = false,
    this.currentValue,
    this.warningThreshold,
    this.dangerThreshold,
    this.belowThresholdIsDanger = false,
  });

  @override
  State<VitalCard> createState() => _VitalCardState();
}

class _VitalCardState extends State<VitalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isWarning {
    if (widget.currentValue == null || widget.warningThreshold == null) {
      return false;
    }
    return widget.currentValue! >= widget.warningThreshold!;
  }

  bool get _isDanger {
    if (widget.currentValue == null || widget.dangerThreshold == null) {
      return false;
    }
    if (widget.belowThresholdIsDanger) {
      return widget.currentValue! < widget.dangerThreshold!;
    }
    return widget.currentValue! >= widget.dangerThreshold!;
  }

  Color get _statusColor {
    if (_isDanger) return AppTheme.accentRed;
    if (_isWarning) return AppTheme.accentAmber;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (_isWarning || _isDanger)
                  ? _statusColor.withOpacity(0.5)
                  : AppTheme.borderColor,
              width: (_isWarning || _isDanger) ? 1.5 : 1,
            ),
            boxShadow: (_isWarning || _isDanger)
                ? [
                    BoxShadow(
                      color: _statusColor.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: widget.isLoading ? _buildShimmer() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => widget.gradient.createShader(bounds),
              child: Icon(widget.icon, color: Colors.white, size: 20),
            ),
            if (_isWarning || _isDanger)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _statusColor,
                  boxShadow: [
                    BoxShadow(
                      color: _statusColor.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) => widget.gradient.createShader(bounds),
          child: Text(
            widget.value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Text(
          widget.unit,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shimmerBox(20, 20, radius: 6),
        const SizedBox(height: 8),
        _shimmerBox(50, 22, radius: 6),
        const SizedBox(height: 4),
        _shimmerBox(40, 10, radius: 4),
        _shimmerBox(60, 10, radius: 4),
      ],
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 4}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppTheme.borderGlow,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
