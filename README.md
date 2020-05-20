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
### On the admin node
Note that after upgrading the grid, the following steps needs to be done again.
1. Open port access on the admin node to make use of StorageGRID's Prometheus metrics. Add both of these lines to `/etc/storagegrid-firewall.d/custom.nft`:
```
add element inet sgfilter custom_ports {3000} # Grafana 
add element inet sgfilter custom_ports {9090} # Prometheus
```
* Add the following two lines to `/etc/storagegrid-persistence.d/custom.conf`:
```
/etc/storagegrid-persistence.d/custom.conf
/etc/storagegrid-firewall.d/custom.nft
```
* Restart the service to apply the changes by executing the following commands:
```
service persistence restart
sudo /usr/lib/storagegrid-firewall/configure.sh --full
```
2. Install filebeat by executing the following commands.
```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.7.0-amd64.deb
sudo dpkg -i filebeat-7.7.0-amd64.deb
```
3. Edit the `filebeat.yml` file under `/etc/filebeat`. Change the log path to `/var/local/audit/export/*.log`and logstash output to `<linux-host-ip>:5044`. Finally enable the configuration by setting `enabled` to true. A sample [filebeat.yml](./filebeat.yml) file is also provided.
4. Restart the filebeat service by executing `sudo service filebeat restart`.

## Usage
* Start the stack via `./startup.sh`. (Note that on the first run, it takes longer because it needs to pull images from Docker Hub)
* Start the containers via `./start-container.sh`. Please use this script to start after all containers are successfully created using the `startup.sh`.
* Stop the containers via `./stop-container.sh`.
* Grafana is accessible at `http://<dockerhost>:3000/`, the login credentials are `admin/admin`.
* After initial deployment, log into Grafana, go to `Data Sources`, select `es-sgaudit`, and click `Save & Test` (this tells Grafana to re-validate the data source). You must also select the `sg-prometheus` data source, enter the IP address of the admin node as indicated in the `URL` field, and click `Save & Test`.
* The dashboard will be automatically redployed.
* The current dashboard configuration can be exported via `export-dashboard.sh`, which updates `grafana/dashboards/storagegrid-webscale-monitoring.json`. Please manually fill in the admin password in `export-dashboard.sh` before running the script.

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
