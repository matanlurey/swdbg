part of '../models.dart';

/// A condition that must be met for an ability to be applied.
sealed class Condition {
  // ignore: public_member_api_docs
  const Condition();

  /// Creates a condition that is met when defeating a unit from the galaxy row.
  const factory Condition.defeatGalaxyRow() = DefeatGalaxyRowCondition._;

  /// Creates a condition that is met when attacking a unit from the galaxy row.
  const factory Condition.attackGalaxyRow() = AttackGalaxyRowCondition._;

  /// Creates a condition that is met when the "Force is with You".
  const factory Condition.forceIsWithYou() = ForceIsWithYouCondition._;

  /// Creates a condition that is met if a card matching a selector is in play.
  const factory Condition.inPlay(CardSelector selector) = InPlayCondition._;

  /// Creates a condition that is met if an opponent's card matches a selector in play.
  const factory Condition.opponentInPlay(CardSelector selector) =
      OpponentInPlayCondition._;

  /// Creates a condition that is met if you apply an optional ability.
  const factory Condition.ifYou(Ability ability) = IfYouCondition._;

  /// Creates a condition that is met if your opponent does *not* apply an optional ability.
  const factory Condition.ifOpponentDoesNot(Ability ability) =
      IfOpponentDoesNotCondition._;

  /// Creates a condition that is met if you exile the current card.
  const factory Condition.ifYouExileCurrentCard() =
      IfYouExileCurrentCardCondition._;
}

/// A condition that is met when defeating a unit from the galaxy row.
final class DefeatGalaxyRowCondition extends Condition {
  const DefeatGalaxyRowCondition._();
}

/// A condition that is met when attacking a unit from the galaxy row.
final class AttackGalaxyRowCondition extends Condition {
  const AttackGalaxyRowCondition._();
}

/// A condition that is met when the "Force is with You".
final class ForceIsWithYouCondition extends Condition {
  const ForceIsWithYouCondition._();
}

/// A condition that is met if a card matching a selector is in play.
final class InPlayCondition extends Condition {
  /// The selector to check for.
  final CardSelector selector;

  const InPlayCondition._(this.selector);
}

/// A condition that is met if an opponent's card matches a selector in play.
final class OpponentInPlayCondition extends Condition {
  /// The selector to check for.
  final CardSelector selector;

  const OpponentInPlayCondition._(this.selector);
}

/// A condition that is met if you apply an optional ability.
final class IfYouCondition extends Condition {
  /// The ability to apply.
  final Ability ability;

  const IfYouCondition._(this.ability);
}

/// A condition that is met if your opponent does *not* apply an optional ability.
final class IfOpponentDoesNotCondition extends Condition {
  /// The ability to apply.
  final Ability ability;

  const IfOpponentDoesNotCondition._(this.ability);
}

/// A condition that is met if you exile the current card.
final class IfYouExileCurrentCardCondition extends Condition {
  const IfYouExileCurrentCardCondition._();
}
