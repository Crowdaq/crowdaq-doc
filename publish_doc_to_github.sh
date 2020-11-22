set -e
echo Deploying..
cp -R . /tmp/crowdaq-doc
cd /tmp/crowdaq-doc
rm -rf /tmp/crowdaq-doc/.git
git init
git add -A
git commit -m 'auto deploy'

git push -f git@github.com:Crowdaq/crowdaq-doc.git master
rm -rf /tmp/crowdaq-doc
