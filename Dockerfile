# 使用 CentOS 7 作为基础镜像
FROM centos:7

# 安装依赖软件包
RUN yum update -y && \
    yum install -y \
    wget \
    tar \
    which \
    && yum clean all

# 复制 RPM 包到容器中
COPY PolarDB-O-0200-2.0.2-20211017205225.alios7.x86_64.rpm /tmp/



# 安装 PolarDB RPM 包
WORKDIR /tmp
RUN yum localinstall PolarDB-O-0200-2.0.2-20211017205225.alios7.x86_64.rpm -y && \
    rm -f PolarDB-O-0200-2.0.0-20200611.alios7.x86_64.rpm

# 创建数据库启动账号
RUN groupadd polardb && \
    useradd -g polardb polardb

RUN mkdir -p /polardb && \
    chown -R polardb:polardb /polardb

# 切换到 polardb 用户
USER polardb

# 创建数据目录并初始化数据库
RUN mkdir -p /polardb/polardb_data && \
    export LD_LIBRARY_PATH=/usr/local/polardb_o_current/lib:$LD_LIBRARY_PATH && \
    /usr/local/polardb_o_current/bin/initdb -D /polardb/polardb_data

# 修改配置文件
RUN sed -i 's/#max_connections = 100/max_connections = 300/' /polardb/polardb_data/postgresql.conf
RUN sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /polardb/polardb_data/postgresql.conf
RUN echo "host all all 0.0.0.0/0 md5" >> /polardb/polardb_data/pg_hba.conf

# 设置启动命令
#CMD ["/usr/local/polardb_o_current/bin/pg_ctl", "-D", "/polardb/polardb_data", "-l", "start"]
CMD ["/bin/sh", "-c", "/usr/local/polardb_o_current/bin/pg_ctl -D /polardb/polardb_data -l /polardb/polardb_data/polardb.log start && tail -f /dev/null"]

# /usr/local/polardb_o_current/bin/psql -U polardb -p 5444 -d postgres
# ALTER USER polardb WITH PASSWORD 'WVCmFZs841@';

