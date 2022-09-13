---
title: Training Shifumi dapp
tags: Training
description: Training Shifumi for decentralized application
---

Training Shifumi dapp V2
===

# A fair game!

In order to have a fair game the gameplay is done in two stages. The first one each player 
choose to play `stone` or `paper` or `scissor` and cipher it thanks to the `chest` functionality 
provided by the Tezos protocol. So compared to v1 instead of sending directly the action value 
the player send its encrypted value.

> [Chest in Tezos](https://tezos.gitlab.io/alpha/timelock.html)

Each player can reveal his choice sending the `chest_key` and  the `secret` used for the ciphering. 
Of course a player cannot reveal its choice since the other one did not play. When each player has 
revealedwe can can conclude.

We start from the solution designed for the simple approach i.e. v1. First we review the initial sequence diagrams. 

## Nominal sequence diagram

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  participant Sender
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player2->>SM: chest(action)
  Player1->>SM: reveal
  Player2->>SM: reveal
  Sender->>SM: conclude
```

## Additional Prohibited sequences

### Cannot reveal when another player did not play

We should avoid earlier play revelation.

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player1-xSM: reveal
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

### Cannot conclude when round is not completed

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  participant Sender
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action)
  Player2->>SM: chest(action)
  Player1->>SM: reveal
  Sender-xSM: conclude
```

## Howto?

The implementation can be done thanks to the proposed tests suite. 

```sh
training-shifumi ➤ cd v2
v1 ➤ make 
[Testing] test/t01_action.jsligo
("✅" , {expected = true})
("✅" , {expected = false})
("✅" , {expected = false})
("✅" , {expected = false})
("✅" , {expected = true})
("✅" , {expected = false})
("✅" , {expected = false})
("✅" , {expected = false})
("✅" , {expected = true})
Everything at the top-level was executed.
- tests exited with value ().
[Testing] test/t02_round_value.jsligo
("✅" , {expected = true})
("✅" , {expected = false})

Test failed with "Predicate checking if the round_value is revealed"
Trace:
File "test/../lib/round_value.jsligo", line 25, characters 4-65:

File "test/t02_round_value.jsligo", line 21, characters 23-65 ,
File "test/common/check.jsligo", line 27, characters 41-48 ,
File "test/common/check.jsligo", line 27, characters 4-52 ,
File "test/t02_round_value.jsligo", line 102, character 14 to line 104, character 3
make: *** [test/t02_round_value.dummy] Error 1
```

Once again go through each file where implementation is required and propose an implementation.

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
         play(t,chest,tez) t
         reveal(t,(chest) -> Action.t) t
         is_waiting(t) bool
         is_played(t) bool
         is_revealed(t) bool
    }

    class Round{
         type t
         fresh_round :t
         get_round_value(t,Player.t) (RoundValue.t)
         play(t,Player.t) t
         reveal(t,Player.t,(chest) -> Action.t) t
         is_waiting(t,Player.t) bool
         is_played(t,Player.t) bool
         is_revealed(t,Player.t) bool
    }

    class Storage{
         type t
         initial_storage t
         new_game(t) t
         get_player(t,Address.t) (option Player.t)
         get_current_round(t) (option Round.t)
         update_current_round(t,Round.t) (Storage.t)
    }
```
