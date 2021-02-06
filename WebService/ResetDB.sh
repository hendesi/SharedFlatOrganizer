#!/bin/sh
docker kill mongoDB
docker rm mongoDB
docker run --name mongoDB -e MONGODB_URL=mongodb://localhost:27017/vapor_database -p 27017:27017 -d mongo mongod