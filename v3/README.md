---
title: Training Shifumi dapp
tags: Training
description: Training Shifumi for decentralized application
---

Training Shifumi dapp V3
===

# Time to bet!

In this last version, players should bet exactly 10 tez if they want to play. 
When the round has been revealed, the conclude action solves the round and give
back the bet to the winner or send back the played tez to each player.

## Nominal sequence diagram

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action),10tez
  Player2->>SM: chest(action),10tez
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

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
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

## Smart contract data types

```mermaid
classDiagram
    Action <|-- RoundValue
    RoundValue <|-- Round
    Round <|-- Storage
    Player <|-- Round
    Player <|-- Storage

    class Action{
         type t
         paper : t
         stone : t
         scissor : t
         is_paper(t) bool
         is_stone(t) bool
         is_scissor(t) bool
    }
            
    class Player{
         type t
         player1 : t
         player2 : t
    }

    class RoundValue{
         type t
         is_waiting(t) bool
         is_played(t) bool
         play(t,chest,tez) t
         reveal(t,(chest) -> Action.t) t
         revealed(t,t) 
    }

    class Round{
         type t
         fresh_round :t
         get_round_value(t,Player.t) (RoundValue.t)
         play(t,Player.t,chest,tez) t
         reveal(t,Player.t,(chest) -> Action.t) (RoundValue.t)
    }

    class Storage{
         type t
         initial_storage t
         new_game(t) t
         get_player(t,Address.t) (option Player.t)
         get_current_round(t) (option Round.t)
         update_current_round(t,Round.t) (Storage.t)
         get_address(t,Player.t) Address
    }
```
