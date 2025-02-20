# thandi-chatbot
This is a chatbot with multi stage processing of requests using RASA, OLLAMA, and Chromadb and the client developed in angular.
# Requirements
- RASA
- Ollama
  - llama3.2:3b
  - bge-m3:latest
  - Redis
- Spacy for both RASA project and Ollama

# (1) First folder named mitundu
- Contains RASA project created using anaconda.
- Navigate to that folder and run below command to build action server and mitundu core docker images
     docker-compose up --build
- Once images are created launch the action-server and the mitundu core in separate terminals
- For action server run
  nohup docker run --rm -p 5055:5055 --network=rasa-network --name action_server -e RASA_TELEMETRY_ENABLED=false mitundu-action_server:latest >log_mitundu_action.out &
- For mitundu core
  nohup docker run --rm -p 5005:5005 --network=rasa-network --name rasa_server -e RASA_TELEMETRY_ENABLED=false mitundu-rasa:latest > log_mitundu.out &

# (2) Second is the thandi folder
- Contains API created in Flask for
  - Creating populating vector db (Chromadb) with pdf data
  - Querying LLM using the data
- This implements RAG architechiture using Ollama, Redis as cache, Chroma DB
- Build thandi docker image by running below command while in the thandi folder
  docker build -f Dockerfile -t thandi .

# (3) Chatbot landing-page folder
- Contains angular project that holds chatbot UI
- This can be substituted with any UI
- Launch the project using below commands
  npm ci
  ng serve
# Set up chroma db image
- Pull chromadb docker image
# Instructions.
After building the mitundu-rasa core and action server, and thandi docker images, downloading ollama and LLMs, and chromadb, installing nginx for the UI
- Use the provided script to start and stop all services, assuming you are on ubuntu.
- Edit the configuration as per your setup.
