FROM tutum/tomcat:latest
COPY dbtest /tomcat/webapps/dbtest

#优化运行环境

##启动文件优化
RUN  sed -i '1a JAVA_OPTS="$JAVA_OPTS -server -Xms2048m -Xmx2048m -XX:MaxNewSize=256m  -XX:PermSize=128M -XX:MaxPermSize=512m -Xss512k"' /tomcat/bin/catalina.sh

##配置文件优化
RUN  sed -i '/<Connector port="8080"/a   maxThreads="800" acceptCount="1000" maxPostSize="0" URIEncoding="UTF-8"' /tomcat/conf/server.xml
RUN  sed -i 's/port="8009"/port="8009"  maxThreads="800" acceptCount="1000" maxPostSize="0" URIEncoding="UTF-8"/' /tomcat/conf/server.xml

##开启链接池,关闭非链接池配置


###开启线程池
####删除匹配行的上一行
RUN sed -i 'N;/\n.*tomcatThreadPool/!P;D' /tomcat/conf/server.xml
####删除匹配行的下一行
RUN sed -i '/minSpareThreads/{n;/-->/d}' /tomcat/conf/server.xml
RUN sed -i '/redirectPort/{n;/-->/d}' /tomcat/conf/server.xml
###关闭非线程池配置
RUN sed -i '/<Connector port="8080"/,/\/>/d' /tomcat/conf/server.xml

###优化线程池配置
####<Executor name="tomcatThreadPool" namePrefix="catalina-exec-"  maxThreads="800" minSpareThreads="1000" />
RUN  sed -i '/<Executor name="tomcatThreadPool"/,/\/>/{s/150/800/}' /tomcat/conf/server.xml
RUN  sed -i '/<Executor name="tomcatThreadPool"/,/\/>/{s/4/1000/}' /tomcat/conf/server.xml
####<Connector executor="tomcatThreadPool" port="80" protocol="HTTP/1.1"  connectionTimeout="20000"
#### enableLookups="false" redirectPort="8443" URIEncoding="UTF-8" acceptCount="1000" />
RUN  sed -i '/Connector executor="tomcatThreadPool"/a \nenableLookups="false" URIEncoding="UTF-8" acceptCount="1000"' /tomcat/conf/server.xml



##正则表达式编辑xml,增加应用部署目录
RUN  sed -i '/<Host/,/<\/Host>/{/<Valve/,/<\/Valve>/{/pattern=/{s/\/>/\/> \n <Context docBase="\/home\/test" path="\/test" crossContext="true" privileged="true" \/>/}}}' /tomcat/conf/server.xml



#清除管理用户
#RUN  sed -i '/<tomcat-users>/,/<\/tomcat-users>/d' /tomcat/conf/tomcat-users.xml

#删除注释文件
RUN sed -i '/<!–/,/–>/d' /tomcat/conf/server.xml
RUN sed -i '/<!–/,/–>/d' /tomcat/conf/tomcat-users.xml

#集群session配置
