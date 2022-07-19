#!/usr/bin/env bash

HANDLER="$1"
DEPFILES="$JAR_DIR/*:$JAR_DIR/lib/*"
echo "HANDLER: $HANDLER"
echo "DEPFILES: $DEPFILES"
echo "Files in $JAR_DIR"
for FILE in $JAR_DIR/*; do 
	echo $FILE; 
done

echo "Files in $JAR_DIR/lib/"
for FILE in $JAR_DIR/lib/*; do 
	echo $FILE; 
done

#if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
#    exec /usr/bin/aws-lambda-rie java -cp "$DEPFILES" "com.amazonaws.services.lambda.runtime.api.client.AWSLambda" "$HANDLER"
#else
	exec java -classpath "$DEPFILES" "com.amazonaws.services.lambda.runtime.api.client.AWSLambda" "$HANDLER"
#fi
