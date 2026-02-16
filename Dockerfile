FROM eclipse-temurin:25-jdk AS builder
WORKDIR /build

COPY . .
RUN ./gradlew --no-daemon :proxy:jar
RUN cp proxy/build/libs/*.jar /build/numdrassl.jar

FROM eclipse-temurin:25-jre AS runtime

RUN groupadd --system numdrassl && useradd --system --gid numdrassl --create-home --home-dir /home/numdrassl numdrassl

COPY --from=builder --chown=numdrassl:numdrassl /build/numdrassl.jar /home/numdrassl/numdrassl.jar
RUN mkdir -p /home/numdrassl/proxy && chown numdrassl:numdrassl /home/numdrassl/proxy

USER numdrassl
WORKDIR /home/numdrassl/proxy

ENTRYPOINT ["java", "-jar", "/home/numdrassl/numdrassl.jar"]
