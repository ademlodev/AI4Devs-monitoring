# Crear la integración AWS-Datadog
resource "datadog_integration_aws" "main" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = "DatadogAWSIntegrationRole"
}

# Crear el rol IAM para Datadog
resource "aws_iam_role" "datadog" {
  name = "DatadogAWSIntegrationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root" # Cuenta oficial de Datadog
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = datadog_integration_aws.main.external_id
          }
        }
      }
    ]
  })
}

# Adjuntar la política de permisos necesaria para Datadog
resource "aws_iam_role_policy_attachment" "datadog" {
  role       = aws_iam_role.datadog.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Configurar el agente de Datadog en las instancias EC2
resource "aws_ssm_association" "datadog_agent" {
  name = "AWS-ConfigureAWSPackage"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.frontend.id, aws_instance.backend.id]
  }

  parameters = {
    Action = "Install"
    Name   = "datadog-agent"
  }
}

# Obtener la identidad actual de AWS
data "aws_caller_identity" "current" {}