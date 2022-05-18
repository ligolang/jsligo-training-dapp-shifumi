---
title: Training Shifumi dapp
tags: Training
description: Training Shifumi for decentralized application
---

Training Shifumi dapp V2
===

# A fair game!

The gameplay is done in two stages. The first one each player choose to play `stone` or `paper` or `scissor`
and cipher it thanks to the `chest` functionality provided by the Tezos protocol.

> [Chest in Tezos]()

The second one each player reveal his choice sending the `chest_key` and the `secret` used for the ciphering.
Of course a player cannot reveal its choice since the other one did not play.

## Nominal sequence diagram

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player2->>SM: chest(action)
  Player1->>SM: reveal
  Player2->>SM: reveal
```

## Prohibited sequences

### Cannot reveal when another player did not play

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player1-xSM: reveal
```

### Cannot play twice

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player1-xSM: chest(action)
```

### Cannot reveal twice

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player2->>SM: chest(action)
  Player1->>SM: reveal
  Player1-xSM: reveal
```

