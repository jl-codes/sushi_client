# sushi_client

A Flutter client to control [sushi robot](https://github.com/jl-codes/sushi-porter)

To find the address of this robot on your network, run the following command:
```
sudo arp-scan --localnet
```
This device will say 'Espressif Inc.' or something similar -- use this IP address to configure this line:
```
final response = await http.get(Uri.parse('http://192.168.1.201/$command'));
```
Replace this IP address with the correct IP address
