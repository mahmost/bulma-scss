#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION=${1:-master} # e.g. 0.0.18
#rm -rf $DIR/../bulma
cd $DIR/..
#git clone https://github.com/jgthms/bulma.git
cd $DIR/../bulma
#git reset --hard
git checkout master
git pull
git fetch origin --tags
git checkout $VERSION
find . -name '*.sass' -exec sass-convert -F sass -T scss '{}' '{}.temp' \;
find . -name '*.sass.temp' -exec sh -c 'x="{}"; dir=$(dirname $x) name="$(basename $x)"; name=${name/.sass.temp/}; mv "$x" "$dir/_$name.scss"' \;
cd $DIR/..
rm -rf dist
mkdir -p dist
cp -a bulma/sass dist
cp bulma/_bulma.scss dist
sed -i -e "s/_all/__all/g" dist/_bulma.scss
find dist/ -name *.scss | xargs sed -i -e "s/\.sass//g"
cd $DIR/../bulma
# git reset --hard
find $DIR/../dist -name '*.sass' -type f -delete
find $DIR/../dist -name '*.temp.scss' -type f -delete
find . -name '*.scss' -type f -delete
