FROM openjdk:8 AS build
ARG KAFKA_MANAGER_VERSION=1.3.3.18

ADD https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.tar.gz .
RUN tar xzf ${KAFKA_MANAGER_VERSION}.tar.gz
WORKDIR kafka-manager-${KAFKA_MANAGER_VERSION}
RUN ./sbt clean dist
RUN unzip -d /tmp target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip


FROM openjdk:8-jre-slim
LABEL maintainer="alexey.miasoedov@gmail.com"

ARG KAFKA_MANAGER_VERSION=1.3.3.18
ENV ZK_HOSTS=localhost:2181

COPY --from=build /tmp/kafka-manager-${KAFKA_MANAGER_VERSION} /kafka-manager

EXPOSE 9000
CMD ["/kafka-manager/bin/kafka-manager"]
