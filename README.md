# StorageGRID Webscale Monitoring Stack

## Introduction
This repository contains a simple monitoring stack for StorageGRID Webscale. This is not a fully production ready stack.

![alt tag](https://raw.github.com/csiebler/storagegrid-monitoring/master/screenshots/screenshot01.png)

The containerized setup is based on:

* Logstash
* Elasticsearch
* Grafana

## Configuration

1. Your StorageGRID Webscale Audit Logs need to be mounted on the Docker host under `/mnt/auditlogs/`
1. Elasticsearch requires quite some memory, so make sure your Docker hosts provides sufficent by executing `sysctl -w vm.max_map_count=262144` on the host ([click here](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) for more details)


## Usage

* Start the stack via `./startup.sh`
* Terminate the stack via `./shutdown.sh`
* Grafana is accessible at `http://<dockerhost>:3000/`, the login credentials are `admin/admin`
* After initial deployment, log into Grafana, then goto `Data Sources`, select `es-sgaudit` and click `Save & Test` (this tells Grafana to re-validate the data source)
* The dashboard will be automatically redployed from `grafana/dashboards/storagegrid-webscale.json`
* The current dashboard configuration can be exported via `update-dashboard.sh`, which updates `grafana/dashboards/storagegrid-webscale.json`

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
