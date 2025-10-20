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

