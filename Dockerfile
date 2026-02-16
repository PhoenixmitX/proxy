FROM eclipse-temurin:25-jdk AS builder
WORKDIR /build

COPY . .
RUN ./gradlew --no-daemon :proxy:jar
RUN cp proxy/build/libs/*.jar /build/numdrassl.jar

FROM eclipse-temurin:25-jre AS runtime

RUN groupadd --system numdrassl && useradd --system --gid numdrassl --create-home --home-dir /home/numdrassl numdrassl
WORKDIR /home/numdrassl

COPY --from=builder /build/numdrassl.jar /home/numdrassl/numdrassl.jar
RUN chown numdrassl:numdrassl /home/numdrassl/numdrassl.jar

USER numdrassl

ENTRYPOINT ["java", "-jar", "/home/numdrassl/numdrassl.jar"]
