import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

void showPrivacyDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.privacyPolicy),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.privacyIntro),
            _SectionTitle(l10n.privacyAuthTitle),
            Text(l10n.privacyAuthBody),
            _SectionTitle(l10n.privacyDataCollectionTitle),
            Text(l10n.privacyDataCollectionBody),
            _SectionTitle(l10n.privacyDataStorageTitle),
            Text(l10n.privacyDataStorageBody),
            _SectionTitle(l10n.privacyThirdPartyTitle),
            Text(l10n.privacyThirdPartyBody),
            _SectionTitle(l10n.privacyDataDeletionTitle),
            Text(l10n.privacyDataDeletionBody),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
