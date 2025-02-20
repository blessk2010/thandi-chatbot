echo -n "Stoping containers..."
#sleep 3s  # Waits 3 seconds.
counter=0
while [[ "$counter" -lt 3 ]]
do
  sleep 1s
  echo -n "."
  : $((counter++))
done
echo ""
docker stop $(docker ps -a -q)

systemctl restart docker
systemctl restart nginx
echo "Done!"
docker ps
