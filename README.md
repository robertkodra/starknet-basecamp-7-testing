# Basecamp 07 - Session 4: Testing

This session aims to teach you how to start testing your contract in Cairo.

Slides: TBA

Lecture Video: TBA

![Nicolas Cage Let's Ride](https://media.tenor.com/PDEhy7xqVdoAAAAC/lets-ride-nicolas-cage.gif)

# Getting Started

### Scarb:

To install Scarb, follow the installation process from [here](https://docs.swmansion.com/scarb/download.html).

### Starknet Foundry:

To install Starknet Foundry, follow the installation process from [here](https://foundry-rs.github.io/starknet-foundry/).

```bash
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
```

Then check if the installation has been successful by running:

```bash
snforge --version
>> forge 0.6.0
```

# Setting up the project

We will continue to work from the previous project. You can find the project source [here](https://github.com/glihm/starknet-basecamp-7/tree/main).

## Initializing your project with snforge (optional)

Another way to initialize your project is by executing the following command:

```bash
snforge --init PROJECT_NAME
```

More about the project structure [here](https://foundry-rs.github.io/starknet-foundry/getting-started/first-steps.html).

# Cheatcodes

Cheatcodes is a powerful feature withn the Starknet Foundry tool. These cheatcodes offer multiple advantages when testing a project. These are the following:

### `start_prank()`

- Changes the caller address for a contract at the given address.
- `stop_prank()` to cancel it

### `start_mock_call()`

- Mocks contract call to a function_name of a contract at the given address
- `stop_mock_call()` to cancel it

### `start_roll()`

- Changes the block number for a contract at the given address.
- `stop_roll()` to cancel it

### `start_warp()`

- Changes the block timestamp for a contract at the given address.
- `stop_warp()` to cancel it

For the full list of available cheatcodes, check out the [Cheatcodes Reference page](https://foundry-rs.github.io/starknet-foundry/appendix/cheatcodes.html).

### Forge Library Functions

- `declare()` - declares a contract and returns the `ContractClass`
- `precalculate_address()` - calculate an address of a contract in advance prior deploying
- `deploy()` - deploys a contract and returns its address
- `read_txt()` - read and parse text file content to an array of felts (`read_json()`)
- `print()` - print the test data

For the full list of the Library Functions Referneces click [here](https://foundry-rs.github.io/starknet-foundry/appendix/forge-library.html).

## Upcoming releases:

### Fuzz testing

- Currently only `felt252` is supported, however other data types will be supported in the upcoming version.

```bash
snforge --fuzzer-runs 1000 --fuzzer-seed 42
```

A more configurable approach with [#661](https://github.com/foundry-rs/starknet-foundry/issues/661):

```rust
#[test]
#[fuzzer ....]
fn test_fuzzer(){

}
```

To track current progress, check [here](https://github.com/foundry-rs/starknet-foundry/milestone/9).

### Gas Report gas

For now, the gas report will be released once Cario v2.3.0 is available.

As an alternative, you can perform the following to find out the gas usage:

```rust
    let initial_gas = testing::get_available_gas();
    gas::withdraw_gas().unwrap();

    // CODE HERE

    (initial_gas - testing::get_available_gas()).print();

```

### State Forking

Allows running an entire test suite against a specific forked environment.

More information, [here](https://github.com/foundry-rs/starknet-foundry/blob/597-implement-fork/design_documents/state_forking/state_forking.md).

To track current progress, check [here](https://github.com/foundry-rs/starknet-foundry/milestone/7).
