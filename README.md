# Build
docker build --rm=true -t myjenkins .

# Run
docker run --name myjenkins -p 8081:8080 -p 50001:50000 myjenkins