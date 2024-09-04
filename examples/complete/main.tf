module "example_context" {
  source     = "registry.terraform.io/SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  enabled    = module.context.enabled
  attributes = []
}

module "eventbus" {
  source  = "../../"
  context = module.example_context.self

  kms_key_identifier = module.eventbus_kms_key.key_arn
  policy_document = try(data.aws_iam_policy_document.eventbus_kms_key_policy[0].json, "")
  eventbus_name = "domain"
}
