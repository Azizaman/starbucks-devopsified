# DevSecOps – Starbucks App

## DevSecOps Steps

- Dockerfile ==> Done
- SonarQube
- Trivy
- CI/CD

### 1) Create the Docker image with the multi-stage Docker build

- Dockerfile created using multi-stage build

### 2) SonarQube

- Install SonarQube for testing the code
- Use SonarQube Docker image:
```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```
- Download the SonarQube Scanner from the official website and unzip it:
```bash
unzip sonar-scanner-8.0.1.6346-linux-x64.zip
```
- Move Sonar Scanner to `/opt`:
```bash
sudo mv sonar-scanner-8.0.1.6346-linux-x64/ /opt/sonar-scanner
```
- Add Sonar Scanner to PATH:
```bash
echo "export PATH=$PATH:/opt/sonar-scanner/bin" >> ~/.bashrc 
source ~/.bashrc
```
- Verify installation:
```bash
yronar-scanner --version
```
- Copy the scan command from the SonarQube dashboard and run it:
```bash
yronar-scanner \
  -Dsonar.projectKey=starbucks-app \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=sqp_02ff9339cdf47e7d4187cd69cd250de5edec44b5
```
- Go to the SonarQube dashboard to view the results.

### 3) Trivy

Trivy is used to scan Docker images and source code.
Trivy is used via Docker image.

#### Build Docker Image:
```bash
docker build -t azizaman/starbucks-app:latest .
```
#### Scan Docker Image:
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
aquasec/trivy:latest \
target image azizaman/starbucks-app:latest
```
or alternatively:
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
aquasec/trivy:latest \
target image --severity HIGH,CRITICAL azizaman/starbucks-app:latest
```
#### Scan Source Code (run from project root):
```bash
docker run --rm \
  -v $(pwd):/project \
aquasec/trivy:latest \
fS /project
```
or alternatively:
```bash
docker run --rm \
  -v $(pwd):/project \
aquasec/trivy:latest \
fS --severity HIGH,CRITICAL /project
```
#### Trivy in CI/CD Pipeline:
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
aquasec/trivy:latest \
target image --exit-code 1 --severity HIGH,CRITICAL azizaman/starbucks-app:latest
```