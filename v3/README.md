---
title: Training Shifumi dapp
tags: Training
description: Training Shifumi for decentralized application
---

Training Shifumi dapp V3
===

# Time to bet!

In this last version, players should bet exactly 10 tez if they want to `play`. 
When the round has been revealed, the `conclude` action solves the round and gives
back the betting to the winner or send back the played tez to each player in case 
of a draw.

## Nominal sequence diagram

### Player1 wins

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  participant Sender
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action,amount1)
  Player2->>SM: chest(action,amount2)
  Player1->>SM: reveal
  Player2->>SM: reveal
  Sender->>SM: conclude
  SM->>Player1: amount1 + amount2)
```

### Player2 wins

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  participant Sender
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action,amount1)
  Player2->>SM: chest(action,amount2)
  Player1->>SM: reveal
  Player2->>SM: reveal
  Sender->>SM: conclude
  SM->>Player2: amount1 + amount2)
```
### Draw

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  participant Sender
  Note left of Player1: Prepare action(stone|paper|scissor, secret)
  Note right of Player2: Prepare action(stone|paper|scissor, secret)
  Player1->>SM: chest(action,amount1)
  Player2->>SM: chest(action,amount2)
  Player1->>SM: reveal
  Player2->>SM: reveal
  Sender->>SM: conclude
  SM->>Player1: amount1
  SM->>Player2: amount2
```

### Round Value review

Since we accept tez for the betting we should manage this information during the
round each time a player decides to play. For this purpose, the RoundValue play
should be revisited by implementing this management.

Finally, for given two `RoundValues` we would like to retrieve each player its action 
and the betting amount thanks to the `retrieved` function.

## Storage review

Since we have to send the price to the winner we need a function able to retrieve the
address for a given player.

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
("✅" , {expected = false})

Test failed with "Should provide a play action for a given round_value and chest"
Trace:
File "test/../lib/round_value.jsligo", line 36, characters 4-78:

File "test/t02_round_value.jsligo", line 32, characters 28-77 ,
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
         reveal(t,Player.t,(chest) -> Action.t) t
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
