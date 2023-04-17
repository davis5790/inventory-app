resource "aws_iam_role" "inventory-pipeline-role" {
  name = "inventory-pipeline-role"

  assume_role_policy = data.aws_iam_policy_document.inventory-pipeline-assume-document.json
}

data "aws_iam_policy_document" "inventory-pipeline-assume-document" {
  statement {
    sid = "AllowWebIdentityAssumeRole"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
        type = "Federated"
        identifiers = ["arn:aws:iam::606026656431:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
        test = "StringEquals"
        variable = "token.actions.githubusercontent.com:aud"
        values = ["sts.amazonaws.com"]
    }
  }

   statement {
    actions = [
      "sts:TagSession",
      "sts:AssumeRole"
    ]

    principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::606026656431:user/davis5790"]
    }
  }
}