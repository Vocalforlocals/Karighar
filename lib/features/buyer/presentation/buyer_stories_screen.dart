import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';

class BuyerStoriesScreen extends StatelessWidget {
  const BuyerStoriesScreen({super.key});

  final List<Map<String, dynamic>> _stories = const [
    {
      'id': 'story_ramdev',
      'artisanName': 'Master Ramdev Varma',
      'craft': 'Banarasi Katan Silk Brocade',
      'location': 'Varanasi, Uttar Pradesh',
      'experience': '38 Years of Heritage Pit-Loom Weaving',
      'awards': 'Shilp Guru Awardee 2024',
      'giTag': 'GI-IN-0012',
      'heroImage': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=800&q=80',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'quote': 'Every thread of electroplated silver zari tells a story of patience. A master saree takes 14 days of dedicated hand shuttle passes.',
      'craftTechnique': 'Handloom Jacquard with Kadwa & Kadhwan motifs',
      'impactStat': 'Supports 12 women spinning clusters in Varanasi',
    },
    {
      'id': 'story_sita',
      'artisanName': 'Smt. Sita Devi',
      'craft': 'Madhubani Kohbar Folk Painting',
      'location': 'Madhubani, Mithila, Bihar',
      'experience': '42 Years of Generational Folk Artistry',
      'awards': 'National Handicraft Awardee',
      'giTag': 'GI-370',
      'heroImage': 'https://images.unsplash.com/photo-1582738411706-bfc8e691d1c2?auto=format&fit=crop&w=800&q=80',
      'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      'quote': 'We do not use synthetic brushes. We paint sacred geometry with fine bamboo twigs and pure vegetable dyes extracted from aparajita and turmeric.',
      'craftTechnique': 'Natural Pigment Line Painting (Kachni & Bharni)',
      'impactStat': 'Trains 45 young rural artisans in Jitwarpur village',
    },
    {
      'id': 'story_anand',
      'artisanName': 'Anand Prajapati',
      'craft': 'Sacred Terracotta Pottery & Earthenware',
      'location': 'Gorakhpur, Uttar Pradesh',
      'experience': '25 Years of Clay Alchemy',
      'awards': 'State Master Craftsman',
      'giTag': 'GI-IN-0412',
      'heroImage': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&w=800&q=80',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      'quote': 'The soil of our riverbeds possesses a unique natural elasticity. When wood-fired in traditional kilns, it rings like brass metal.',
      'craftTechnique': 'Wood-fired Earthenware & Hand-sculpted Relief',
      'impactStat': 'Preserves 300-year-old kiln pottery cooperative',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _stories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final story = _stories[index];

          return VKCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Story Hero Media with Badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        story['heroImage'] as String,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: AppColors.terracottaLight,
                          child: const Center(
                            child: Icon(Icons.movie_creation_outlined, color: AppColors.terracotta, size: 48),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: VKBadge(
                        label: story['awards'] as String,
                        type: VKBadgeType.verified,
                        icon: Icons.military_tech_rounded,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shield_rounded, color: AppColors.zariGold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              story['giTag'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.terracotta,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppColors.elevatedShadow,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Watch Reel',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Artisan Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              story['avatar'] as String,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 44,
                                height: 44,
                                color: AppColors.terracottaLight,
                                child: const Icon(Icons.person, color: AppColors.terracotta, size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story['artisanName'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${story['craft']} • ${story['location']}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Quote in Italic
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.parchmentSilk,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.format_quote_rounded, color: AppColors.terracotta, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                story['quote'] as String,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Technique & Community Impact
                      Row(
                        children: [
                          const Icon(Icons.palette_outlined, size: 16, color: AppColors.terracotta),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              story['craftTechnique'] as String,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.favorite_rounded, size: 16, color: AppColors.emeraldDeep),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              story['impactStat'] as String,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.emeraldDeep),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // CTA
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.royalIndigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                          label: Text('View Authentic Crafts'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          onPressed: () => context.go('/buyer'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ),
);
  }
}
