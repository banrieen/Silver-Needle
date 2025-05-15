#!/bin/bash
#=========================================================================================================================
# Info: Sphinx Docs 文档服务
# Creator: banrieen
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. Static docs services
# 2. Pack as a executed standalone file.
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

# Install pip
## wget https://bootstrap.pypa.io/get-pip.py
## python3 get-pip.py
# Create python virtualenv
pip3 install virtualenv 
python3 -m virtualenv SphinxEnv
source SphinxEnv/bin/activate
## deactivate
## Init new doc 
## sphinx-quickstart
## Or use template repo
cd docs-template-repo
mkdir -p ./build/zh_CN
## Install plugin 
pip3 install  sphinx_markdown_tables myst_parser  pydata_sphinx_theme sphinx-press-theme sphinxcontrib-mermaid
## Build static site
sphinx-build -b html docs/zh_CN ./build/zh_CN
sphinx-build -b html docs/zh_CN ./build/html
cp -r  docs/zh_CN/static/video/*.mp4 build/zh_CN/_images/
## Clean build folder 
## rm -rf build/zh_CN/*

## Build a node application using express.js web server, then you can compile the code and assets into an exe file using the the pkg module
## Using the pkg module you can bundle your node application to run on windows, mac or linux.

sudo zypper install nodejs
corepack enable
yarn set version stable
      


###-------------------------------------------------
npm install -g nativefier
nativefier --single-instance --name DocDemo  file:///C:/Users/Admin/workspace/AiStudioDocs/build/html/index.html  --internal-urls '.*?udemy.*?'  --file-download-options '{"saveAs": true}'  --widevine
  

## ffmpeg can output high quality GIF. Before you start it is always recommended to use a recent version: download or compile.
### ffmpeg -ss 30 -t 3 -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output.gif

