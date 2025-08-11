# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-alpine

# Accept dynamic JAR path
ARG JAR_FILE

# Copy the JAR from subdirectory
COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
