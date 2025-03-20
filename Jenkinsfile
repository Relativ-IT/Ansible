pipeline {
  triggers {
    cron(env.BRANCH_NAME == 'main' ? '@weekly' : '')
  }

  agent {
    label 'Linux && Buildah'
  }

  environment{
    IMAGE = "ansible"
    TAG = "latest"
    FULLIMAGE = "${env.IMAGE}:${env.TAG}"
  }

  stages {
    stage('Initialize') {
      parallel {
        stage('Advertising start of build') {
          steps{
            slackSend color: "#4675b1", message: "${env.JOB_NAME} build #${env.BUILD_NUMBER} started :fire: (<${env.RUN_DISPLAY_URL}|Open>)"
          }
        }

        stage('Print environments variables') {
          steps {
            sh 'printenv | sort'
          }
        }

        // stage('Print Podman infos') {
        //   steps {
        //     sh '''
        //       podman version
        //       podman system info
        //     '''
        //   }
        // }
      }
    }

    stage('Building image') {
      steps {
        sh 'Buildah build --pull -t $REGISTRY_LOCAL/$FULLIMAGE .'
      }
    }

    // stage('Testing image') {
    //   steps {
    //     sh '''
    //       Buildah run --rm --image-volume ignore --entrypoint \'["ansible","--version"]\' $REGISTRY_LOCAL/$FULLIMAGE
    //       Buildah run --rm --image-volume ignore --entrypoint \'["ansible-playbook","--version"]\' $REGISTRY_LOCAL/$FULLIMAGE
    //       Buildah run --rm --image-volume ignore --entrypoint \'["ansible-galaxy","--version"]\' $REGISTRY_LOCAL/$FULLIMAGE
    //       Buildah run --rm --image-volume ignore --entrypoint \'["ansible-vault","--version"]\' $REGISTRY_LOCAL/$FULLIMAGE
    //      '''
    //   }
    // }

    stage('Pushing image') {
      steps {
        sh 'Buildah push $REGISTRY_LOCAL/$FULLIMAGE'
      }
    }
  }

  post {

    success {
      slackSend color: "#4675b1", message: "${env.JOB_NAME} successfully built :blue_heart: !"
    }

    failure {
      slackSend color: "danger", message: "${env.JOB_NAME} build failed :poop: !"
    }
    
    cleanup {
      cleanWs()
    }
  }
}
