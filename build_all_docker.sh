# Build and push all top-level docker images
for n in $(ls docker )
do
    if test -f "docker/$n/Dockerfile"; then
        echo "Working on $n now"
        docker build -t bboerst/$n:latest docker/$n
        docker push bboerst/$n:latest
    fi
done

# Build and push all tanner docker images
for n in $(ls docker/tanner )
do
    if test -f "docker/tanner/$n/Dockerfile"; then
        echo "Working on $n now"
        docker build -t bboerst/$n:latest docker/tanner/$n
        docker push bboerst/$n:latest
    fi
done