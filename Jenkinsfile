pipeline {

  environment {
  PROJECT_DIR = "/app"
  REGISTRY = "jhsparta/new_calc"
  DOCKER_CREDENTIALS = "Docker_Auth"
  DOCKER_IMAGE = ""
  }

  agent any

  options {
    skipStagesAfterUnstable()
  }

  stages{

    stage('Cloning Code From Git') {
      steps{
        git branch: 'main',
        url: 'https://github.com/JHigz/CyberSecuritySparta/tree/calc_full_infra/calc_full_infra'
      }

    }

    stage('Build-Image'){
      steps {
        script{
          DOCKER_IMAGE = docker.build REGISTRY
        }
      }
    }

    stage('Deploy to Docker Hub'){
      steps{
        script{
          docker.withRegistry('', DOCKER_CREDENTIALS){
            DOCKER_IMAGE.push()
          }
        }
      }
    }

    stage('Removing the Docker Image'){
      steps {
        sh "docker rmi $REGISTRY"
      }
    }
  }
}
