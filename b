[root@srv-blkcstdes01 docker-autocompose]# docker network inspect kt-cdk | grep -E '"Name"|IPv4Address|Gateway' -n
3:        "Name": "kt-cdk",
16:                    "Gateway": "172.16.0.3"
29:                "Name": "el-1-geth-lighthouse--5a5d0964472540c28c30e27eaf73a6bd",
32:                "IPv4Address": "172.16.0.2/22",
36:                "Name": "cl-1-lighthouse-geth--4454af5d8ed7421989d616ca5f9a7cb3",
39:                "IPv4Address": "172.16.0.4/22",
43:                "Name": "kurtosis-reverse-proxy--4e822194c151414caaa99c2512679fad",
46:                "IPv4Address": "172.16.0.1/22",


[root@srv-blkcstdes01 docker-autocompose]# docker exec -it cl-1-lighthouse-geth--4454af5d8ed7421989d616ca5f9a7cb3 sh -lc 'getent hosts el-1-geth-lighthouse || true'
Error response from daemon: container a6113703630cad6b926df78ad9e42add193fe6a9432dc7fa953368c08e29a880 is not running


 docker logs cl-1-lighthouse-geth--4454af5d8ed7421989d616ca5f9a7cb3 | grep -E "execution|engine|connected"

{"info":"The execution endpoint is connected and configured, however it is not yet synced","level":"WARN","module":"client::notifier:397","msg":"Not ready Bellatrix","ts":"2025-10-20T19:46:00.001905Z"}
{"info":"ensure the execution endpoint is updated to the latest Electra/Prague release","level":"INFO","module":"client::notifier:546","msg":"Ready for Electra","ts":"2025-10-20T19:46:00.002089Z"}
{"info":"The execution endpoint is connected and configured, however it is not yet synced","level":"WARN","module":"client::notifier:397","msg":"Not ready Bellatrix","ts":"2025-10-20T19:46:02.001670Z"}
{"info":"ensure the execution endpoint is updated to the latest Electra/Prague release","level":"INFO","module":"client::notifier:546","msg":"Ready for Electra","ts":"2025-10-20T19:46:02.001751Z"}
[root@srv-blkcstdes01 docker-autocompose]# docker logs el-1-geth-lighthouse--5a5d0964472540c28c30e27eaf73a6bd
{"t":"2025-10-20T19:23:07.545133925Z","lvl":"info","msg":"HTTP server started","endpoint":"[::]:8551","auth":true,"prefix":"","cors":"localhost","vhosts":"*"}
{"t":"2025-10-20T19:23:07.563541659Z","lvl":"info","msg":"Started P2P networking","self":"enode://c3ed39a5261b78c6db49dbf43b4fab94cc12316bb66b764764e8380c24fee5282e2e42ba0ccfde8e45b95df9da55f7ad41b5de98cb9965c6473cee1c093f10fc@172.16.0.12:30303"}
{"t":"2025-10-20T19:23:07.564492139Z","lvl":"info","msg":"Started log indexer"}
{"t":"2025-10-20T19:23:42.521702504Z","lvl":"warn","msg":"Beacon client online, but no consensus updates received in a while. Please fix your beacon client to follow the chain!"}
{"t":"2025-10-20T19:28:42.55656255Z","lvl":"warn","msg":"Beacon client online, but no consensus updates received in a while. Please fix your beacon client to follow the chain!"}
{"t":"2025-10-20T19:33:42.589947914Z","lvl":"warn","msg":"Beacon client online, but no consensus updates received in a while. Please fix your beacon client to follow the chain!"}
{"t":"2025-10-20T19:38:42.629839213Z","lvl":"warn","msg":"Beacon client online, but no consensus updates received in a while. Please fix your beacon client to follow the chain!"}
{"t":"2025-10-20T19:43:42.680774686Z","lvl":"warn","msg":"Beacon client online, but no consensus updates received in a while. Please fix your beacon client to follow the chain!"}
[root@srv-blkcstdes01 docker-autocompose]#


{"current_epoch":113296,"err":"FailedToDownloadAttesters(\"Some endpoints failed, num_failed: 2 http://cl-1-lighthouse-geth:4000/ => RequestFailed(HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out)), http://cl-1-lighthouse-geth:4000/ => RequestFailed(HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out))\")","level":"ERROR","module":"validator_services::duties_service:738","msg":"Failed to download attester duties","request_epoch":113296,"ts":"2025-10-20T20:05:45.005994Z"}
{"available":0,"level":"ERROR","module":"validator_services::notifier_service:69","msg":"No synced beacon nodes","synced":0,"total":1,"ts":"2025-10-20T20:05:46.001418Z"}
{"epoch":113296,"level":"INFO","module":"validator_services::notifier_service:143","msg":"Awaiting activation","slot":906374,"ts":"2025-10-20T20:05:46.002287Z","validators":64}
{"endpoint":"http://cl-1-lighthouse-geth:4000/","error":"HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out)","level":"ERROR","module":"beacon_node_fallback:293","msg":"Unable to read spec from beacon node","ts":"2025-10-20T20:05:47.321715Z"}
{"endpoint":"http://cl-1-lighthouse-geth:4000/","error":"Offline","level":"WARN","module":"beacon_node_fallback:533","msg":"A connected beacon node errored during routine health check","ts":"2025-10-20T20:05:47.322646Z"}
{"available":0,"level":"ERROR","module":"validator_services::notifier_service:69","msg":"No synced beacon nodes","synced":0,"total":1,"ts":"2025-10-20T20:05:48.001531Z"}
{"epoch":113296,"level":"INFO","module":"validator_services::notifier_service:143","msg":"Awaiting activation","slot":906375,"ts":"2025-10-20T20:05:48.003711Z","validators":64}



[root@srv-blkcstdes01 docker-autocompose]# docker exec -it vc-1-geth-lighthouse--1e310aef61c74de1bf123e9f72d28b24 sh -lc 'getent hosts cl-1-lighthouse-geth || true'
172.16.0.4      cl-1-lighthouse-geth
[root@srv-blkcstdes01 docker-autocompose]# docker exec -it vc-1-geth-lighthouse--1e310aef61c74de1bf123e9f72d28b24 curl -s http://cl-1-lighthouse-geth:4000/eth/v1/node/identity
OCI runtime exec failed: exec failed: unable to start container process: exec: "curl": executable file not found in $PATH: unknown
[root@srv-blkcstdes01 docker-autocompose]# docker logs -f vc-1-geth-lighthouse--1e310aef61c74de1bf123e9f72d28b24  


{"err":"Some endpoints failed, num_failed: 2 http://cl-1-lighthouse-geth:4000/ => RequestFailed(HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out)), http://cl-1-lighthouse-geth:4000/ => RequestFailed(HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out))","level":"ERROR","module":"validator_services::duties_service:1377","msg":"Failed to download proposer duties","ts":"2025-10-20T20:25:17.005558Z"}
{"available":0,"level":"ERROR","module":"validator_services::notifier_service:69","msg":"No synced beacon nodes","synced":0,"total":1,"ts":"2025-10-20T20:25:18.001273Z"}
{"epoch":113370,"level":"INFO","module":"validator_services::notifier_service:143","msg":"Awaiting activation","slot":906960,"ts":"2025-10-20T20:25:18.002128Z","validators":64}
{"endpoint":"http://cl-1-lighthouse-geth:4000/","error":"HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out)","level":"ERROR","module":"beacon_node_fallback:293","msg":"Unable to read spec from beacon node","ts":"2025-10-20T20:25:18.256204Z"}
{"endpoint":"http://cl-1-lighthouse-geth:4000/","error":"Offline","level":"WARN","module":"beacon_node_fallback:533","msg":"A connected beacon node errored during routine health check","ts":"2025-10-20T20:25:18.256594Z"}
{"error":"Some endpoints failed, num_failed: 1 http://cl-1-lighthouse-geth:4000/ => RequestFailed(HttpClient(url: http://cl-1-lighthouse-geth:4000/, kind: timeout, detail: operation timed out))","level":"ERROR","module":"validator_services::preparation_service:342","msg":"Unable to publish proposer preparation to all beacon nodes","ts":"2025-10-20T20:25:19.003347Z"}
{"available":0,"level":"ERROR","module":"validator_services::notifier_service:69","msg":"No synced beacon nodes","synced":0,"total":1,"ts":"2025-10-20T20:25:20.001800Z"}
{"epoch":113370,"level":"INFO","module":"validator_services::notifier_service:143","msg":"Awaiting activation","slot":906961,"ts":"2025-10-20T20:25:20.001939Z","validators":64}


o curl ficou rodando um tempo sem resposta e cancelei
[root@srv-blkcstdes01 docker-autocompose]# curl -s http://127.0.0.1:32803/eth/v1/node/identity
^C
[root@srv-blkcstdes01 docker-autocompose]# docker exec -it vc-1-geth-lighthouse--1e310aef61c74de1bf123e9f72d28b24 bash -lc 'exec 3<>/dev/tcp/cl-1-lighthouse-geth--4454af5d8ed7421989d616ca5f9a7cb3:4000 && echo OK || echo FAIL' 2>/dev/null
bash: line 1: /dev/tcp/cl-1-lighthouse-geth--4454af5d8ed7421989d616ca5f9a7cb3:4000: No such file or directory
FAIL
[root@srv-blkcstdes01 docker-autocompose]# ^C
[root@srv-blkcstdes01 docker-autocompose]#


[root@srv-blkcstdes01 docker-autocompose]# docker exec -it vc-1-geth-lighthouse--1e310aef61c74de1bf123e9f72d28b24 bash -lc 'exec 3<>/dev/tcp/127.0.0.1/4000 && echo OK || echo FAIL'
bash: connect: Connection refused
bash: line 1: /dev/tcp/127.0.0.1/4000: Connection refused
FAIL

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


