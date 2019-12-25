# base image
FROM swr.cn-north-4.myhuaweicloud.com/gaojx/openjdk:8-jdk-stretch

# build args
ARG HW_BUCKET
ARG AK
ARG SK

ENV HW_OBS_TOOLS obs://$HW_BUCKET/tools
ENV HW_OBS_JARS  obs://$HW_BUCKET/jars
ENV AK $AK
ENV SK $SK


# define spark and hadoop versions
ENV HW_OBS_ENDPOINT obs.cn-north-4.myhwclouds.com
ENV HADOOP_VERSION 2.7.7
ENV SPARK_VERSION 2.4.4
ENV HADOOP_GZ "hadoop-$HADOOP_VERSION.tar.gz"
#ENV SPARK_GZ "spark-$SPARK_VERSION-gaojx.tar.gz"
ENV SPARK_GZ "spark-2.4.4-bin-without-hadoop-scala-2.12.tgz"
ENV JAVA_GZ "jdk-1.8.tar.gz"
ENV HADOOP_HOME "/opt/hadoop"

ADD ./obsutil /usr/local/bin
RUN obsutil config -i $AK -k $SK -e $HW_OBS_ENDPOINT

# download and install java
RUN mkdir -p /opt && \
    cd /opt && \
    obsutil cp $HW_OBS_TOOLS/$JAVA_GZ . && \
    tar -xzf $JAVA_GZ && \
    rm $JAVA_GZ

ENV JAVA_HOME "/opt/jdk1.8.0_101"

ENV PATH $JAVA_HOME/bin:$PATH

# download and install hadoop
RUN mkdir -p /opt && \
    cd /opt && \
    obsutil cp $HW_OBS_TOOLS/$HADOOP_GZ . && \
    tar -zxf $HADOOP_GZ && \
    ln -s hadoop-${HADOOP_VERSION} hadoop && \
    echo Hadoop ${HADOOP_VERSION} native libraries installed in /opt/hadoop/lib/native && \
    rm $HADOOP_GZ

ENV HADOOP_HOME /opt/hadoop

ENV TAR_OPT "--strip 1"
# download and install spark
RUN obsutil cp $HW_OBS_TOOLS/$SPARK_GZ /
RUN mkdir -p /opt/spark && cd /opt/spark && \
    tar -zxf /$SPARK_GZ $TAR_OPT && \
    echo Spark ${SPARK_VERSION} installed in /opt && \
    rm /$SPARK_GZ

ENV spark_jars /opt/spark/assembly/target/scala-2.11/jars/
RUN obsutil cp $HW_OBS_TOOLS/aws-java-sdk-1.7.4.2.jar $spark_jars
RUN obsutil cp $HW_OBS_TOOLS/hadoop-aws-2.7.7.jar $spark_jars

# add hw mirrors
RUN echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m" && \
    cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
ADD ./sources.list /etc/apt/sources.list

# test tools
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y netcat net-tools telnet

# submit jars
#RUN mkdir -p /jars
#RUN obsutil cp $HW_OBS_JARS/pubmed-streaming-0.0.3-SNAPSHOT.jar /jars/
#ADD ./pubmed-streaming-0.0.3-SNAPSHOT.jar /jars/


# add scripts and update spark default config
ARG FILE_CHANGE
# ADD common.sh spark-master spark-worker /
# ADD spark-defaults.conf spark-env.sh log4j.properties spark-env-worker.sh spark-defaults-worker.conf /opt/spark/conf/
# ENV PATH $PATH:/opt/spark/bin
