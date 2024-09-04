
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

data "aws_iam_policy_document" "eventbus_kms_key_policy" {
  count = module.example_context.enabled ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:ReEncrypt*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:ListKeys",
      "kms:ListAliases"
    ]
    resources = ["*"]
  }
}