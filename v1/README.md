---
title: Training Shifumi dapp
tags: Training
description: Training Shifumi for decentralized application
---

Training Shifumi dapp V1
===

# A basic approach

> We propose an implementation for only two players in order to simplify some algorithms.

The gameplay is simple. Each player choose to play `stone`, `paper` or `scissor` and that's all!

## Nominal sequence diagram

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: action
  Player2->>SM: action
```

## Prohibited sequences

### Cannot play twice

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare chest(stone|paper|scissor, secret)
  Player1->>SM: action
  Player1-xSM: action'
```

## Smart contract

```mermaid
classDiagram
    Action <|-- RoundValue
    RoundValue <|-- Round
    Round <|-- Storage
    Player <|-- Round
    Player <|-- Storage

    class Action{
        +paper :Action
        +stone :Action
        +scissor :Action
        +is_paper(Action) bool
        +is_stone(Action) bool
        +is_scissor(Action) bool
    }
            
    class Player{
        +player1 :Player 
        +player2 :Player
    }

    class RoundValue{
        +is_waiting(RoundValue) bool
        +is_played(RoundValue) bool
        +play(RoundValue,Action) RoundValue
    }

    class Round{
        +fresh_round :Round
        +get_round_value(Round,Player) RoundValue
        +play(Round,Player,Action) Round
    }

    class Storage{
        +fresh_storage : Storage
        +new_game(Storage) : Storage
        +get_player(Storage,Address) : Player
        +get_current_round(Storage) : Round
        +update_current_round(Storage,Round) : Storage
    }
```
