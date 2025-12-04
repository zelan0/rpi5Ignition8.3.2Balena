mosquitto_sub -h 10.10.3.166 -p 1883 -t "zigbee2mqtt/bridge/response/
permit_join" -v

 mosquitto_sub -h 10.10.3.166 -p 1883 -t "zigbee2mqtt/bridge/response/permit_join" -v

mosquitto_pub -h 10.10.3.166 -p 1883 -t "zigbee2mqtt/bridge/request/permit_join"   -m '{"value": true, "time": 120}'
