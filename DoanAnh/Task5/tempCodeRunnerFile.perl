log_format custom_log '"Request: $request\n Status: $status\n Request_URI: $request_uri\n Host: $host\n Client_IP: $remote_addr\n Proxy_IP(s): $proxy_add_x_forwarded_for\n Proxy_Hostname: $proxy_host\n Real_IP: $http_x_real_ip\n User_Client: $http_user_agent"';


server {

    listen 80;
    server_name wordpress.training.vn laravel.training.vn;

        access_log /var/log/nginx/custom-access-log.log custom_log;

        proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              add_header Test_header tidiay;


    location / {
        proxy_pass http://172.16.204.132:80;

    }

}
