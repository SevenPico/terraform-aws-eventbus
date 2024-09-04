
module "event_bus_context" {
  source     = "SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  attributes = ["eventbus"]
}

resource "aws_cloudwatch_event_bus" "event_bus" {
  count = module.event_bus_context.enabled ? 1 : 0

  name               = module.event_bus_context.id
  kms_key_identifier = var.kms_key_identifier
  event_source_name  = var.event_source_name

  tags = module.event_bus_context.tags
}

resource "aws_cloudwatch_event_bus_policy" "event_bus_policy" {
  count          = module.context.enabled && var.policy_document != null ? 1 : 0
  policy         = var.policy_document
  event_bus_name = try(aws_cloudwatch_event_bus.event_bus[0].name, "")
}
