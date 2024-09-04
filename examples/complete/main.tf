module "example_context" {
  source     = "registry.terraform.io/SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  enabled    = module.context.enabled
  attributes = []
}

data "aws_iam_policy_document" "eventbus_policy" {
  count = module.example_context.enabled ? 1 : 0
  statement {
    sid    = "DevAccountAccess"
    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      "${local.arn_prefix}:events:${local.account_id}:event-bus/default"
    ]

    principals {
      type        = "AWS"
      identifiers = [local.account_id]
    }
  }
}

module "eventbus" {
  source  = "../../"
  context = module.example_context.self

  eventbus_name      = "domain"
  kms_key_identifier = module.eventbus_kms_key.key_arn
  policy_document    = try(data.aws_iam_policy_document.eventbus_policy[0].json, "")
}
