me mande a interface de indices com base na de cdi


pragma solidity ^0.8.24;

/// @title IAccountingDI - Interface for AccountingDI contract
/// @notice Provides methods for calculating daily interest factors and updated PU values for debentures.
interface IAccountingDI {

    /// @notice Emitted when daily interest factor is calculated.
    /// @param requestId Unique identifier for tracking the calculation.
    /// @param timestamp Block timestamp when the calculation was performed.
    /// @param tdik Daily CDI rate (TDIk) rounded to 8 decimals.
    /// @param fatorDI Daily DI factor truncated to 16 decimals.
    /// @param fatorSpread Spread factor (9 decimals if applicable, otherwise 1e18).
    /// @param fatorJuros Final daily interest factor (DI * Spread), truncated to 16 decimals.
    event DailyInterestFactorCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 tdik,
        uint256 fatorDI,
        uint256 fatorSpread,
        uint256 fatorJuros
    );

    /// @notice Emitted when updated PU is calculated.
    /// @param requestId Unique identifier for tracking the calculation.
    /// @param timestamp Block timestamp when the calculation was performed.
    /// @param pu Updated PU value in WAD.
    event updatedPuCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 pu
    );

    /// @notice Emitted when updated PU is calculated.
    /// @param requestId Unique identifier for tracking the calculation.
    /// @param timestamp Block timestamp when the calculation was performed.
    /// @param previousFactor The previous DIFactor received.
    /// @param newFactor The new DIFactor calculated.
    /// @param interest The unit interest for the calculation.
    event factorCalculated(
        uint256 requestId,
        uint256 timestamp,
        uint256 previousFactor,
        uint256 newFactor,
        uint256 interest
    );

    /// @notice Returns the TDIk (daily CDI rate) rounded to 8 decimal places.
    /// @param cdiAaWad Annual CDI rate in WAD format.
    /// @param halfUp If true, uses classic half-up rounding; if false, uses custom rounding rule.
    /// @return TDIk rounded to 8 decimals (WAD with 10 trailing zeros).
    function tdikRounded8(uint256 cdiAaWad, bool halfUp) external view returns (uint256);

    /// @notice Returns the raw daily factor without rounding.
    /// @param cdiAaWad Annual CDI rate in WAD format.
    /// @return Daily factor in WAD.
    function dailyFactor(uint256 cdiAaWad) external view returns (uint256);

    /// @notice Returns the daily factor including TDIk rounded to 8 decimals.
    /// @param cdiAaWad Annual CDI rate in WAD format.
    /// @return Daily factor in WAD with only 8 effective decimals.
    function dailyFactorRounded(uint256 cdiAaWad) external view returns (uint256);

    /// @notice Returns the raw TDIk rate (daily CDI rate) without rounding.
    /// @param cdiAaWad Annual CDI rate in WAD format.
    /// @return Raw TDIk rate in WAD.
    function dailyRateRaw(uint256 cdiAaWad) external view returns (uint256);

    /// @notice Calculates the precise spread factor without rounding.
    /// @param spreadWad Annual spread rate in WAD format.
    /// @return Spread factor in WAD.
    function spreadFactorPrecise(uint256 spreadWad) external view returns (uint256);

    /// @notice Calculates the daily interest factor (DI + Spread) and emits event with tracking.
    /// @param requestId Unique identifier for tracking the calculation.
    /// @param cdiAaWad Annual CDI rate in WAD format.
    /// @param percentualCDI CDI percentage applied (e.g., 95 for 95%).
    /// @param hasSpread Whether the debenture has spread.
    /// @param spreadWad Annual spread rate in WAD format.
    /// @return Daily interest factor in WAD truncated to 16 decimals.
    function dailyInterestFactor(
        uint256 requestId,
        uint256 cdiAaWad,
        uint256 percentualCDI,
        bool hasSpread,
        uint256 spreadWad
    ) external returns (uint256);

    /// @notice Calculates the updated PU (unit price) and emits event with tracking.
    /// @param requestId Unique identifier for tracking the calculation.
    /// @param vne Nominal value of the debenture.
    /// @param accumulatedInterestFactor Accumulated interest factor in WAD.
    /// @return Updated PU in WAD.
    function updatedPu(
        uint256 requestId,
        uint256 vne,
        uint256 accumulatedInterestFactor
    ) external returns (uint256);

    
    /**
     * @notice Calculates the new accumulated interest factor based on the previous factor and today's DI factor.
     * @param _requestId The ID used to fetch or identify the current day's data.
     * @param _previousAccumulatedFactor The previously accumulated interest factor (in WAD).
     * @param _diFactor The DI factor for the current day (in WAD).
     * @param _vne The Nominal Issue Value for the given debenture.
     * @param _hasSpread Boolean indicating whether a spread should be applied.
     * @param _spreadWad The spread value in WAD (e.g., 0.005 * 1e18 for 0.5%).
     * @return updatedFactor The new accumulated interest factor (in WAD).
     * @return interest The interest accrued for the day (in WAD).
     */
    function calculateNewUpdatedFactor(
        uint256 _requestId,
        uint256 _previousAccumulatedFactor,
        uint256 _diFactor,
        uint256 _vne,
        bool _hasSpread,
        uint256 _spreadWad
    ) external returns (uint256 updatedFactor, uint256 interest);

}


a de indices esta assim:

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {DebentureEnums} from "../lib/DebentureEnums.sol";

interface IAccountingIndexes {


     /// @notice Calcula o fator acumulado C e o novo VNA
    /// @dev Fórmula: C = Cprev * (NI_k / NI_{k-1})^(daysNum / daysDen)
    /// @param requestId id lógico da operação (não usado aqui, apenas p/ tracking)
    /// @param previousCwad fator acumulado anterior (1e18 = 1.0)
    /// @param nik número-índice do mês atual (NI_k)
    /// @param nik_1 número-índice do mês anterior (NI_{k-1})
    /// @param currentTimestamp dcp ou dup (dias decorridos)
    /// @param birthday dct ou dut (total de dias no ciclo)
    /// @param vne valor nominal base
    /// @param basis valor nominal base
    function calculateIndexFactor(
        uint256 requestId,
        uint256 previousCwad,
        uint256 nik,
        uint256 nik_1,
        uint256 currentTimestamp,
        uint256 birthday,
        uint256 vne,
        DebentureEnums.DayBasisRemuneration basis
    ) external pure returns (uint256 , uint256 );
}

