aqui esta o inicio dos teste faça com base nos testes do cdi

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {AccessControlRegistry} from "../src/access/AccessControlRegistry.sol";
import {AccountingIndexes} from "../src/calculations-contracts/AccountingIndexes.sol";
import {Roles} from "../src/utils/Roles.sol";
import {DIOverMath} from "../src/lib/DIOverMath.sol";

contract AccountingDITest is Test {
    AccountingIndexes internal accounting;
    AccessControlRegistry internal accessControlRegistry;


    // Roles
    bytes32 internal constant OPERATOR_ROLE = Roles.OPERATOR;
    bytes32 internal constant ADMIN_ROLE = Roles.ADMIN;

    // Users
    address internal operator;
    address internal otherAccount;
    address internal adminUser;

    event DailyInterestFactorCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 tdik,
        uint256 fatorDi,
        uint256 fatorSpread,
        uint256 fatorJuros
    );

    event updatedPuCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 pu
    );

    function setUp() public {
        operator = makeAddr("operator");
        otherAccount = makeAddr("otherAccount");
        adminUser = makeAddr("adminUser");

        accessControlRegistry = new AccessControlRegistry();
        accessControlRegistry.initialize();

        accounting = new AccountingIndexes(
            address(accessControlRegistry)
        );

        accessControlRegistry.grantRole(OPERATOR_ROLE, operator);
        accessControlRegistry.grantRole(ADMIN_ROLE, adminUser);
        accessControlRegistry.grantRole(OPERATOR_ROLE, address(accounting));
    }

    function test_Revert_When_Caller_Is_Not_Operator() public {
        vm.prank(otherAccount);
        vm.expectRevert();
        
        uint256 spreadWad = 0.0055e18; // CDI + 0.55%
        uint256 expectedSpread = 1000021765833025361;
        
        uint256 result = accounting.spreadFactorPrecise(spreadWad);
    }

    function testcalculateIndexFactor() public {
        uint256 requestId = 1;
        uint256 vne = 1e18;
        uint256 previousCwad = 1000551310000000000;
        uint256 nik = ;
        unit256 nik_1 = ;
        uint256 daysNum = ;
        uint256 daysDen = ;
        uint256 spreadWad = ; 
        uint256 expectedValue = ;
        vm.prank(operator);




teste do cdi:

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {AccessControlRegistry} from "../src/access/AccessControlRegistry.sol";
import {AccountingDI} from "../src/calculations-contracts/AccountingDI.sol";
import {Roles} from "../src/utils/Roles.sol";
import {DIOverMath} from "../src/lib/DIOverMath.sol";

contract AccountingDITest is Test {
    AccountingDI internal accounting;
    AccessControlRegistry internal accessControlRegistry;


    // Roles
    bytes32 internal constant OPERATOR_ROLE = Roles.OPERATOR;
    bytes32 internal constant ADMIN_ROLE = Roles.ADMIN;

    // Users
    address internal operator;
    address internal otherAccount;
    address internal adminUser;

    event DailyInterestFactorCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 tdik,
        uint256 fatorDi,
        uint256 fatorSpread,
        uint256 fatorJuros
    );

    event updatedPuCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 pu
    );
    function testupdatedPuCalculation() public {
        uint256 requestId = 3;
        uint256 vne = 1000e18;
        uint256 fatorJurosAcumulado = 1000021766000000000;
        uint256 pu = (uint256(DIOverMath.mulWad(int256(vne), int256(fatorJurosAcumulado))));
        
        vm.prank(operator);
        vm.expectEmit(true, true, true, true);
        emit updatedPuCalculated(requestId, block.timestamp, pu);

        uint256 result = accounting.updatedPu(requestId, vne, fatorJurosAcumulado);

        assertEq(result, pu, "PU calculation mismatch");
        assertGt(result, vne);
    }

    function testRealDebentureOpa181() public {
        uint256 requestId = 1;
        uint256 vne = 1e18;
        uint256 _diFactor = 1000551310000000000;
        bool hasSpread = true;
        uint256 spreadWad = 0.0100e18; // 1% in WAD
        uint256 expectedValue = 1001181984603689398;
        vm.prank(operator);

        (uint256 result, uint256 interest) = accounting.calculateNewUpdatedFactor(requestId, 1000590817769026600, _diFactor, vne, hasSpread, spreadWad);
        assertEq(result, expectedValue, "The value for this daily factor is incorrect!");
    }

    function testDailyFactorDIWithRoundedTDIk() public {
        uint256 _requestId = 1;
        uint256 _diFactor = 1000551310000000000;
        bool hasSpread = true;
        uint256 spreadWad = 0.0100e18; // 1% in WAD
        vm.prank(operator);

        uint256 result = accounting.interestFactorByDay(_requestId, _diFactor, hasSpread, spreadWad);
    }

        function testRealDebentureKnst19() public {
        uint256 requestId = 1;
        uint256 vne = 1e18;
        uint256 _diFactor = 1000551310000000000;
        uint256 spreadWad = 0;
        bool hasSpread;
        if(spreadWad > 0) {
            hasSpread = true;
        }
        uint256 expectedValue = 1001102923942716100;
        vm.startPrank(operator);
        
        (uint256 result, uint256 interest) = accounting.calculateNewUpdatedFactor(requestId, 1000551310000000000, 1000551310000000000, vne, hasSpread, spreadWad);
        vm.stopPrank();
        assertEq(result, expectedValue, "The value for this daily factor is incorrect!");
    }
}


        (uint256 newCwad, uint256 vna) = accounting.calculateIndexFactor(requestId, previousCwad,nik,nik_1,daysNum,daysDen,vne);
        assertEq(result, expectedValue, "The value for this daily factor is incorrect!");
    }

}
