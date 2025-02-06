#!/bin/bash

CONTAINER_NAME="libasm-container"

# Vérifier si le conteneur est en cours d'exécution et le stopper
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "🚀 Le conteneur $CONTAINER_NAME existe déjà. Suppression..."
    docker rm -f "$CONTAINER_NAME"
fi

echo "📦 Création et lancement du conteneur..."
docker run -dit --name "$CONTAINER_NAME" --platform linux/amd64 -v ~/libasm:/app ubuntu:latest

echo "🔧 Installation des dépendances..."
docker exec -it "$CONTAINER_NAME" bash -c "apt update && apt install -y build-essential nasm make gcc"

echo "✅ Tout est prêt ! Connexion au conteneur..."
docker exec -it "$CONTAINER_NAME" bash -c "cd /app && bash"
