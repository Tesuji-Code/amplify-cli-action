#!/bin/bash -l

set -e

if [ -z "$AWS_ACCESS_KEY_ID" ] && [ -z "$AWS_SECRET_ACCESS_KEY" ] ; then
  echo "You must provide the action with both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables in order to deploy"
  exit 1
fi

if [ -z "$AUTHCONFIG" ] ; then
  echo "You must provide AUTHCONFIG environment variables in order to deploy"
  exit 1
fi

if [ -z "$AWS_REGION" ] ; then
  echo "You must provide AWS_REGION environment variable in order to deploy"
  exit 1
fi

if [ -z "$5" ] ; then
  echo "You must provide amplify_command input parameter in order to deploy"
  exit 1
fi

if [ -z "$6" ] ; then
  echo "You must provide amplify_env input parameter in order to deploy"
  exit 1
fi

# cd to project_dir if custom subfolder is specified
if [ -n "$1" ] ; then
  cd "$1"
fi

# if amplify if available at path and custom amplify version is unspecified, do nothing,
# otherwise install globally latest npm version
# FIXME: weird: using local dep amplify-cli bugs with awscloudformation provider: with using provider underfined
if [ -z $(which amplify) ] || [ -n "$8" ] ; then
  echo "Installing amplify globaly"
  npm install -g @aws-amplify/cli@${8}
# elif [ ! -f ./node_modules/.bin/amplify ] ; then
else
  echo "using amplify available at PATH"
# else
#   echo "using local project dependency amplify"
#   PATH="$PATH:$(pwd)/node_modules/.bin"
fi

which amplify
echo "amplify version $(amplify --version)"

case $5 in
  import)
    aws_config_file_path="$(pwd)/aws_config_file_path.json"
    echo '{"accessKeyId":"'$AWS_ACCESS_KEY_ID'","secretAccessKey":"'$AWS_SECRET_ACCESS_KEY'","region":"'$AWS_REGION'","userPoolId":"'$AWS_USER_POOL_ID'","webClientId":"'$AWS_WEB_CLIENT_ID'","nativeClientId":"'$AWS_NATIVE_CLIENT_ID'","identityPoolId":"'$AWS_IDENTITY_POOL'","facebookAppIdUserPool":"'$FACEBOOK_APP_ID'","facebookAppSecretUserPool":"'$FACEBOOK_SECRET'", "googleAppIdUserPool":"'$GOOGLE_APP_ID'", "googleAppSecretUserPool":"'$GOOGLE_SECRET'"}' > $aws_config_file_path
    echo '{"projectPath": "'"$(pwd)"'","defaultEditor":"code","envName":"'$6'"}' > ./amplify/.config/local-env-info.json
    echo '{"'$6'":{"configLevel":"project","useProfile":false,"awsConfigFilePath":"'$aws_config_file_path'"}}' > ./amplify/.config/local-aws-info.json
    
    # if environment doesn't exist fail explicitly
    if [ -z "$(amplify env get --name $6 | grep 'No environment found')" ] ; then
      echo "found existing environment $6"
      amplify env pull --yes $9
    else
      echo "$6 environment does not exist, consider using add_env command instead";
      exit 1
    fi    

    amplify status
    ;;
esac
