#!/bin/sh

children=""
for version in $(ls -1 nginx)
do
  tmpFile=$(mktemp --tmpdir=. "nginx$version.XXX.log")
  docker build --pull --no-cache -t "45air/nginx:$version" "nginx/$version" > $tmpFile 2>&1 &
  pid="$!"
  echo "Building $version (PID $pid, output in $tmpFile)..."
  children+=" $version:$pid"
done

exitcode=0
errorMsg="The following versions failed:"
for versions in $children
do
	pid=${versions##*:}
	ver=${versions%%:*}
	if wait $pid ; then
		rm nginx$ver.*.log
	else
		errorMsg+=" $ver"
		exitcode=$(($exitcode+1))
	fi
done

if (( $exitcode > 0 )); then
	2>&1 echo $errorMsg
	exit $exitcode
fi

echo "Pushing image..."
docker push 45air/nginx:latest > /dev/null 2>&1 &
wait
