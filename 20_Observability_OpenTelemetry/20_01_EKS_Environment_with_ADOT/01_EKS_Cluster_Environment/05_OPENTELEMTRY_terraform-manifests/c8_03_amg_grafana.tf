# AMAZON MANAGED GRAFANA WORKSPACE
resource "aws_grafana_workspace" "main" {
  name                     = "${local.cluster_name}-amg"
  description              = "Grafana workspace for ${local.cluster_name} EKS cluster monitoring"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["SAML"]
  permission_type          = "CUSTOMER_MANAGED"
  role_arn                 = aws_iam_role.amg_iam_role.arn

  data_sources              = ["PROMETHEUS", "CLOUDWATCH", "XRAY"]
  notification_destinations = ["SNS"]

  configuration = jsonencode({
    plugins = {
      pluginAdminEnabled = true
    }
    unifiedAlerting = {
      enabled = true
    }
  })

  tags = var.tags
}

# SAML Configuration (required for SAML auth)
resource "aws_grafana_workspace_saml_configuration" "main" {
  workspace_id = aws_grafana_workspace.main.id

  # Role mappings (adjust according to your IdP groups later)
  admin_role_values  = ["GrafanaAdmin", "admin"]
  editor_role_values = ["GrafanaEditor", "editor"]

  # Common assertion settings
  role_assertion   = "groups"   # or "role" depending on your IdP
  groups_assertion = "groups"

  # TODO: Replace with your real Identity Provider metadata
  # Option 1: URL (recommended)
  # idp_metadata_url = "https://your-idp.example.com/saml/metadata"

  # Option 2: XML file
  # idp_metadata_xml = file("${path.module}/idp_metadata.xml")
}

# Outputs
output "amg_workspace_id" {
  description = "ID of the Grafana workspace"
  value       = aws_grafana_workspace.main.id
}

output "amg_workspace_arn" {
  description = "ARN of the Grafana workspace"
  value       = aws_grafana_workspace.main.arn
}

output "amg_workspace_endpoint" {
  description = "Endpoint URL for the Grafana workspace"
  value       = aws_grafana_workspace.main.endpoint
}

output "amg_workspace_url" {
  description = "Full URL to access Grafana workspace"
  value       = "https://${aws_grafana_workspace.main.endpoint}"
}