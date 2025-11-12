cast wallet address --private-key 0x12d7de8621a77640c9241b2595ba78ce443d05e94090365ab3bb5e19df82c625     cast balance 0x<COINBASE> --rpc-url http://$(kurtosis port print cdks cdk-erigon-rpc-001 rpc)       cast send --legacy \
  --rpc-url $(kurtosis port print cdk-erigon cdk-erigon-rpc-001 rpc) \
  --private-key 0x12d7de8621a77640c9241b2595ba78ce443d05e94090365ab3bb5e19df82c625 \
  --gas-price 0 --gas-limit 21000 --value 1 0xDESTINO


0xE34aaF64b29273B7D567FCFc40544c014EEe9970

function calculatePriceIndexFactor(
    Indexes.Parameters _parameter,   // ex.: IPCA, IGPM
    uint256 _debentureSubId,
    uint256 _timestamp,
    uint256 _requestId,
    int256 _nik,                     // NI_k vindo do oráculo
    int256 _nik_1,                   // NI_{k-1} vindo do oráculo
    uint256 _daysNum,                // dcp / dup
    uint256 _daysDen,                // dct / dut
    uint256 _vne
)
    external
    onlyRole(Roles.OPERATOR)
    returns (uint256 _updatedC, uint256 _vna)
{
    uint256 startOfDayTimestamp = _startOfDayTs(_timestamp);
    require(
        isAccountingDone[_debentureSubId][startOfDayTimestamp] == false,
        "Accounting already done for this day"
    );

    // pega do storage o C acumulado e o último VNA
    MonetaryUpdate storage mu = monetaryUpdateByDebenture[_debentureSubId];

    if (mu.indexFactor == 0) {
        // primeira vez: fator neutro 1.0 em WAD
        mu.indexFactor = 1e18;
        mu.vna = _vne;
    }

    // contrato de cálculo para esse parâmetro (IPCA, IGPM, etc.)
    address contractAddress = calculationContracts[_parameter];
    IPriceIndexCalculator calculator = IPriceIndexCalculator(contractAddress);

    // converte int256 do oráculo para uint256 (assumindo sempre positivo)
    require(_nik > 0 && _nik_1 > 0, "Invalid NI values");
    uint256 nik = uint256(_nik);
    uint256 nik_1 = uint256(_nik_1);

    // chama o contrato de cálculo
    (_updatedC, _vna) = calculator.calculateIndexFactor(
        _requestId,
        mu.indexFactor,
        nik,
        nik_1,
        _daysNum,
        _daysDen,
        _vne
    );

    // atualiza storage
    mu.indexFactor = _updatedC;
    mu.vna = _vna;
    isAccountingDone[_debentureSubId][startOfDayTimestamp] = true;

    return (_updatedC, _vna);
}



 function calculateIndexFactor(
        uint256 /*requestId*/,
        uint256 previousCwad,
        uint256 nik,
        uint256 nik_1,
        uint256 daysNum,
        uint256 daysDen,
        uint256 vne
    )
        external
        pure
        override
        returns (uint256 newCwad, uint256 vna)
    {
        // 1) razao = NI_k / NI_{k-1}
        uint256 razaoWad = (nik * WAD) / nik_1;

        // 2) expoente = diasNum / diasDen (em WAD)
        uint256 expWad = (daysNum * WAD) / daysDen;

        // 3) fator parcial = razao^(diasNum/diasDen)
        uint256 fatorParcial = powApprox(razaoWad, expWad);

        // 4) novo C acumulado
        newCwad = (previousCwad * fatorParcial) / WAD;

        // 5) VNA = VNE * C
        vna = (vne * newCwad) / WAD;
    }


// NI_k (mês de cálculo)
    IOracleIndexes.Indicator memory atual =
        oracleIndexes.getIndicator(oracleIndex, _timestamp);
    require(atual.updatedAt != 0, "Indicator not available (current)");

    // NI_{k-1} (mês anterior) – ou o “mês de aniversário” anterior
    uint256 tsAnterior = previousMonthTimestamp(_timestamp);
    IOracleIndexes.Indicator memory anterior =
        oracleIndexes.getIndicator(oracleIndex, tsAnterior);
    require(anterior.updatedAt != 0, "Indicator not available (previous)");

    // calcula dcp/dct ou dup/dut (aqui simplificado)
    uint256 dcp = daysElapsed(tsAnterior, _timestamp);
    uint256 dct = daysInPeriod(tsAnterior, _timestamp);

    (uint256 factorC, uint256 vna) = accountingManager.calculatePriceIndexFactor(
        debentureToken.bondYield,
        debentureToken.subId,
        _timestamp,
        _requestId,
        atual.value,
        anterior.value,
        dcp,
        dct,
        debentureToken.vne
    );

    debentureContract.updateNominalValue(debentureToken.subId, vna);
    return vna;

funçõe do oracleIndexes

  /// @notice Returns the most recently registered indicator.
    /// @param _index The index for which to retrieve the indicator.
    /// @return The latest indicator including its value and update timestamp.
    function getLatestIndicator(Indexes _index) external view onlyRole(Roles.OPERATOR) returns (Indicator memory) {
        return lastIndicator[_index];
    }

    /// @notice Retrieves the indicator for a specific day.
    /// @dev The timestamp is normalized to the start of the day (00:00 UTC).
    /// @param _index The index for which to retrieve the indicator.
    /// @param _timestamp The timestamp for which to retrieve the indicator.
    /// @return The indicator corresponding to the given day.
    function getIndicator(
        Indexes _index,
        uint256 _timestamp
    ) external view onlyRole(Roles.OPERATOR) returns (Indicator memory) {
        uint256 startOfDayTimestamp = startOfDayTs( _timestamp);
        return indicators[_index][startOfDayTimestamp];
    }

interface IDebentures_Sub {
    struct SubIdData {
        uint256 subId;
        uint256 debentureAmount;
        uint256 vne;
        uint256 dueDate;
        uint256 firstAmortizationDateUnitPrice;
        uint256 settlementDateUnityPrice;
        bool hasMonetaryUpdate;
        Indexes.Parameters bondYield;
        string series;
        uint256 masterDebenturesBond;
        string uriData;
        uint256 lastUpdated;
        uint256 vna;
        uint256 spreadWad;
        Indexes.CalculationType calculationType;
        Indexes.PaymentFee paymentFee;
        Indexes.Repayment repayment;
    }

interface IDebentures_Main {

    struct MainIdData {
        uint256 mainId;
        string debentureId;
        uint256 debentureTotalAmount;
        uint256 issueDateUnityPrice;
        uint256 settlementDateUnityPrice;
        uint256 totalBalanceValue;
        uint256 settlementDate;
        uint256 issueDate;
        DebentureEnums.PaymentFee paymentFeeType;
        uint256 paymentFeeStartDate;
        DebentureEnums.Repayment repayment;
        bool isCompliantWithLaw12431;
        DebentureEnums.DayBasisRemuneration dayBasisRemuneration;
        uint256[] debenturesSeriesList;
        bool isUniqueSeries;
        string uriData;
    }






tem essa lib de calculo
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title DIOverMath - Math utilities for WAD-based financial calculations
/// @notice Provides fixed-point arithmetic and financial functions such as exponentiation, logarithms, and rounding.
library DIOverMath {
    
    // ========= Constants =========
    int256 internal constant WAD = 1e18;
    int256 internal constant HALF_WAD = 5e17;
    uint256 internal constant WAD_TO_2 = 1e16;
    int256 internal constant EPS = 1;
    uint256 internal constant MAX_ITER = 60;
    uint256 internal constant WAD_TO_8 = 1e10;
    uint256 internal constant WAD_TO_9 = 1e9;
    uint256 internal constant WAD_TO_16 = 1e2;
    uint256 internal constant SCALE_8 = 1e8;

    /**
     * @notice Multiplies two WAD values with rounding.
     * @param x First operand in WAD.
     * @param y Second operand in WAD.
     * @return Result of (x * y) / WAD with rounding.
     */
    function mulWad(int256 x, int256 y) internal pure returns (int256) {
        int256 prod = x * y;
        int256 half = prod >= 0 ? HALF_WAD : -HALF_WAD;
        return (prod + half) / WAD;
    }

    /**
     * @notice Divides two integers and returns result in WAD format.
     * @param x Numerator.
     * @param y Denominator.
     * @return Result of (x / y) in WAD.
     */
    function divWad(int256 x, int256 y) internal pure returns (int256) {
        require(y != 0, "DIV_BY_ZERO");
        int256 num = x * WAD;
        int256 half = ((x ^ y) >= 0) ? HALF_WAD : -HALF_WAD;
        return (num + half) / y;
    }

    /**
     * @notice Performs integer division with rounding.
     * @param x Numerator.
     * @param d Denominator.
     * @return Rounded result of x / d.
     */
    function divIntRound(int256 x, int256 d) internal pure returns (int256) {
        require(d != 0, "DIV0");
        int256 q = x / d;
        int256 r = x % d;
        if (r == 0) return q;
        int256 absR = r >= 0 ? r : -r;
        int256 absD = d >= 0 ? d : -d;
        bool sameSign = (x ^ d) >= 0;
        if (absR * 2 >= absD) {
            q += sameSign ? int256(1) : int256(-1);
        }
        return q;
    }

    /**
     * @notice Computes the natural logarithm of a WAD value.
     * @param xWad Input value in WAD.
     * @return Natural logarithm of xWad in WAD.
     */
    function lnWad(uint256 xWad) internal pure returns (int256) {
        require(xWad > 0, "LN_DOMAIN");
        int256 x = int256(xWad);

        int256 t = divWad(x - WAD, x + WAD);
        int256 t2 = mulWad(t, t);
        int256 term = t;
        int256 sum = 0;
        uint256 k = 1;

        for (uint256 i = 0; i < MAX_ITER; i++) {
            int256 add = divIntRound(term, int256(k));
            sum += add;
            int256 absAdd = add >= 0 ? add : -add;
            if (absAdd <= EPS) break;
            term = mulWad(term, t2);
            k += 2;
        }
        return sum * 2;
    }

    /**
     * @notice Computes the exponential of a WAD value.
     * @param z Input value in WAD.
     * @return Exponential of z in WAD.
     */
    function expWad(int256 z) internal pure returns (int256) {
        require(z > -90e18 && z < 90e18, "EXP_RANGE");
        int256 term = WAD;
        int256 sum  = WAD;
        for (uint256 n = 1; n <= MAX_ITER; n++) {
            term = mulWad(term, z);
            term = divIntRound(term, int256(n));
            sum += term;
            int256 absTerm = term >= 0 ? term : -term;
            if (absTerm <= EPS) break;
        }
        return sum;
    }

    /**
     * @notice Computes fractional exponentiation of a WAD value.
     * @param xWad Base value in WAD.
     * @param num Numerator of the exponent.
     * @param den Denominator of the exponent.
     * @return Result of xWad^(num/den) in WAD.
     */
    function powFractionWad(uint256 xWad, uint256 num, uint256 den) internal pure returns (uint256) {
        require(xWad > 0, "POW_DOMAIN");
        require(den != 0, "POW_DEN0");
        int256 yWad = int256((uint256(uint128(uint256(WAD))) * num) / den);
        int256 lnX = lnWad(xWad);
        int256 z = mulWad(yWad, lnX);
        int256 e = expWad(z);
        require(e > 0, "EXP_NEG");
        return uint256(e);
    }

    /**
     * @notice Rounds a WAD rate to 8 decimal places using either classic or custom rounding.
     * @param rateWad Rate in WAD format.
     * @param HALF_UP If true, rounds up if 9th digit >= 5; if false, rounds up only if >= 6.
     * @return Rounded rate in WAD with 8 effective decimals.
     */
    function roundTDIk8_fromWad(uint256 rateWad, bool HALF_UP) internal pure returns (uint256) {
        uint256 base8 = rateWad / WAD_TO_8;
        uint256 ninth = (rateWad / WAD_TO_9) % 10;

        if (HALF_UP) {
            if (ninth >= 5) base8 += 1;
        } else {
            if (ninth >= 6) base8 += 1;
        }
        return base8 * WAD_TO_8;
    }

    /**
     * @notice Computes TDIk = (1 + CDI_aa)^(1/252) - 1, rounded to 8 decimals.
     * @param cdiAaWad Annual CDI rate in WAD format.
     * @param HALF_UP Rounding mode for TDIk.
     * @return TDIk rate in WAD with 8 effective decimals.
     */
    function dailyRateTDIkRounded8FromAnnual(uint256 cdiAaWad, bool HALF_UP) internal pure returns (uint256) {
        uint256 base = uint256(int256(WAD) + int256(cdiAaWad));
        uint256 factor = powFractionWad(base, 1, 252);
        uint256 rateRaw = factor - uint256(int256(WAD));
        return roundTDIk8_fromWad(rateRaw, HALF_UP);
    }

    /**
     * @notice Calculates the updated PU (unit price).
     * @param _vne Nominal value of the debenture.
     * @param _accumulatedInterestFactor Accumulated interest factor in WAD.
     * @return Updated PU in WAD.
     */
    function calculateInterestUnit(
        uint256 _vne,
        uint256 _accumulatedInterestFactor
    ) internal pure returns (uint256) {
        uint256 pu = _accumulatedInterestFactor + _vne;
        require(pu >= 0, "Negative PU");

        return uint256(pu);
    }
}

    
    enum DayBasisRemuneration {
        DiasCorridos365, // 0
        DiasCorridos360, // 1
        DiasUteis252     // 2
    }
}


function orchestrateAccounting(uint256 _debentureSubId, uint256 _requestId, uint256 _timestamp) public onlyRole(Roles.OPERATOR) returns(uint256) {
        DebentureToken.SubIdData memory debentureToken = debentureContract.getDebentureSubInfo(_debentureSubId);

        if (debentureToken.bondYield == Indexes.Parameters.NA) {
            //accountingManager.calculateLinearInterestValue(_requestId);
            return 0;
        }

        if (
            debentureToken.bondYield == Indexes.Parameters.IGPM ||
            debentureToken.bondYield == Indexes.Parameters.IGPDI ||
            debentureToken.bondYield == Indexes.Parameters.IPCM ||
            debentureToken.bondYield == Indexes.Parameters.IPCFIPE ||
            debentureToken.bondYield == Indexes.Parameters.INCCM ||
            debentureToken.bondYield == Indexes.Parameters.INCCDI ||
            debentureToken.bondYield == Indexes.Parameters.INPC ||
            debentureToken.bondYield == Indexes.Parameters.IPCA
        ) {
            IOracleIndexes.Indexes index = mapToOracleIndex(debentureToken.bondYield);
            IOracleIndexes.Indicator memory indicator = oracleIndexes.getIndicator(index, _timestamp);
            
            require(indicator.updatedAt != 0, "Indicator not available!");
            //accountingManager.calculateIndex();
            return 0;
        }

