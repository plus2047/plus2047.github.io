# update from https://github.com/TMaize/tmaize-blog

# cd ..
# git clone https://github.com/TMaize/tmaize-blog

set -ex

rm -rf _includes _layouts _site pages static
cp -r ../tmaize-blog/{_includes,_layouts,_site,pages,static} ./
cp ../{404.md,_config.yml,blog.sh,index.html,service-worker.js} ./
