
data "aws_iam_policy_document" "kms_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncrypt*"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:events:${local.region}:${local.account_id}:event-bus/*"]
    }
  }
}

module "eventbus_kms_key" {
  source     = "registry.terraform.io/SevenPicoForks/kms-key/aws"
  version    = "2.0.0"
  context    = module.example_context.self
  attributes = ["kms", "key"]

  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  description              = "KMS key for ${module.example_context.id}"
  key_usage                = "ENCRYPT_DECRYPT"
  multi_region             = false
  policy                   = ""
}
