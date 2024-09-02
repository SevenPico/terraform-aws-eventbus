module "eventbus" {
  source  = "../../"
  context = module.context.tags

  eventbus_name = "domain"
}