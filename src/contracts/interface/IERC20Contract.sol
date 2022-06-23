pragma solidity >= 0.7.0 < 0.9.0;
//"SPDX-License-Identifier: UNLICENSED

interface IERC20Contract {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function totalSupply() external view returns(uint256);
    function getBalance() external view returns(uint);
    function balanceOf(address account) external view returns(uint);
    function transfer(address to, uint256 amount) external returns(bool);
}
