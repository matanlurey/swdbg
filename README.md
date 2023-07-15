# SWDBG Logging App

An app that allows logging turns of [Star Wars: The Deckbuilding Game][swdbg].

[swdbg]: https://boardgamegeek.com/boardgame/374173/star-wars-deckbuilding-game

## Overview

In [Star Wars: The Deckbuilding Game][swdbg], players take turns playing,
acquiring, and using abilities of cards.

This app allows players to log their turns, and then view the log to see what
happened.

Some hypothetical use cases:

- A player wants to know what happened in a game they played, but they don't
  remember the details.
- Sharing a game log with a friend to show them how the game went.
- Analysis of game logs to see how often certain cards are used, or how often
  certain cards are acquired.

In the future, this app may be expanded to allow for more features, but at the
moment it is narrowly focused on logging:

- What cards are present in each player's deck.
- What cards are acquired by each player.
- What cards are played by each player.

All logging is done manually by the players, and is optional. The app does not
enforce any rules of the game, and does not keep track of any game state beyond
what is logged. The primary purpose of the app is to simplify what otherwise
would be a tedious process of logging turns on paper.
