#!/bin/bash

source ./common.sh .

# While Docker 1.9 is not supported in an official RPM it can be built
# using the GitHub releases for trying out the upcoming features

# Allow toggling components to install and update based off flags
updateconsul=1
updatedocker=1
updatedockermachine=1
updatedockercompose=1
updatedockerswarm=1

consulversion="0.5.2"
dockerversion="1.9.0"
dockermachineversion="v0.5.0"
dockercomposeversion="1.5.1"
dockerswarmversion="1.0.1"

echo ""
echo "Updating Consul($updateconsul)"
echo "Updating Docker($updatedocker)"
echo "Updating Docker Machine($updatedockermachine)"
echo "Updating Docker Compose($updatedockercompose)"
echo "Updating Docker Swarm($updatedockerswarm)"

echo ""
echo "Starting Install"
echo ""

if [ $updateconsul -eq 1 ]; then

  echo ""
  echo "Installing Consul version: $consulversion"
  echo ""
  pushd /tmp >> /dev/null
  rm -f /tmp/consul.zip
  rm -f /tmp/consul
  wget https://releases.hashicorp.com/consul/${consulversion}/consul_${consulversion}_linux_amd64.zip -O /tmp/consul.zip
  unzip consul.zip
  cp ./consul /usr/local/bin
  cp ./consul /usr/bin
  rm -f /tmp/consul.zip
  rm -f /tmp/consul
  mkdir /tmp/consul
  chmod 777 /tmp/consul
  popd >> /dev/null
  echo ""
  echo "Done Installing Consul version: $consulversion"
  echo ""
fi

# Docker 1.9 is not shipped in an rpm yet:
if [ $updatedocker -eq 1 ]; then
  echo ""
  echo "Installing Docker version: $dockerversion"
  echo ""
  # To install, run the following command as root:
  curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-${dockerversion} && chmod +x docker-${dockerversion} && mv docker-${dockerversion} /usr/local/bin/docker
  echo ""
  echo "Done Installing Docker version: $dockerversion"
  echo ""
fi

# Now install Docker-Machine: https://github.com/docker/machine/releases/
if [ $updatedockermachine -eq 1 ]; then
  echo ""
  echo "Installing Docker Machine version: $dockermachineversion"
  echo ""
  curl -L https://github.com/docker/machine/releases/download/${dockermachineversion}/docker-machine_linux-amd64.zip >machine.zip && \
  unzip machine.zip && \
  rm machine.zip && \
  mv -f docker-machine* /usr/local/bin
  echo ""
  echo "Done Installing Docker Machine version: $updatedockermachine"
  echo ""
fi

# Now install Docker-Compose: https://github.com/docker/compose/releases/
if [ $updatedockercompose -eq 1 ]; then
  echo ""
  echo "Installing Docker Compose version: $dockercomposeversion"
  echo ""
  curl -L https://github.com/docker/compose/releases/download/${dockercomposeversion}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  echo ""
  echo "Done Installing Docker Compose version: $updatedockercompose"
  echo ""
fi

# Now install Docker-Swarm: https://github.com/docker/swarm/releases
if [ $updatedockerswarm -eq 1 ]; then
  echo ""
  echo "Installing Docker Swarm version: $dockerswarmversion"
  echo ""
  pushd /opt >> /dev/null
  if [ ! -e $goworkspacepath ]; then
      mkdir $goworkspacepath >> /dev/null
      chmod 777 $goworkspacepath >> /dev/null
  fi
  if [ ! -e $goworkspacepath/bin ]; then
      mkdir $goworkspacepath/bin >> /dev/null
      chmod 777 $goworkspacepath/bin >> /dev/null
  fi

  sudo yum install -y go
  echo " - Using GOPATH($GOPATH) set this in ./common.sh if you want to override"
  export GOPATH=$goworkspacepath
  mkdir -p $GOPATH/src/github.com/docker/
  cd $GOPATH/src/github.com/docker/
  git clone https://github.com/docker/swarm
  cd swarm
  $GOPATH/bin/godep go install .
  chmod 777 $GOPATH/bin/swarm

  rm -f /usr/local/bin/swarm >> /dev/null
  ln -s $GOPATH/bin/swarm /usr/local/bin/swarm

  pushd >> /dev/null
  echo ""
  echo "Done Installing Docker Swarm version: $updatedockerswarm"
  echo ""
fi

exit 0

