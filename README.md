# Fuzz tests explained during the Spearbit presentation

## Before starting

Install Echidna 2.0.2:

* Install/upgrade [slither](https://github.com/crytic/slither): `pip3 install slither-analyzer --upgrade`
* Recommended option: [precompiled binaries](https://github.com/crytic/echidna/releases/tag/v2.0.2) (Linux and MacOS supported). 
* Alternative option: [use docker](https://hub.docker.com/layers/echidna/trailofbits/echidna/v2.0.2/images/sha256-2d8f87daad48818c8f0e6aca68be6add7d2e7016e950f22a0ceafa1224f03cde?context=explore).

If you do not have experience with Echidna, please start reviewing the [Echidna README](https://github.com/crytic/echidna#echidna-a-fast-smart-contract-fuzzer-), as well as [the official tutorials](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna). 

## The demo

This repository contains everything necessary to test simple properties of *SomeDeFi*, a syntetic minimalistic DeFi protocol. Users should complete the `TestSomeDefi` contract creating functions to test different invariants from function (e.g. mintShares, withdrawShares, etc) using assertions. 

A few pointers to start:

0. Read the implementation code of *SomeDeFi* (it is very small).
1. Think of basic properties for every operation
2. Consider when an operation should or it should *not* revert
3. Optimize the resulting properties, perhaps merging some of them.

To start a Echidna fuzzing campaign use:

```
$ echidna-test --test-mode assertion --contract TestSomeDefi --config SomeDeFi.yaml SomeDeFi.sol
```

The recommended Solidity version for the fuzzing campaign is 0.8.1, however, more recent releases can be used as well.
