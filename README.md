# StorageGRID Webscale Monitoring Stack

## Introduction
This repository contains a simple monitoring stack for StorageGRID Webscale. This is not a fully production ready stack.

![alt tag](https://raw.github.com/csiebler/storagegrid-monitoring/master/screenshots/screenshot01.png)

The containerized setup is based on:

* Logstash
* Elasticsearch
* Grafana

## Configuration

### On the linux machine
1. Update and install the necessary package with the following commands:
```
   sudo apt-get update
   sudo apt install openssh-server
   sudo systemctl status ssh
   curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
   sudo python3 get-pip.py
   pip --version
```
2. Install docker and docker-compose according to the official documentation [here](https://docs.docker.com/engine/install/ubuntu/) or you can install them with the following commands:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker
sudo docker info | grep Driver
```
* You should be able to see overlay2 driver if the installation is successful.

3. Elasticsearch requires alot of memory, so make sure your Docker host provides enough by executing `sysctl -w vm.max_map_count=262144` on the host ([click here](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) for more details).

4. Replace the `<admin node ip>` in `helper.sh` with the actual ip address of the admin node. 

* Skip the rest steps if there is no security concern adding the public key of the linux machine to the admin node.

5. Create a xfs for the docker image with the following commands:
```
   sudo fdisk /dev/sdb (create partition 1)
	   > type n to create a new partition and assign space for it
   sudo mkfs.xfs /dev/sdb1
   sudo mkdir /var/lib/docker
   sudo mkdir /mnt/auditlogs
```
6. Find the uuid of the file system we created in the previous step by executing `sudo blkid`, then add the following two lines to `/etc/fstab`. After adding these two lines, run `mount -a` to mount the filesystems. If error occurs when mounting the remote file system, please run `/sbin/mount.nfs`.
```
   UUID=<uuid of the file system created in last step> /var/lib/docker xfs defaults 0 0
   <ip address of the admin node>:/var/local/audit/export /mnt/auditlogs nfs hard,intr 0 0
```
### On the admin node
Add the public key of the linux machine to the `authorized_keys` on the admin node. (not required if the directory mounting option is desired)

## Usage
* Start the stack via `./start.sh`. (Note that on the first run, it takes longer because it needs to pull images from Docker Hub)
* Start the containers via `./start-container.sh`. Stop the containers via `./stop-container.sh`.
* Grafana is accessible at `http://<dockerhost>:3000/`, the login credentials are `admin/admin`.
* After initial deployment, log into Grafana, go to `Data Sources`, select `es-sgaudit`, and click `Save & Test` (this tells Grafana to re-validate the data source). You must also select the `sg-prometheus` data source, enter the IP address of the admin node as indicated in the `URL` field, and click `Save & Test`.
* The dashboard will be automatically redployed.
* The current dashboard configuration can be exported via `export-dashboard.sh`, which updates `grafana/dashboards/storagegrid-webscale-monitoring.json`.

## Common Questions
1. An NPE occurs and the elasticsearch container exits with code 78
   * Solution: Execute `sysctl -w vm.max_map_count=262144`
1. `run-host-command` not found
   * Solution: Execute the command under superuser mode
1. Precheck fails when upgrading from 11.3 to 11.4
   * Solution: comment out the two lines added in the `/etc/storagegrid-persistence.d/custom.conf` file, add these two lines after the upgrade.

## Notes
This is not an official NetApp repository. NetApp Inc. is not affiliated with the posted examples in any way.

```
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
