# amplify-cli-action

[![RELEASE](https://img.shields.io/github/v/release/Tesuji-Code/amplify-cli-action?include_prereleases)](https://github.com/Tesuji-Code/amplify-cli-action/releases)
[![View Action](https://img.shields.io/badge/view-action-blue.svg?logo=github&color=orange)](https://github.com/marketplace/actions/amplify-cli-action-sh)
[![LICENSE](https://img.shields.io/github/license/Tesuji-Code/amplify-cli-action)](https://github.com/Tesuji-Code/amplify-cli-action/blob/master/LICENSE)
[![ISSUES](https://img.shields.io/github/issues/Tesuji-Code/amplify-cli-action)](https://github.com/Tesuji-Code/amplify-cli-action/issues)
  
🚀 :octocat: AWS Amplify CLI support for github actions. This action supports configuring and deploying your project to AWS as well as creating and undeploying amplify environments.

## Getting Started
You can include the action in your workflow as `actions/amplify-cli-action@0.4.5`. Example (configuring amplify, building and deploying):

```yaml
name: 'Amplify Deploy'
on: [push]

jobs:
  test:
    name: test amplify-cli-action
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [10.x]

    steps:
    - uses: actions/checkout@v1

    - name: use node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}

    - name: configure amplify
      uses: Tesuji-Code/amplify-cli-action@0.4.5
      with:
        amplify_command: import
        amplify_env: prod
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AUTHCONFIG: ${{ secrets.AUTHCONFIG }}
        AWS_REGION: us-east-1

    - name: install, build and test
      run: |
        npm install
        # build and test
        # npm run build
        # npm run test
    
```
