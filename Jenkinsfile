pipeline {
    agent {
        label 'hmdaops'
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'hmda/ruby:hub'
                    reuseNode true
                }
            }
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'cfpbhmdadeploybot-github',
                        usernameVariable: 'GIT_DEPLOY_USERNAME', passwordVariable: 'GIT_DEPLOY_PASSWORD']]) {
                        sh '''
                        gem install bundler:1.17.3
                        bundle install
                        bundle exec middleman build --clean
                        git clone https://github.com/cfpb/hmda-platform.git || true
                        cd hmda-platform
                        git fetch origin
                        git checkout gh-pages
                        git checkout -b jenkinsPages${BUILD_NUMBER}
                        cd ../build
                        cp -r fonts ../hmda-platform
                        cp -r images ../hmda-platform
                        cp -r javascripts ../hmda-platform
                        cp -r stylesheets ../hmda-platform
                        cp index.html ../hmda-platform
                        cd ../hmda-platform
                        git add .
                        git commit -m 'jenkinsbuild api-docs'
                        git remote rm origin
                        git remote add origin https://${GIT_DEPLOY_USERNAME}:${GIT_DEPLOY_PASSWORD}@github.com/cfpb/hmda-platform.git
                        git push origin jenkinsPages${BUILD_NUMBER}
                        '''
                        mattermostSend( 
                            channel: "hmda-jenkins-build-alerts",
                            color: 'good', 
                            failOnError: true,
                            icon: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
                            text: 'API Docs Pushed',
                            message: "[Open PR Here](https://github.com/cfpb/hmda-platform/compare/gh-pages...jenkinsPages${BUILD_NUMBER})"
                    
                        )
                    }
                }
            }
        }
    }

}
