module "example_context" {
  source     = "registry.terraform.io/SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  enabled    = module.context.enabled
  attributes = []
}

module "eventbus_kms_key" {
  source     = "registry.terraform.io/SevenPicoForks/kms-key/aws"
  version    = "2.0.0"
  context    = module.example_context.self
  enabled    = module.context.enabled
  attributes = ["kms", "key"]

  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  description              = "KMS key for ${module.example_context.id}"
  key_usage                = "ENCRYPT_DECRYPT"
  multi_region             = false
  policy                   = ""
}


module "eventbus" {
  source  = "../../"
  context = module.example_context.self

  kms_key_identifier = module.eventbus_kms_key.key_arn
  eventbus_name = "domain"
}