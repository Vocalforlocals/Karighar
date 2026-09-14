import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../bloc/buyer_bloc.dart';

class ArCraftViewerScreen extends StatefulWidget {
  final String productId;
  const ArCraftViewerScreen({super.key, required this.productId});

  @override
  State<ArCraftViewerScreen> createState() => _ArCraftViewerScreenState();
}

class _ArCraftViewerScreenState extends State<ArCraftViewerScreen> {
  double _rotationAngle = 0.0;
  double _scale = 1.0;
  String _lightingMode = 'Warm Indoor';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerBloc, BuyerState>(
      builder: (context, state) {
        final product = state.allProducts.firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => state.allProducts.first,
        );

        Color lightingTint;
        if (_lightingMode == 'Daylight') {
          lightingTint = Colors.lightBlueAccent.withValues(alpha: 0.15);
        } else if (_lightingMode == 'Warm Indoor') {
          lightingTint = Colors.amberAccent.withValues(alpha: 0.2);
        } else {
          lightingTint = Colors.white.withValues(alpha: 0.25);
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: Stack(
            children: [
              // Living Room Camera Simulation Background
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        Color(0xFF334155),
                        Color(0xFF0F172A),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 280,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.elliptical(280, 140)),
                      ),
                    ),
                  ),
                ),
              ),

              // Plane Reticle Grid
              Positioned(
                bottom: 180,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.teal.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.view_in_ar_rounded, color: AppColors.teal, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Horizontal Plane Detected • Anchored 1:1 Scale',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Interactive 3D Model Centerpiece
              Center(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _rotationAngle += details.delta.dx * 0.01;
                    });
                  },
                  child: Transform.scale(
                    scale: _scale,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateY(_rotationAngle),
                      child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shadow
                        Positioned(
                          bottom: -20,
                          child: Container(
                            width: 200,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              borderRadius: const BorderRadius.all(Radius.elliptical(200, 30)),
                            ),
                          ),
                        ),
                        // Product Image with Lighting Tint Matrix
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(lightingTint, BlendMode.screen),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              product.images.first,
                              width: 260,
                              height: 260,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

              // Top Craft Badge
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('Est. Dimensions: 48cm × 36cm (True Scale)', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                        ],
                      ),
                      const VKBadge(label: 'AR READY', type: VKBadgeType.ai),
                    ],
                  ),
                ),
              ),

              // Bottom AR Controls Drawer
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Lighting Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Lighting Sim:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                            Row(
                              children: ['Warm Indoor', 'Daylight', 'Spotlight'].map((mode) {
                                final isSel = _lightingMode == mode;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: InkWell(
                                    onTap: () => setState(() => _lightingMode = mode),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSel ? AppColors.teal : Colors.white12,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(mode, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Rotation & Scale Sliders
                        Row(
                          children: [
                            const Text('Scale:', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Expanded(
                              child: Slider(
                                value: _scale,
                                min: 0.6,
                                max: 1.4,
                                activeColor: AppColors.teal,
                                inactiveColor: Colors.white12,
                                onChanged: (v) => setState(() => _scale = v),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Rotate:', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Expanded(
                              child: Slider(
                                value: _rotationAngle % (2 * math.pi),
                                min: 0,
                                max: 2 * math.pi,
                                activeColor: AppColors.saffron,
                                inactiveColor: Colors.white12,
                                onChanged: (v) => setState(() => _rotationAngle = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: VKButton(
                                label: 'Digital Passport',
                                icon: Icons.verified_rounded,
                                variant: VKButtonVariant.outline,
                                height: 42,
                                onPressed: () => context.go('/buyer/passport/${product.id}'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: VKButton(
                                label: 'Add to Cart (₹${product.price.toStringAsFixed(0)})',
                                icon: Icons.shopping_bag_outlined,
                                variant: VKButtonVariant.primary,
                                height: 42,
                                onPressed: () {
                                  context.read<BuyerBloc>().add(AddToCartEvent(product));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Item added to cart from AR preview!'), backgroundColor: AppColors.teal),
                                  );
                                  context.go('/buyer/cart');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
