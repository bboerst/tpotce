for n in $(ls docker )
do
    if test -f "docker/$n/Dockerfile"; then
        echo "Working on $n now"
        docker build -t bboerst/$n:latest docker/$n
        docker push bboerst/$n:latest
    fi
done
