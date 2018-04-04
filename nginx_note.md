

## 配置

### 代理配置
```xml
server {
        listen       8082;
        server_name  smartLink;

        charset utf-8;

        #access_log  logs/host.access.log  main;


		location / {
			root F:\X_Deployment\smartLink\webapp\dist;
			index index.html index.htm;
			try_files $uri /index.html;
		}

        #location / {
        #    proxy_pass        http://127.0.0.1:8000;
        #    proxy_set_header  X-Forwarded-Host   $host;
        #    proxy_set_header  X-Forwarded-Server $host;
        #    proxy_set_header  X-Real-IP        $remote_addr;
        #    proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
         #   proxy_http_version 1.1;
		#	root   html;
		#	index  index.html index.htm;
        #}

		location /manage/ {
            proxy_pass        http://127.0.0.1:8080/manage/;
            proxy_set_header  Host $http_host;
            proxy_set_header  X-Real-IP        $remote_addr;
            proxy_http_version 1.1;
        }


        #error_page  404             /index.html;
        #location = /index.html {
        #    root   /home/tools/weiwen/apache-tomcat-8.5.6/manage;
        #}


        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }

```



