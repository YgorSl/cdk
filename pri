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






