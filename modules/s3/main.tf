
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  bucket_name = "${var.project_name}-war-${data.aws_caller_identity.current.account_id}"
}

resource "terraform_data" "bucket" {
  input = {
    name       = local.bucket_name
    region     = data.aws_region.current.region
    account_id = data.aws_caller_identity.current.account_id
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<-EOT
      set -euo pipefail

      if aws s3api head-bucket \
        --bucket "$BUCKET" \
        --expected-bucket-owner "$ACCOUNT_ID" \
        --region "$REGION" >/dev/null 2>&1; then

        echo "El bucket ya existe."

      elif [ "$REGION" = "us-east-1" ]; then

        aws s3api create-bucket \
          --bucket "$BUCKET" \
          --region "$REGION"

      else

        aws s3api create-bucket \
          --bucket "$BUCKET" \
          --region "$REGION" \
          --create-bucket-configuration "LocationConstraint=$REGION"

      fi
    EOT

    environment = {
      BUCKET     = self.input.name
      REGION     = self.input.region
      ACCOUNT_ID = self.input.account_id
    }
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "aws s3api delete-bucket --bucket \"$BUCKET\" --region \"$REGION\""

    environment = {
      BUCKET = self.input.name
      REGION = self.input.region
    }
  }
}

resource "aws_s3_bucket_public_access_block" "war" {
  bucket = local.bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [terraform_data.bucket]
}

resource "aws_s3_object" "war" {
  bucket = local.bucket_name

  key          = "app/catalogo-checkout-0.0.1-SNAPSHOT.war"
  source       = var.war_path
  source_hash  = filemd5(var.war_path)
  content_type = "application/java-archive"

  depends_on = [aws_s3_bucket_public_access_block.war]
}
