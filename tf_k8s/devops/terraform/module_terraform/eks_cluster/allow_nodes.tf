data "external" "aws_iam_authenticator" {
  program = ["sh", "-c", "aws-iam-authenticator token -i ${var.eks_cluster_name} | jq -r -c .status"]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<EOF
    - rolearn: ${aws_iam_role.tf-eks-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    EOF

   mapUsers = <<EOT
   %{ for  user in var.user_access } 
   - userarn: ${user.arn}
     username: ${user.name}
     groups:
        - ${user.group}
   %{ endfor }
   EOT
   }
  depends_on = [aws_eks_cluster.tf_eks]
}
