data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_ec2_role" {
  name                = "iam_for_ec2"
  assume_role_policy  = data.aws_iam_policy_document.policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

resource "aws_iam_instance_profile" "iam_for_ec2_instance_profile" {
  name = "test_profile"
  role = aws_iam_role.iam_for_ec2_role.name
}
