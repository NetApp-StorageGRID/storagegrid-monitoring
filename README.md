# StorageGRID Webscale Monitoring Stack

## Introduction
This repository contains a simple monitoring stack for StorageGRID Webscale. This is not a fully production ready stack.

![alt tag](https://raw.github.com/csiebler/storagegrid-monitoring/master/screenshots/screenshot01.png)

The containerized setup is based on:

* Logstash
* Elasticsearch
* Grafana

## Configuration

1. Your StorageGRID Webscale Audit Logs need to be mounted on the Docker host under `/mnt/auditlogs/`. 
   * If desired, you may specify a path to any directory containing a valid `audit.log` by modifying volume `/mnt/auditlogs:/mnt/auditlogs` in docker-compose.yml to `/desired/directory:/mnt/auditlogs`.
1. Elasticsearch requires alot of memory, so make sure your Docker host provides enough by executing `sysctl -w vm.max_map_count=262144` on the host ([click here](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) for more details).
1. To make use of StorageGRID's Prometheus metrics, open port 9090 on the admin node by executing `run-host-command ufw allow 9090`.


## Usage

* Start the stack via `./startup.sh`.
* Terminate the stack via `./shutdown.sh`.
* Grafana is accessible at `http://<dockerhost>:3000/`, the login credentials are `admin/admin`.
* After initial deployment, log into Grafana, go to `Data Sources`, select `es-sgaudit`, and click `Save & Test` (this tells Grafana to re-validate the data source). You must also select the `sg-prometheus` data source, enter the IP address of the admin node as indicated in the `URL` field, and click `Save & Test`.
* The dashboard will be automatically redployed.
* The current dashboard configuration can be exported via `update-dashboard.sh`, which updates `grafana/dashboards/storagegrid-webscale-monitoring.json`.

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
