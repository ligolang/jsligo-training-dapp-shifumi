---
title: Training Shifumi dapp
tags: Training
description: Training Shifumi for decentralized application
---

Training Shifumi dapp
===

> dapp : A decentralized application (dApp) is a type of distributed open source software application that runs on a peer-to-peer (P2P) blockchain network rather than on a single computer. DApps are visibly similar to other software applications that are supported on a website or mobile device but are P2P supported

Goal of this training is to develop a shifumi game with smart contract. You will learn : 
- create a smart contract in jsligo,
- use specific chest functionality,
- apply a TDD (Test driven development) approach.

# Prerequisites

## Remote execution

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ligolang/jsligo-training-dapp-shifumi)

## Local execution

Please install this software first on your machine or use online alternative : 

- [ ] [VS Code](https://code.visualstudio.com/download) : as text editor
- [ ] [ligo](https://ligolang.org/docs/intro/installation/) : high level language that's transpile to michelson low level language and provide lot of development support for Tezos

# V1 

## Game rule

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

# V2 A fair game!

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

## Smart contract

# V3 Time to Bet!

In this third version each player should engage 1tez each time they decide to play an action.

