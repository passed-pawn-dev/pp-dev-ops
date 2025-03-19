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