FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
# Download all required dependencies into one layer
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/sistem-manajemen-sekolah-*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"] 