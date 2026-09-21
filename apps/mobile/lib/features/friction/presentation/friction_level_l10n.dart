import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/l10n/l10n.dart';

extension FrictionLevelL10n on FrictionLevel {
  String label(AppLocalizations l10n) => switch (this) {
    FrictionLevel.awareness => l10n.frictionL0Name,
    FrictionLevel.micro => l10n.frictionL1Name,
    FrictionLevel.reflective => l10n.frictionL2Name,
    FrictionLevel.fullBlock => l10n.frictionL3Name,
    FrictionLevel.partnerGated => l10n.frictionL4Name,
  };

  String description(AppLocalizations l10n) => switch (this) {
    FrictionLevel.awareness => l10n.frictionL0Desc,
    FrictionLevel.micro => l10n.frictionL1Desc,
    FrictionLevel.reflective => l10n.frictionL2Desc,
    FrictionLevel.fullBlock => l10n.frictionL3Desc,
    FrictionLevel.partnerGated => l10n.frictionL4Desc,
  };
}
