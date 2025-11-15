import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/screens/tailor/tailor_dashboard_screen.dart';
import '../../main.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.role == 'tailor') {
      return const TailorDashboardScreen();
    }

    final roleLabel =
        (auth.role != null && auth.role!.trim().isNotEmpty) ? auth.role! : 'Valued Customer';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () => auth.logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingCard(roleLabel: roleLabel),
              const SizedBox(height: 28),
              const _SectionTitle(
                title: 'Quick Actions',
                subtitle: 'Navigate your tailoring journey effortlessly',
              ),
              const SizedBox(height: 16),
              _QuickActions(
                onCatalogTap: () => Navigator.pushNamed(context, Routes.catalogHome),
                onOrdersTap: () => Navigator.pushNamed(context, Routes.orderList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.roleLabel});

  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withOpacity(0.9),
            AppTheme.primary.withOpacity(0.7),
            AppTheme.accent.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Welcome back',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Ready to design\nsomething beautiful?',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 30,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Your dashboard is curated with your preferences in mind.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onCatalogTap,
    required this.onOrdersTap,
  });

  final VoidCallback onCatalogTap;
  final VoidCallback onOrdersTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;

        if (isNarrow) {
          return Column(
            children: [
              _DashboardActionCard(
                title: 'Product & Service Catalog',
                description: 'Discover fabrics, designs, and premium tailoring services.',
                icon: Icons.storefront_outlined,
                gradientColors: const [AppTheme.primary, Color(0xFFFFD1D1)],
                onTap: onCatalogTap,
              ),
              const SizedBox(height: 18),
              _DashboardActionCard(
                title: 'My Orders',
                description: 'Track progress and manage measurements for every project.',
                icon: Icons.list_alt_rounded,
                gradientColors: const [AppTheme.accent, Color(0xFF7FE5D7)],
                onTap: onOrdersTap,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _DashboardActionCard(
                title: 'Product & Service Catalog',
                description: 'Discover fabrics, designs, and premium tailoring services.',
                icon: Icons.storefront_outlined,
                gradientColors: const [AppTheme.primary, Color(0xFFFFD1D1)],
                onTap: onCatalogTap,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _DashboardActionCard(
                title: 'My Orders',
                description: 'Track progress and manage measurements for every project.',
                icon: Icons.list_alt_rounded,
                gradientColors: const [AppTheme.accent, Color(0xFF7FE5D7)],
                onTap: onOrdersTap,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  const _DashboardActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: gradientColors.first,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

