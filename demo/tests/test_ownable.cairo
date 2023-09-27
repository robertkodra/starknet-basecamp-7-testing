// core 
use starknet::{ContractAddress, Felt252TryIntoContractAddress};
use array::{ArrayTrait, SpanTrait};
use traits::TryInto;
use option::OptionTrait;
use result::ResultTrait;

// forge
use snforge_std::{declare, ContractClassTrait};
use snforge_std::PrintTrait;
use snforge_std::{start_prank, stop_prank};
use snforge_std::{start_mock_call, stop_mock_call};
use snforge_std::{FileTrait, read_txt};

// project
use demo::{OwnableTraitSafeDispatcher, OwnableTraitSafeDispatcherTrait};
use demo::{IDataDispatcher, IDataDispatcherTrait};

// OZ 
mod Errors{
    const INVALID_OWNER: felt252 = 'Caller is not the owner';
    const INVALID_DATA: felt252 = 'Invalid Data';
}

// mock addresses
// https://cairopractice.com
mod Accounts{
    use traits::TryInto;
    use starknet::{ContractAddress};

    fn admin() -> ContractAddress {
        'admin'.try_into().unwrap()
    }

    fn new_admin() -> ContractAddress {
        'new_admin'.try_into().unwrap()
    }

    fn bad_guy() -> ContractAddress {
        'bad_guy'.try_into().unwrap()
    }

}

// helper function
fn deploy_contract(name: felt252) -> ContractAddress {
    let account: ContractAddress = Accounts::admin();

    // declare contract
    let contract = declare(name);

    // Option #1
    // let mut constructor_data = ArrayTrait::new();
    // constructor_data.append(account.into());

    // Option #2
    // let mut constructor_data = array![account.into()];

    // Option #3 
    let file = FileTrait::new('data/constructor_data.txt');
    let constructor_data = read_txt(@file);

    // deploy contract
    contract.deploy(@constructor_data).unwrap()
}

#[test]
fn test_constructor_with_admin(){

    let contract_address = deploy_contract('ownable');

    let safe_dispatcher = OwnableTraitSafeDispatcher { contract_address };

    let owner = safe_dispatcher.owner().unwrap(); 

    assert(Accounts::admin() == owner, Errors::INVALID_OWNER);

}

#[test]
fn test_transfer_ownership_with_admin(){

    let contract_address = deploy_contract('ownable');

    let safe_dispatcher = OwnableTraitSafeDispatcher { contract_address };

    // changing the caller address for a contract at the given address
    start_prank(contract_address, Accounts::admin());

    safe_dispatcher.transfer_ownership(Accounts::new_admin()); 

    let owner = safe_dispatcher.owner().unwrap(); 

    assert(Accounts::new_admin() == owner, Errors::INVALID_OWNER);

    // cancels start_prank
    stop_prank(contract_address);
}

#[test]
#[should_panic(expected: ('Caller is not the owner', ))]
fn test_transfer_ownership_with_nonadmin() {
    let contract_address = deploy_contract('ownable');

    let safe_dispatcher = OwnableTraitSafeDispatcher { contract_address };

    // changing the caller address for a contract at the given address
    start_prank(contract_address, Accounts::bad_guy());

    safe_dispatcher.transfer_ownership(Accounts::bad_guy()); 

    let owner = safe_dispatcher.owner().unwrap(); 

    assert(Accounts::bad_guy() == owner, Errors::INVALID_OWNER);

    stop_prank(contract_address);


}

#[test]
fn test_data_with_mock() {

    let contract_address = deploy_contract('ownable');

    let dispatcher = IDataDispatcher { contract_address };

    // changing the caller address for a contract at the given address
    let mock_ret_data = 777;

    start_mock_call(contract_address, 'get_data', mock_ret_data); // start the mock
    start_prank(contract_address, Accounts::admin()); // seting as admin

    dispatcher.set_data(13);
    let data = dispatcher.get_data();
    assert(data == 777, Errors::INVALID_DATA); // this assert passes

//     stop_mock_call(contract_address, 'get_data');
//     let data = dispatcher.get_data();
//     data.print();
//     assert(data == 777, Errors::INVALID_DATA); // this assert passes
}