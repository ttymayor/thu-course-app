import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SwipeTutorialPage extends StatefulWidget {
  const SwipeTutorialPage({super.key});

  @override
  State<SwipeTutorialPage> createState() => _SwipeTutorialPageState();
}

class _SwipeTutorialPageState extends State<SwipeTutorialPage>
    with SingleTickerProviderStateMixin {
  bool _swiped = false;
  int _dismissKey = 0;
  late AnimationController _hintController;
  late Animation<Offset> _hintAnimation;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _hintAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.15, 0),
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_hintController);
    _startHintLoop();
  }

  void _startHintLoop() {
    if (!_swiped) {
      _hintController.forward().then((_) {
        if (mounted && !_swiped) {
          _hintController.reverse().then((_) {
            if (mounted && !_swiped) {
              Future.delayed(const Duration(milliseconds: 600), () {
                if (mounted && !_swiped) _startHintLoop();
              });
            }
          });
        }
      });
    }
  }

  void _reset() {
    setState(() {
      _swiped = false;
      _dismissKey++;
    });
    _startHintLoop();
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tutorial),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Icon(
              Icons.swipe_left_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.swipeTutorialTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.swipeTutorialDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Fake course tile with Dismissible
            Dismissible(
              key: ValueKey('tutorial_$_dismissKey'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) async {
                setState(() => _swiped = true);
                _hintController.stop();
                return false;
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              child: SlideTransition(
                position: _swiped
                    ? const AlwaysStoppedAnimation(Offset.zero)
                    : _hintAnimation,
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        'CS',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    title: Text(
                      l10n.exampleCourse,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${l10n.exampleDepartment} • ${l10n.exampleClassTime}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: _swiped
                        ? Icon(Icons.check_circle, color: colorScheme.primary)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _swiped
                  ? Column(
                      key: const ValueKey('success'),
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.swipeTutorialSuccess,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _reset,
                          child: Text(l10n.swipeTutorialReset),
                        ),
                      ],
                    )
                  : Row(
                      key: const ValueKey('arrow'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.swipeToAdd,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.gotIt),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
