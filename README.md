# StorageGRID Monitoring Stack

## Introduction
This repository contains a simple monitoring stack for StorageGRID Webscale. This is not a fully production ready stack.

The containerized setup is based on:

* Logstash
* Elasticsearch
* Grafana

## Configuration

At this point in time, the StorageGRID Audit Logs need to be mounted on the Docker host under `/mnt/auditlogs/`

## Usage

Start the stack with the `./startup.sh` script.
Terminte the stack with the `./shutdown.sh` script.
The dashboard will be automatically redployed from `grafana/dashboards/simple.json` on each start.

Grafana is accessible at `http://<dockerhost>:3000/`, the login credentials are `admin/admin`.

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
