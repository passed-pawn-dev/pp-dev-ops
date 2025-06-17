variable "keycloak_admin_username" {
  type        = string
  description = "Keycloak admin username"
  # don't put sensitive values into source control
  # hides cli output value 
  sensitive = true
}

variable "keycloak_admin_password" {
  type        = string
  description = "Keycloak admin password"
  sensitive   = true
}

variable "pp_api_client_secret" {
  type        = string
  description = "Keycloak api client secret"
  sensitive   = true
}

variable "google_client_id" {
  type        = string
  description = "Google OIDC client id"
}

variable "google_client_secret" {
  type        = string
  description = "Google OIDC client secret"
  sensitive   = true
}

variable "keycloak_url" {
  type        = string
  description = "Keycloak server URL"
}

variable "valid_post_logout_redirect_uris" {
  type        = list(string)
  description = "Allowed post logout redirect uris for the pp-frontend keycloak client"
}

variable "valid_redirect_uris" {
  type        = list(string)
  description = "Allowed redirect uris for the pp-frontend keycloak client"
}

variable "web_origins" {
  type        = list(string)
  description = "Allowed web origins for the pp-frontend keycloak client"
}