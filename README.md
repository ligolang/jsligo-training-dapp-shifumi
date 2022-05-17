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

The gameplay is simple. Each player choose to play `stone` or `paper` or `cisor` and that's all!

## Nominal sequence diagram

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  Note left of Player1: Prepare action(stone|paper|cisor, secret)
  Note right of Player2: Prepare action(stone|paper|cisor, secret)
  Player1->>SM: action
  Player2->>SM: action
```

## Prohibited sequences

### Cannot play twice

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare chest(stone|paper|cisor, secret)
  Player1->>SM: action
  Player1-xSM: action'
```

## Smart contract

### Step 1 : Create folders & files

```bash
mkdir smartcontract
touch ./shifumi/contract/v1/main.jsligo
touch ./shifumi/test/v1/test.jsligo
```

### Step 2 : Edit main.jsligo

Add the `Storage` namespace, the parameter type and finally the `main` function.

```ligo
export namespace Storage {
    export type action = ["Stone"] | ["Paper"] | ["Cisor"];

    export type t = unit;

    export const create = (player1: address, player2: address) : t => {
      return failwith("TODO");
    };

    export const new_game = (storage: t, player1: address, player2: address) : t => {
      return failwith("TODO");
    };

    export const play = (storage: t, player: address, action: action) : t => {
      return failwith("TODO");
    };
};

export type parameter = 
    ["Reset", [address, address]] 
  | ["Play", action];

export const main = (parameter: parameter, storage: Storage.t) : [list<operation>, Storage.t] => {
    const new_storage = match(parameter, {
        Reset : p => Storage.new_game(storage, p[0], p[1]),
        Play  : p => Storage.play(storage, Tezos.sender, p)
    });
    return [list([]) as list<operation>, new_storage];
};
```

Every contract requires :
- an entrypoint, **main** by default, with a mandatory signature taking 2 parameters and a return : 
    - **parameter** : the contract `parameter`
    - **storage** : the on-chain storage (can be any type, here `unit` by default)
    - **return_** : a list of `operation` and a storage

> Doc :  https://ligolang.org/docs/advanced/entrypoints-contracts

>:warning: You will notice that jsligo is a javascript-like language, multiple parameter declaration is a bit different.
You have to separate variable name to its type declaration this way : `([action, store] : [parameter, storage])`

Simple pattern matching is an important feature in Ligo. We need a switch on the entrypoint function to manage different actions. 
We use `match` to evaluate the parameter and call the appropriated `poke` function

> Doc https://ligolang.org/docs/language-basics/unit-option-pattern-matching

```ligo
    match (action, {
        Reset : p => Storage.new_game(storage, p[0], p[1]),
        Play  : p => Storage.play(storage, Tezos.sender, p)
    } 
```

`Reset` and `Play` aare `parameters` from a `variant` type. It can be expressed by the following type:

```ligo
export type parameter = ["Reset", address, address] | ["Play", action];
```

> Doc https://ligolang.org/docs/language-basics/unit-option-pattern-matching#variant-types

# V2 A fair game!

The gameplay is done in two stages. The first one each player choose to play `stone` or `paper` or `cisor`
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
  Note left of Player1: Prepare action(stone|paper|cisor, secret)
  Note right of Player2: Prepare action(stone|paper|cisor, secret)
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
  Note left of Player1: Prepare action(stone|paper|cisor, secret)
  Player1->>SM: chest(action)
  Player1-xSM: reveal
```

### Cannot play twice

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  Note left of Player1: Prepare action(stone|paper|cisor, secret)
  Player1->>SM: chest(action)
  Player1-xSM: chest(action)
```

### Cannot reveal twice

```mermaid
sequenceDiagram
  participant Player1
  participant SM
  participant Player2
  Note left of Player1: Prepare action(stone|paper|cisor, secret)
  Note right of Player2: Prepare action(stone|paper|cisor, secret)
  Player1->>SM: chest(action)
  Player2->>SM: chest(action)
  Player1->>SM: reveal
  Player1-xSM: reveal
```

## Smart contract

### Step 1 : Create folders & files

```bash
mkdir smartcontract
touch ./shifumi/contract/main.jsligo
touch ./shifumi/test/test.jsligo
```

### Step 2 : Edit main.jsligo

Add the `Storage` namespace, the parameter type and finally the `main` function.

```ligo
export namespace Storage {
    export type action = ["Stone"] | ["Paper"] | ["Cisor"];

    export type t = unit;

    export const create = (player1: address, player2: address) : t => {
      return failwith("TODO");
    };

    export const new_game = (storage: t, player1: address, player2: address) : t => {
      return failwith("TODO");
    };

    export const play = (storage: t, player: address, action: chest) : t => {
      return failwith("TODO");
    };

    export const reveal = (storage: t, player: address, chest_key: chest_key, secret: nat) : t => {
      return failwith("TODO");
    };

};

export type parameter = 
    ["Reset", [address, address]] 
  | ["Play", chest] 
  | ["Reveal", [chest_key, nat]];

export const main = (parameter: parameter, storage: Storage.t) : [list<operation>, Storage.t] => {
    const new_storage = match(parameter, {
        Reset  : p => Storage.new_game(storage, p[0], p[1]),
        Play   : p => Storage.play(storage, Tezos.sender, p),
        Reveal : p => Storage.reveal(storage, Tezos.sender, p[0], p[1]),
    });
    return [list([]) as list<operation>, new_storage];
};
```

# V3 Time to Bet!

In this third version each player should engage 1tez each time they decide to play an action.

