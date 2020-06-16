# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
TAG_NAME="Name"
INSTANCE_ID="`wget -qO- http://instance-data/latest/meta-data/instance-id`"
REGION="`wget -qO- http://instance-data/latest/meta-data/placement/availability-zone | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
TAG_VALUE="`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$TAG_NAME" --region $REGION --output=text | cut -f5`"
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority[0].data}' '${var.eks_cluster_name}'  --kubelet-extra-args --node-labels=nodepool="$TAG_VALUE"
USERDATA

}

resource "aws_launch_configuration" "tf_eks" {
  count                       = length(var.worker_names)
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = lookup(var.worker_nodes[count.index], "ami_id")
  instance_type               = lookup(var.worker_nodes[count.index], "instance_type")
  name_prefix                 = join( "-", [ var.eks_cluster_name, lookup(var.worker_nodes[count.index], "name") , "launch_conf" ])
  security_groups             = [aws_security_group.tf-eks-node.id]
  user_data_base64            = base64encode(local.tf-eks-node-userdata)
  key_name                    = lookup(var.worker_nodes[count.index], "key_name")
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_type           = lookup(var.worker_nodes[count.index], "volume_type")
    volume_size           = lookup(var.worker_nodes[count.index], "volume_size")
    delete_on_termination = lookup(var.worker_nodes[count.index], "delete_on_termination")
  }
}

resource "aws_autoscaling_group" "tf_eks" {
  count                = length(var.worker_names)
  desired_capacity     = lookup(var.worker_nodes[count.index], "desired_size")
  launch_configuration = aws_launch_configuration.tf_eks[count.index].id
  max_size             = lookup(var.worker_nodes[count.index], "max_size")
  min_size             = lookup(var.worker_nodes[count.index], "min_size")
  name                 = join( "-", [ var.eks_cluster_name, lookup(var.worker_nodes[count.index], "name"), "asg" ])
  vpc_zone_identifier  = var.vpc_zone_identifier 

  tag {
    key                 = "Name"
    value               = lookup(var.worker_nodes[count.index], "name")
    propagate_at_launch = true
  }

  tag {
    key                 = join("/", ["kubernetes.io", "cluster", var.eks_cluster_name])
    value               = "owned"
    propagate_at_launch = true
  }
}
