FROM gradle:4.9-jdk8
COPY --chown=gradle ./ /home/gradle/backend
WORKDIR /home/gradle/backend
ENV GRADLE_USER_HOME=/home/gradle
USER gradle
ARG VERSION=0.1.x
RUN env && gradle build --info --stacktrace
RUN find *

FROM openjdk:8u151
RUN mkdir backend
WORKDIR /backend
ARG VERSION=0.1.x
COPY --from=0 /home/gradle/backend/build/libs/backend-$VERSION.jar /backend/
RUN unzip -q backend-$VERSION.jar && find *

ENTRYPOINT ["java","-XX:+UnlockExperimentalVMOptions","-XX:+UseCGroupMemoryLimitForHeap","-XX:MaxRAMFraction=1","-XshowSettings:vm","-cp", "/backend-config:.","org.springframework.boot.loader.JarLauncher"]