DemandCube Developer Setup
====
- A [NeverwinterDP](https://github.com/DemandCube/NeverwinterDP) and [DemandCube](https://github.com/DemandCube) Project

Copywrite 2013 Steve Morin <steve@stevemorin.com>

Sets a developers machine with a development environment with virtualbox vagrant ansible and pip

setup.sh
====
Installs
- setuptools
- pip
- ansible
- java
- git
- virtualbox
- vagrant

Upgrades if less than version: 
- setuptools
- pip 1.5+
- ansible 1.4.4+
- java 1.7+
- git 1.8+

Installs if not exactly version:
- virtualbox 4.2.16
- vagrant 1.4.3



Notes: Looks to install exact versions of VirtualBox and Vagrant because of compatibility issues with the images.

Preferred Development Tools
----
- [Ansible] (http://www.ansibleworks.com/)
- [Vangrant] (http://www.vagrantup.com/)
- [Virtualbox] (https://www.virtualbox.org/)
- [Gradle] (http://www.gradle.org/)
- [Docker] (https://www.docker.io/)
- CentOS 6.4 x86_64

Charts
----
- [Gliffy] (https://chrome.google.com/webstore/detail/gliffy-diagrams/bhmicilclplefnflapjmnngmkkkkpfad?hl=en)

Research
----
- [Developer Setup Research](RESEARCH.md)

Done:
====
- Mac OS X 10.7
- Mac OS X 10.8

Todo:
====
- Ubuntu 12+
- CentOS 6.4


Keep your fork updated
====
[Github Fork a Repo Help](https://help.github.com/articles/fork-a-repo)


- Add the remote, call it "upstream":

```
git remote add upstream https://github.com/DemandCube/developer-setup.git
```
- Fetch all the branches of that remote into remote-tracking branches,
- such as upstream/master:

```
git fetch upstream
```
- Make sure that you're on your master branch:

```
git checkout master
```
- Merge upstream changes to your master branch

```
git merge upstream/master
```
