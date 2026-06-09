

# 本地docker运行minIO开启HTTPS访问


## 本地生成证书文件(进开发环境使用)
三、如果还是报错，用「交互式生成」（零参数写法，百分百成功）
执行命令（不带 -subj，手动填信息）
bash
运行
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout private.key -out public.crt
按提示依次填写，只在 Common Name 处填你的 IP，其他项直接回车跳过：
plaintext
Country Name (2 letter code) [AU]:  # 直接回车
State or Province Name (full name) [Some-State]: # 直接回车
Locality Name (eg, city) []: # 直接回车
Organization Name (eg, company) [Internet Widgits Pty Ltd]: # 直接回车
Organizational Unit Name (eg, section) []: # 直接回车
Common Name (e.g. server FQDN or YOUR name) []: 192.168.3.149  # 这里填访问IP
Email Address []: # 直接回车
执行完成，自动生成 private.key + public.crt。



docker run -d `
  --name minio `
  -p 9000:9000 `
  -p 9001:9001 `
  -e "MINIO_ROOT_USER=admin" `
  -e "MINIO_ROOT_PASSWORD=Admin@123" `
  -v D:\DOCKER_DIR\minio\data:/data `
  -v D:\DOCKER_DIR\minio\config:/root/.minio `
  minio/minio server /data --console-address ":9001"