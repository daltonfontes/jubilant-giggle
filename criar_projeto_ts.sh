#!/bin/bash

# Função para exibir mensagens em destaque
print_message() {
  message="$1"
  echo "==============================="
  echo "$message"
  echo "==============================="
}

# Função para alterar o nome do projeto
change_project_name() {
  read -p "Digite o novo nome do projeto: " new_name

  # Atualiza o nome do projeto no package.json
  sed -i "s/\"name\": \"[^\"]*\"/\"name\": \"$new_name\"/" package.json

  # Renomeia o diretório do projeto interno
  mv meu_projeto "$new_name"

  # Atualiza o diretório do projeto no tsconfig.json
  sed -i "s/\"outDir\": \"[^\"]*\"/\"outDir\": \"$new_name\/dist\"/" "$new_name/tsconfig.json"

  # Exibe uma mensagem de sucesso
  echo "Nome do projeto alterado para $new_name com sucesso!"
}

# Função para alterar o nome da pasta raiz do projeto
change_project_directory() {
  read -p "Digite o nome do diretório do projeto: " project_directory

  # Cria o diretório do projeto
  mkdir "$project_directory"
  cd "$project_directory"

  # Inicialização do projeto npm
  print_message "Inicializando o projeto npm..."
  npm init -y

  # Instalação do TypeScript e do ts-node (opcional)
  print_message "Instalando TypeScript e ts-node..."
  npm install typescript ts-node --save-dev

  # Criação do arquivo tsconfig.json
  print_message "Criando o arquivo tsconfig.json..."
  echo '{
    "compilerOptions": {
      "target": "es6",
      "module": "commonjs",
      "outDir": "dist",
      "strict": true
    },
    "include": [
      "src/**/*.ts"
    ]
  }' > tsconfig.json

  # Criação do diretório src e arquivo de exemplo
  print_message "Criando o diretório src e o arquivo de exemplo..."
  mkdir src
  echo 'console.log("Hello, TypeScript!");' > src/index.ts

  # Compilação do código TypeScript
  print_message "Compilando o código TypeScript..."
  npx tsc

  # Exemplo de comando para executar o código com ts-node (opcional)
  # npx ts-node src/index.ts

  # Pergunta se deseja alterar o nome do projeto
  read -p "Deseja alterar o nome do projeto? (S/N): " choice
  if [[ $choice =~ ^[Ss]$ ]]; then
    change_project_name
  else
    print_message "Projeto TypeScript criado com sucesso!"
  fi

  # Abre o projeto no Visual Studio Code
  print_message "Abrindo o projeto no Visual Studio Code..."
  code .
}

# Pergunta o nome do diretório do projeto
read -p "Digite o nome do diretório do projeto: " project_directory

# Criação do diretório do projeto e início do script
print_message "Criando o diretório do projeto..."
mkdir "$project_directory"
cd "$project_directory"

change_project_directory
