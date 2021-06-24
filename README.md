# supreme-octo-spork

Steps:
1. Clone this repo
2. Add a terraform.tfvars file - example below
3. terraform init
4. terraform apply
5. ansible-playbook -i outputs/inventory --private-key keys/<something>.pem installer.yml

Enjoy!

Example terraform.tfvars
```
aws_region = "eu-west-1"
aws_profile="playground"
aws_tags = { "Application"="Kubernetes", "Environment"="Development", "Owner"="my_email_address" }
aws_vpc_cidr = "10.1.0.0/16"
aws_domain_name = "some.hostedzone.name"
k8s_ingress_class = "contour"
grafana_password = "operator-password"
```

