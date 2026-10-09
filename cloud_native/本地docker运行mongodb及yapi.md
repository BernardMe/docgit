

# 本地docker运行mongodb及yapi

## 本地Docker客户端（Docker CLI）的核心配置文件(config.json)
```
{
   "port": "3000",
   "adminAccount": "yapiadmin@163.com",
   "timeout":120000,
   "db": {
     "servername": "mongodb",
     "DATABASE": "yapi",
     "port": 27017,
     "user": "yapi",
     "pass": "yapi123456",
     "authSource": "admin"
   },
   "mail": {
     "enable": true,
     "host": "smtp.163.com",
     "port": 465,
     "from": "*",
     "auth": {
       "user": "yapiadmin@163.com",
       "pass": "yapiadminpassword"
     }
   }
 }
```

## 本地docker-compose(yaml文件)
```
version: '3.8'

networks:
  yapi-net:
    name: yapi

services:
  mongodb:
    image: mongo:4
    container_name: mongodb
    restart: always
    networks:
      - yapi-net
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=root
    volumes:
      - D:\DOCKER_DATA\mongodb\configdb:/data/configdb
      - D:\DOCKER_DATA\mongodb\db:/data/db
    command: --auth
    # 💡 新增健康检查，确保数据库真的准备好了
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongo localhost:27017/test --quiet
      interval: 5s
      timeout: 5s
      retries: 5
      start_period: 5s

  yapi-init:
    image: yapipro/yapi:1.9.5
    container_name: yapi-init
    networks:
      - yapi-net
    volumes:
      - D:\DOCKER_DATA\yapi\config.json:/yapi/config.json
    working_dir: /yapi/vendors
    command: server/install.js           # 💡 删掉了开头的 node 
    # 💡 严格等待 mongodb 变成 healthy 状态再启动
    depends_on:
      mongodb:
        condition: service_healthy

  yapi:
    image: yapipro/yapi:1.9.5
    container_name: yapi
    restart: always
    networks:
      - yapi-net
    ports:
      - "3000:3000"
    volumes:
      - D:\DOCKER_DATA\yapi\config.json:/yapi/config.json
    working_dir: /yapi/vendors
    command: server/app.js               # 💡 删掉了开头的 node 
    # 💡 严格等待 mongodb 变成 healthy 状态再启动
    depends_on:
      mongodb:
        condition: service_healthy
```
