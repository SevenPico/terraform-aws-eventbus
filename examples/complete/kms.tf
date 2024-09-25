data "aws_iam_policy_document" "kms_policy" {
  count = module.example_context.enabled ? 1 : 0
  statement {
    sid    = "RootUserPermission"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${local.arn_prefix}:iam::${local.account_id}:root"]
    }
    actions   = ["kms:decrypt", "kms:generatedatakey", "kms:encrypt"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = [
      "kms:*",
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["${local.arn_prefix}:events:${local.region}:${local.account_id}:event-bus/${local.eventbus_name}"]
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
  policy                   = try(data.aws_iam_policy_document.kms_policy[0].json, "")
}
