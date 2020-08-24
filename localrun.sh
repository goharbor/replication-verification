#!/bin/bash

python -m robot.run --help > /dev/null
if [ "$?" != "251" ] || [ "$?" == "127" ]; then
  echo will install robot framework relatives.
  sleep 1
  set -xe
  sudo apt install -y chromium-browser python-pip libnss3-tools unzip graphicsmagick
  sudo pip install -r requirements.txt
  sudo bash -c "wget -Nq http://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    chmod a+x chromedriver && ls -l && \
    mv -f chromedriver /usr/local/share/chromedriver && \
    ln -f -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
    rm -f chromedriver_linux64.zip"
  set +x
fi

if [ "$4" == "" ];then echo 'localrun.sh <case name> <harbor IP> <registry_id:xxx> <registry_key:xxx> [true to show browser]' ; exit 1;fi
if [ ! -f master/cases/$1.robot ];then echo "can not find case master/cases/$1"; fi
if ! curl -L -k -f https://$2/api/v2.0/systeminfo ;then echo Harbor $2 is not ready; fi
sudo mkdir -p /etc/docker/certs.d/$2/
openssl s_client -connect $2 -showcerts < /dev/null 2>/dev/null |openssl x509 -outform PEM | sudo tee /etc/docker/certs.d/$2/ca.crt
cd master/cases
repo=$(echo mybusybox-${1} | tr 'A-Z' 'a-z')
../../create-image.sh $repo:${1} || exit 1
rm -f *.png checkpoint.txt
set -x
python -u -m robot.run -v shown:${5-false} -v ip:$2 -v repo:${repo} -v tag:${1} \
    -v $3 -v $4 \
    $1.robot
set +x
../../save-record.sh
echo ckeck master/cases/record.gif
num=$(grep good checkpoint.txt|wc -l||echo 0)
if [ "$num" == 4 ];then echo case is good;else echo case failed with $num passed;exit 1;fi
