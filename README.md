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
1. Find the uuid of the file system we created in the previous step by executing `sudo blkid`, then add the following two lines to `/etc/fstab`. After adding these two lines, run `mount -a` to mount the filesystems. If error occurs when mounting the remote file system, please run `/sbin/mount.nfs`.
```
   UUID=<uuid of the file system created in last step> /var/lib/docker xfs defaults 0 0
   <ip address of the admin node>:/var/local/audit/export /mnt/auditlogs nfs hard,intr 0 0
```
1. Install docker and docker-compose

1. Your StorageGRID Webscale Audit Logs need to be mounted on the Docker host under `/mnt/auditlogs/`. 
   * If desired, you may specify a path to any directory containing a valid `audit.log` by modifying volume `/mnt/auditlogs:/mnt/auditlogs` in docker-compose.yml to `/desired/directory:/mnt/auditlogs`.
1. Elasticsearch requires alot of memory, so make sure your Docker host provides enough by executing `sysctl -w vm.max_map_count=262144` on the host ([click here](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) for more details).
### On the admin node
1. Open port 9090 on the admin node by executing `sudo run-host-command ufw allow 9090` to make use of StorageGRID's Prometheus metrics.
2. Use `config_nfs.rb` to export `/var/local/audit/export` to the linux client, the ruby script can be found under `/usr/local/sbin/`.


## Usage
* Start the stack via `./startup.sh`. (Note that on the first run, it takes longer because it needs to pull images from Docker Hub)
* Start the containers via `./start-container.sh`. Please use this script to start after all containers are successfully created using the `startup.sh`.
* Stop the containers via `./stop-container.sh`.
* Grafana is accessible at `http://<dockerhost>:3000/`, the login credentials are `admin/admin`.
* After initial deployment, log into Grafana, go to `Data Sources`, select `es-sgaudit`, and click `Save & Test` (this tells Grafana to re-validate the data source). You must also select the `sg-prometheus` data source, enter the IP address of the admin node as indicated in the `URL` field, and click `Save & Test`.
* The dashboard will be automatically redployed.
* The current dashboard configuration can be exported via `export-dashboard.sh`, which updates `grafana/dashboards/storagegrid-webscale-monitoring.json`. Please manually fill in the admin password in `export-dashboard.sh` before running the script.

## Notes
This is not an official NetApp repository. NetApp Inc. is not affiliated with the posted examples in any way.

## Common Questions
1. An NPE occurs and the elasticsearch container exits with code 78
   * Solution: Execute `sysctl -w vm.max_map_count=262144`
1. `run-host-command` not found
   * Solution: Execute the command under superuser mode

```
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
