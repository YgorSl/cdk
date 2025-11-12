// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {DIOverMath} from "./DIOverMath.sol";
import {IPriceIndexCalculator} from "./IPriceIndexCalculator.sol";

/// @title PriceIndexCalculator
/// @notice Calcula o fator acumulado C e o novo VNA (Valor Nominal Atualizado)
///         baseado na fórmula da CETIP para índices de preços.
contract PriceIndexCalculator is IPriceIndexCalculator {
    using DIOverMath for uint256;

    uint256 private constant WAD = 1e18;

    /// @notice Calcula o fator acumulado e o novo valor nominal atualizado.
    /// @dev Fórmula CETIP:
    ///      Cnovo = Cprev * (NI_k / NI_{k-1})^(daysNum/daysDen)
    ///      VNA   = VNE * Cnovo
    /// @param requestId Id da operação (somente para rastreamento / logs)
    /// @param previousCwad Fator acumulado anterior (Cprev em WAD)
    /// @param nik Número-índice atual (NI_k)
    /// @param nik_1 Número-índice anterior (NI_{k-1})
    /// @param daysNum Dias corridos entre última data de aniversário e cálculo (dcp)
    /// @param daysDen Dias corridos totais do período (dct)
    /// @param vne Valor nominal base (PU de emissão)
    /// @return newCwad Novo fator acumulado (Cnovo)
    /// @return vna Valor nominal atualizado (VNA)
    function calculateIndexFactor(
        uint256 requestId,
        uint256 previousCwad,
        uint256 nik,
        uint256 nik_1,
        uint256 daysNum,
        uint256 daysDen,
        uint256 vne
    ) external pure override returns (uint256 newCwad, uint256 vna) {
        require(nik > 0 && nik_1 > 0, "Invalid NI values");
        require(daysDen > 0, "Invalid denominator");

        // 1️⃣ razão (NI_k / NI_{k-1}) em WAD
        uint256 ratioWad = DIOverMath.divWad(int256(nik), int256(nik_1)) >= 0
            ? uint256(DIOverMath.divWad(int256(nik), int256(nik_1)))
            : 0;

        // 2️⃣ aplica expoente fracionário (daysNum / daysDen)
        uint256 fatorMensalWad = DIOverMath.powFractionWad(ratioWad, daysNum, daysDen);

        // 3️⃣ novo fator acumulado (Cprev * fator)
        newCwad = uint256(DIOverMath.mulWad(int256(previousCwad), int256(fatorMensalWad)));

        // 4️⃣ valor nominal atualizado (VNA = VNE * C)
        vna = (vne * newCwad) / WAD;
    }
}
