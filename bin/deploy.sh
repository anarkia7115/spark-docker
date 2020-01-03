tar --exclude='*spark-docker.tar.gz' --exclude='.git*' -vzcf spark-docker.tar.gz ../spark/  
scp ./spark-docker.tar.gz app13:workspace/
ssh app13 " cd workspace && mkdir -p dockers/ && rm dockers/spark -rf && tar -vzxf ./spark-docker.tar.gz -C dockers/"
