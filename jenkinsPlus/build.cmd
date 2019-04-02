docker build . -t xjboss/jenkinsplus
rem docker run --rm -p 8081:8080 -p 50000:50000 -t -i xjboss/jenkinsplus
rem docker run --rm -t -i xjboss/jenkinsplus bash
docker run --rm -p 8081:8080 -p 50000:50000 -t -i xjboss/jenkinsplus
docker push xjboss/jenkinsplus