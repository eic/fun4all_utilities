pipeline 
{
	agent any
    
//    environment { 
//        JenkinsBase = 'jenkins/test/'
//    }
       
	stages { 
		stage('Initialize') 
		{
			
            
			steps {
				timestamps {
					ansiColor('xterm') {
																
						script {
						
							currentBuild.displayName = "${env.BUILD_NUMBER} - ${build_type}"
							
						}
										
						dir('fun4all_eicmacros') {
							deleteDir()
						}
						dir('Singularity') {
							deleteDir()
						}

						sh('hostname')
						sh('pwd')
						sh('env')
						sh('ls -lvhc')

					}
				}
			}
		}

		stage('Git Checkout')
		{
			
			steps 
			{
				timestamps { 
					ansiColor('xterm') {
						
						dir('Singularity') {
							
							checkout(
								[
						 			$class: 'GitSCM',
						   		extensions: [               
							   		[$class: 'CleanCheckout'],     
						   		],
							  	branches: [
							    	[name: "*/master"]
							    ], 
							  	userRemoteConfigs: 
							  	[[
							    	//credentialsId: 'sPHENIX-bot', url: 'https://github.com/eic/Singularity.git'
							     	credentialsId: 'sPHENIX-bot', 
							     	url: 'https://github.com/eic/Singularity.git',
							     	refspec: ('+refs/pull/*:refs/remotes/origin/pr/* +refs/heads/master:refs/remotes/origin/master'), 
							    	branch: ('*')
							  	]]
								] //checkout
							)//checkout
						}//						dir('Singularity') {
						
						dir('fun4all_eicmacros') {
							
							checkout(
								[
						 			$class: 'GitSCM',
						   		extensions: [               
							   		[$class: 'CleanCheckout'],     
						   		],
							  	branches: [
							    	[name: "*/master"]
							    ], 
							  	userRemoteConfigs: 
							  	[[
							    	//credentialsId: 'sPHENIX-bot', url: 'https://github.com/eic/fun4all_eicmacros.git'
							     	credentialsId: 'sPHENIX-bot', 
							     	url: 'https://github.com/eic/fun4all_eicmacros.git',
							     	refspec: ('+refs/pull/*:refs/remotes/origin/pr/* +refs/heads/master:refs/remotes/origin/master'), 
							    	branch: ('*')
							  	]]
								] //checkout
							)//checkout
						}//						dir('macros') {
						
					}
				}
			}
		}//stage('SCM Checkout')
		
		// hold this until jenkins supports nested parallel
		//stage('Build')
		//{
		//	parallel {
			
				stage('download')
				{
					steps 
					{
						
						dir('Singularity') {
							sh('pwd')
							sh('ls -lvhc')
							
							sh("./updatebuild.sh -b=${build_type}");
							
							sh('ls -lvhc')
							sh('ls -lvhc cvmfs/')
							sh('du -h --max-depth=1')
						}

		   		}
				}// Stage download
				 
				
				stage('test')
				{
					steps 
					{
						
						//dir('macros/macros/g4simulations/') {
												
						dir('Singularity') {
						
							sh('pwd')
							
							writeFile file: "test.sh", text: """
#! /bin/bash

source /cvmfs/eic.opensciencegrid.org/gcc-8.3/opt/fun4all/core/bin/eic_setup.sh -n new

env;

cd ../fun4all_eicmacros/detectors/EICDetector/
ls -lhvc

root -b -q Fun4All_G4_EICDetector.C

exit \$?
							"""				
							
							sh('chmod +x test.sh')
														
							sh('ls -lvhc')
							
							sh("singularity exec -B cvmfs:/cvmfs cvmfs/eic.opensciencegrid.org/singularity/rhic_sl7_ext.sif ./test.sh");
							
							sh('ls -lvhc')
						}

		   		}
				}// Stage download

	}//stages
		
	post {

		failure {      
        emailext (
            subject: "${currentBuild.currentResult} - Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
	    body: "Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]: ${currentBuild.currentResult}, Check console output at ${env.BUILD_URL}",
            recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
	    to: "jhuang@bnl.gov"
          )
              
		}
		unstable {
        emailext (
            subject: "${currentBuild.currentResult} - Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
      			body: "Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]: ${currentBuild.currentResult}, Check console output at ${env.BUILD_URL}",
            recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']]
          )
          
		}
	}
	
}//pipeline 
