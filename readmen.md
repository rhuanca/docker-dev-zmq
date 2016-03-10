build:
docker build -t devzmq .

run:
docker run -d -p 1022:22 devzmq

connect:
ssh root@localhost -p 1022
