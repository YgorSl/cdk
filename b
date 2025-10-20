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
