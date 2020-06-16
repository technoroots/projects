# Using Base image alpine with installed python3
FROM frolvlad/alpine-python3

MAINTAINER "Mayank Singh"

ARG BUILD_SERVE_PORT
ARG BUILD_MONGO_URI
ARG BUILD_FLASK_ENV

ENV SERVE_PORT=$BUILD_SERVE_PORT
ENV MONGO_URI=$BUILD_MONGO_URI
ENV FLASK_ENV=$BUILD_FLASK_ENV
ENV FLASK_CONFIG=$BUILD_FLASK_ENV

#choosing /usr/src/app as working directory
WORKDIR /usr/src/app

# Mentioned python module name to run application
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Exposing applicaiton on 80 so that it can be accessible on 80
EXPOSE $SERVE_PORT

#Copying code to working directory
COPY . .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
