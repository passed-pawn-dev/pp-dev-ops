terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.0.0"
    }
  }
}

provider "keycloak" {
    client_id     = "admin-cli"
    username      = var.keycloak_admin_username
    password      = var.keycloak_admin_password
    url           = var.keycloak_url
}

data "keycloak_openid_client" "realm_management" {
  realm_id  = keycloak_realm.realm.id
  client_id = "realm-management"
}

resource "keycloak_realm" "realm" {
  realm             = "passed-pawn"
  enabled           = true
  display_name      = "passed-pawn"
  display_name_html = "<b>passed-pawn</b>"

  login_theme = "base"

  access_code_lifespan = "1h"
}

resource "keycloak_openid_client" "pp_api_client" {
  realm_id            = keycloak_realm.realm.id
  client_id           = "pp-api"
  name                = "pp-api"
  enabled             = true

  access_type         = "CONFIDENTIAL"
  service_accounts_enabled = true
}

variable "pp_api_client_service_account_roles" {
  type    = list(string)
  default = ["manage-events", "realm-admin", "create-client", "view-realm", "view-clients", "query-realms", "view-authorization", "query-groups", "manage-authorization", "manage-clients", "impersonation", "query-clients", "manage-users", "query-users", "view-identity-providers", "manage-identity-providers", "manage-realm", "view-users", "view-events"]
}

resource "keycloak_openid_client_service_account_role" "pp_api_client_service_account_roles" {
  for_each = toset(var.pp_api_client_service_account_roles)
  realm_id                = keycloak_openid_client.pp_api_client.realm_id
  service_account_user_id = keycloak_openid_client.pp_api_client.service_account_user_id
  client_id               = data.keycloak_openid_client.realm_management.id
  role                    = each.value
}

resource "keycloak_oidc_google_identity_provider" "google_oidc_idp" {
  realm         = keycloak_realm.realm.id
  client_id     = var.google_client_id
  client_secret = var.google_client_secret
  trust_email   = true

  extra_config = {
    "myCustomConfigKey" = "myValue"
  }
}