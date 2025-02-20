echo -n "Removing logs..."
rm -rf log_*
#sleep 3s  # Waits 3 seconds.
counter=0
while [[ "$counter" -lt 3 ]]
do
  sleep 1s
  echo -n "."
  : $((counter++))
done

echo "" # new line
echo "Starting Redis Stack Server..."
nohup docker run --rm -p 6379:6379 --network=rasa-network --name redis-stack-server redis/redis-stack-server:latest 0</dev/null > log_redis.out 2>&1 &
echo "Starting Mitundu Action server..."
nohup docker run --rm -p 5055:5055 --network=rasa-network --name action_server -e RASA_TELEMETRY_ENABLED=false mitundu-action_server:latest </dev/null > log_mitundu_action.out 2>&1 &
echo "Starting Duckling..."
nohup docker run --rm -p 8000:8000 --network=rasa-network --name duckling rasa/duckling 0</dev/null > log_duckling.out 2>&1 &
echo "Starting vector database..."

nohup docker run --rm -p 8001:8000 --network=rasa-network --name chromadb -v ./chroma:/chroma/chroma -e ALLOW_RESET=TRUE -e IS_PERSISTENT=TRUE -e ANONYMIZED_TELEMETRY=FALSE -e CHROMA_SERVER_NOFILE="1048576" chromadb/chroma 0</dev/null >log_chromadb.out 2>&1 &

nohup docker run --rm -p 5005:5005 --network=rasa-network --name rasa_server -e RASA_TELEMETRY_ENABLED=false mitundu-rasa:latest 0</dev/null >  log_mitundu.out 2>&1 &

echo -n "Starting Mitundu  core and Mitundu NLU..."
#-n to surpress new line
#sleep 10s  # Waits 10 seconds. Thand requires the vector db connection t be fully established
counter=0
while [[ "$counter" -lt 10 ]] 
do
  sleep 1s
  echo -n "."
#  if [[ $counter -gt 10 ]] ; then
#       exit 0
#  fi
  : $((counter++))
done

echo "" # new line

# Start Thandi
nohup docker run --rm -p 5000:5000 --network=rasa-network --add-host=ollamaserver:10.1.1.209 --name thandi -e PYTHONUNBUFFERED=0 thandi 0</dev/null > log_thandi.out 2>&1 &

echo -n "Starting  Thandi core..."

#We will wait  for about 20 seconds, mitundu takes some time to load
#sleep 10s  # Waits 10 seconds.
counter=0
while [[ "$counter" -lt 10 ]]
do
  sleep 1s
  echo -n "."
  : $((counter++))
done


echo ""	# new line

#Cosmetic wait for mitundu to complete 30s (total boot time)
echo -n "Cleaning up..."
counter=0
while [[ "$counter" -lt 10 ]]
do
  sleep 1s
  echo -n "."
  : $((counter++))
done

echo "" # new line
echo "Done!"
