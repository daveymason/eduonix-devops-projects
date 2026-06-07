# Ruby and PHP Web Forms on Docker and Kubernetes

This project is a simple web-form submission project for the Eduonix DevOps coursework. It includes a Ruby version built with Sinatra and a minimal PHP version to satisfy the traditional LAMP-style requirement. Both variants use MySQL for storage, Docker for containerization, and Kubernetes YAML files for deployment.

## Project Contents

- `app.rb` - Ruby Sinatra web form
- `Gemfile` - Ruby dependencies
- `Dockerfile` - container image for the Ruby app
- `php/index.php` - minimal PHP web form
- `php/Dockerfile` - container image for the PHP app
- `docker-compose.yml` - local Docker test setup for MySQL, Ruby, and PHP
- `db/init.sql` - MySQL table creation script
- `k8s/` - Kubernetes manifests for namespace, secret, MySQL, Ruby app, and PHP app

## Local Run With Docker Compose

```bash
cd projects/docker-k8
docker compose up --build
```

Open:

```text
http://localhost:4567
```

For the PHP variant, open:

```text
http://localhost:8081
```

## Kubernetes Deployment

Build and push the app images first, then update the image names in `k8s/app-deployment.yaml` and `k8s/php-deployment.yaml`.

Apply the manifests:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/mysql-init-configmap.yaml
kubectl apply -f k8s/mysql-pvc.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/app-service.yaml
kubectl apply -f k8s/php-deployment.yaml
kubectl apply -f k8s/php-service.yaml
```

Then access the services through your cluster's NodePorts:

- Ruby app: `30080`
- PHP app: `30081`

## Note

This project now includes both a Ruby implementation and a minimal PHP implementation so you can show Docker and Kubernetes delivery while still covering the more traditional PHP/MySQL requirement.