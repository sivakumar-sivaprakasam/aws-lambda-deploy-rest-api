# We use a Java 12 image, but any image could serve as a base image.
FROM openjdk:11

# Add the lambda-runtime-interface-emulator to enable local testing.
#ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
#RUN chmod +x /usr/bin/aws-lambda-rie

# Add the entrypoint script.
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Add the JAR to a known path.
ENV JAR_DIR="/jar"
ADD target/lib $JAR_DIR/lib
COPY target/classes/helloworld.jar $JAR_DIR
#COPY target/lib ${JAR_DIR}/lib
#COPY target/classes ${JAR_DIR}/classes

# Set our
CMD [ "com.example.helloworld.StreamLambdaHandler::handleRequest" ]