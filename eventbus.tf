
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