2015-01-22
    更换tomcat镜像包;
    优化tomcat配置：内存、线程池、用户安全、脚本部署；
    调试脚本：停止，删除；重构，启动；查看日志；
        fig stop && fig rm --force -v && fig build && fig up -d && fig ps && fig logs

    完成tomcat集群配置，memcached进行session缓存，暂不支持tomcat8.

2015-01-21
    更换mysql 镜像包
    使用基于debian系统镜像包。
    change mysql images to debian-mysql

# Docker Java/MySQL Tomcat Sample
This is a simple Java application with MySQL.

# Run

## Fig
* `fig up -d`

Then run `fig ps` to find the app port.

## Standalone

* `docker run -d -P -e MYSQL_USER=java -e MYSQL_PASSWORD=java -e MYSQL_DATABASE=javatest --name mysql orchardup/mysql`
* `docker run -ti --rm --link mysql:mysql -v $(pwd):/host --entrypoint /bin/bash orchardup/mysql -c "sleep 4; mysql -u java --password=java -h mysql javatest < /host/init.sql; exit 0"`
* `docker build -t javatest .`
* `docker run -ti -P --rm --link mysql:mysql javatest`

* `docker run -d -P -e MYSQL_USER=java -e MYSQL_PASSWORD=java -e MYSQL_DATABASE=javatest --name mysql mysql`
* `docker run -ti --rm --link mysql:mysql -v $(pwd):/host --entrypoint /bin/bash mysql -c "sleep 4; mysql -u java --password=java -h mysql javatest < /host/init.sql; exit 0"`


You should be able to access the app on http://\<docker-host-ip\>:\<app-port\>/dbtest
