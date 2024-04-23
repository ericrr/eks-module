# Learn Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks), containing
Terraform configuration files to provision an EKS cluster on AWS.


VPCID = vpc-00518c2a9a260c7aa

subnets = 
us-east-1a = subnet-01b6cbce2edd44292
us-east-1b = subnet-0cd8576c3e3694188
us-east-1c = subnet-0c76bf04a38076f55




https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/deploy/installation/
wget https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml
kubectl apply -f crds.yaml

just change // to / in the link:
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master" - >
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html


curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.0/docs/install/iam_policy.json
{
    "Statement": [
        {
            "Action": [
                "ec2:DescribeVpcs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInstances",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeregisterTargets"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}


nginx

https://aws.amazon.com/pt/blogs/containers/exposing-kubernetes-applications-part-3-nginx-ingress-controller/



kubectl config get-contexts arn:aws:eks:us-east-1:831417397093:cluster/manager > /tmp/manager.kubeconfig
kubectl config get-contexts arn:aws:eks:us-east-1:831417397093:cluster/worker01 > /tmp/worker01.kubeconfig
kubectl config get-contexts arn:aws:eks:us-east-1:831417397093:cluster/worker02 > /tmp/worker02.kubeconfig


k0="kubectl --kubeconfig /tmp/manager.kubeconfig"
k1="kubectl --kubeconfig /tmp/worker01.kubeconfig"
k2="kubectl --kubeconfig /tmp/worker02.kubeconfig"


Please use 'kubectl config use-context karmada-host/karmada-apiserver' to switch the host and control plane cluster.

kubectl config use-context arn:aws:eks:us-east-1:831417397093:cluster/manager

~/.kube/config

./remote-up-karmada.sh ~/.kube/config arn:aws:eks:us-east-1:831417397093:cluster/manager


helm upgrade --install karmada -n karmada-system --create-namespace --dependency-update --cleanup-on-fail ./charts/karmada --set components={"descheduler"}

kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type==\"ExternalIP\")].address}' --kubeconfig=kubeconfig-cluster-manager

kubectl get secret karmada-kubeconfig --kubeconfig=kubeconfig-cluster-manager -n karmada-system -o jsonpath={.data.kubeconfig} | base64 -d > karmada-config



$ kubectl get secret -n karmada-system karmada-kubeconfig -o jsonpath={.data.kubeconfig} | base64 -d

https://aws.amazon.com/pt/blogs/containers/exposing-kubernetes-applications-part-3-nginx-ingress-controller/

https://github.com/terraform-aws-modules/terraform-aws-eks
https://github.com/terraform-iaac/terraform-helm-nginx-controller/blob/master/locals.tf


Grafana
https://getbetterdevops.io/terraform-with-helm/

kubectl port-forward --namespace monitoring svc/grafana 3000:80
$ kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-user}" | base64 --decode 
$ kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode

